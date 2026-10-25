#!/usr/bin/env node
/**
 * 知识库内容校验（无依赖，Node >= 18）
 *
 * 校验项：
 *   1. frontmatter：必须含 title + description
 *   2. 命名：目录小写连字符；正文为 NN-topic.md；同目录编号不重复
 *   3. 结构：目录内不得混放 .md 与子目录；有内容的目录必须有 index.md
 *   4. 正文：必须以 # 开头（防止截断）；不得残留「待补充」占位
 *   5. 链接：只用相对路径，且目标必须存在
 *   6. index 同步：index.md 必须链接到同目录全部子项
 *   7. Mermaid：图表类型可识别、代码块不缩进、标签不跨行/特殊字符加引号、block 配平
 *
 * 用法：node scripts/lint-content.mjs [--strict]
 *   --strict 时警告也视为失败
 */

import fs from "node:fs";
import path from "node:path";
import process from "node:process";

const ROOT = path.resolve(process.cwd(), "content");
const STRICT = process.argv.includes("--strict");

/** 资源与模板目录不参与内容规范校验 */
const EXEMPT = ["resource/"];
/** index.md 作为 Hub 页的长度上限 */
const HUB_MAX_LINES = 80;

const errors = [];
const warnings = [];

const err = (file, msg) => errors.push({ file, msg });
const warn = (file, msg) => warnings.push({ file, msg });

const toPosix = (p) => p.split(path.sep).join("/");

function walk(dir, out = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (entry.name.startsWith(".") || entry.name === "node_modules") continue;
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) walk(full, out);
    else if (entry.name.endsWith(".md")) out.push(full);
  }
  return out;
}

function read(file) {
  return fs.readFileSync(file, "utf8");
}

function splitFrontMatter(text) {
  const match = text.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?/);
  if (!match) return { fm: null, body: text };
  return { fm: match[1], body: text.slice(match[0].length) };
}

function field(fm, name) {
  const match = fm.match(new RegExp(`^${name}:\\s*(.*)$`, "m"));
  return match ? match[1].trim().replace(/^["']|["']$/g, "") : "";
}

const files = walk(ROOT);
const rels = files.map((f) => toPosix(path.relative(ROOT, f)));
const isExempt = (rel) => EXEMPT.some((prefix) => rel.startsWith(prefix));

const LINK = /\[[^\]]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)/g;

/* ---------- Mermaid 校验 ---------- */
const MERMAID_TYPES = new Set([
  "graph",
  "flowchart",
  "sequencediagram",
  "classdiagram",
  "statediagram",
  "statediagram-v2",
  "erdiagram",
  "gantt",
  "pie",
  "journey",
  "timeline",
  "mindmap",
  "quadrantchart",
  "xychart-beta",
  "block-beta",
  "gitgraph",
  "sankey-beta",
]);
const MERMAID_KEYWORDS = new Set([
  "end",
  "graph",
  "flowchart",
  "subgraph",
  "style",
  "class",
  "classdef",
  "click",
  "linkstyle",
  "direction",
  "default",
]);
const MERMAID_SKIP = /^(%%|style\b|classDef\b|class\b|linkStyle\b|click\b|direction\b|end$|subgraph\b|graph\b|flowchart\b)/;
/** 这几类图的中文必须加双引号（mermaid 11.4 词法层不支持裸 CJK） */
const QUOTE_REQUIRED = new Set(["quadrantchart", "erdiagram", "pie"]);

function checkNonAsciiQuoting(rel, startLine, body, type) {
  body.forEach((raw, k) => {
    const ln = startLine + k;
    const text = raw.trim();
    if (!text || text.startsWith("%%")) return;
    if (/^(title|accTitle|accDescr|classDef|(pie|erDiagram|quadrantChart)\b)/.test(text)) return;
    const payload = text.replace(/"[^"]*"/g, "");
    if (!/[^\x00-\x7F]/.test(payload)) return;
    err(rel, `第 ${ln} 行 ${type} 的中文必须加双引号：${text.slice(0, 40)}`);
  });
}

/** 双引号内的内容替换为等长占位符，只保留结构字符 */
function maskQuoted(line) {
  let out = "";
  let inQuote = false;
  for (const ch of line) {
    if (ch === '"') {
      inQuote = !inQuote;
      out += ch;
      continue;
    }
    out += inQuote ? "x".repeat(ch.length) : ch;
  }
  return out;
}

function checkMermaidBlock(rel, startLine, body) {
  const first = body.find((line) => line.trim() && !line.trim().startsWith("%%"));
  if (!first) {
    err(rel, `第 ${startLine} 行 mermaid 块为空`);
    return;
  }
  const type = first.trim().split(/\s+/)[0].toLowerCase();
  if (!MERMAID_TYPES.has(type)) {
    err(rel, `第 ${startLine} 行 mermaid 图表类型无法识别：「${type}」`);
    return;
  }

  const isGraph = type === "graph" || type === "flowchart";
  const needsBlock = isGraph || type === "sequencediagram" || type === "classdiagram" || type === "statediagram-v2";
  let depth = 0;

  if (QUOTE_REQUIRED.has(type)) checkNonAsciiQuoting(rel, startLine, body, type);

  for (const [offset, raw] of body.entries()) {
    const ln = startLine + offset;
    const text = raw.trim();
    if (!text || text.startsWith("%%")) continue;
    const mask = maskQuoted(text);

    if (/^%(?!%)/.test(text)) err(rel, `第 ${ln} 行 mermaid 注释必须写成 %%`);

    if (needsBlock) {
      if (/^(subgraph|alt|loop|opt|par|critical|break|rect|box)\b/.test(text) || /^state\b.*\{$/.test(text) || /^class\s+\S+\s*\{$/.test(text)) {
        depth++;
      } else if (/^(end|\})\s*$/.test(text)) {
        depth--;
        if (depth < 0) {
          err(rel, `第 ${ln} 行 mermaid 出现多余的 end/}`);
          depth = 0;
        }
      }
    }

    if (isGraph && type === "xychart-beta") continue;
    if (type === "sequencediagram") {
      if (/(->>|-->>|->|-->|-x|--x|-\))/.test(text) && !text.includes(":") && !/^(participant|actor|note|activate|deactivate)\b/i.test(text)) {
        err(rel, `第 ${ln} 行 mermaid 时序消息缺少「: 说明」`);
      }
      continue;
    }
    if (!isGraph || MERMAID_SKIP.test(text)) continue;

    // 边标签 |...| 必须成对
    if ((mask.match(/\|/g) || []).length % 2 !== 0) {
      err(rel, `第 ${ln} 行 mermaid 边标签 | 不成对：${text.slice(0, 50)}`);
    }

    // 节点标签：必须单行、特殊字符加双引号
    let i = 0;
    while (i < mask.length) {
      const ch = mask[i];
      const closeCh = ch === "[" ? "]" : ch === "{" ? "}" : ch === "(" ? ")" : "";
      if (!closeCh) {
        i++;
        continue;
      }
      const close = mask.indexOf(closeCh, i + 1);
      if (close < 0) {
        err(rel, `第 ${ln} 行 mermaid 标签未闭合（标签不能跨行）：${text.slice(0, 50)}`);
        break;
      }
      const label = text.slice(i + 1, close).trim();
      const quoted = label.startsWith('"') && label.endsWith('"');
      if (!label) {
        err(rel, `第 ${ln} 行 mermaid 节点文本为空`);
      } else if (!quoted) {
        const bad = [];
        if (/[()]/.test(label)) bad.push("半角括号");
        if (/[\[\]{}]/.test(label)) bad.push("方/花括号");
        if (/["|;]/.test(label)) bad.push("引号/竖线/分号");
        if (/\bend\b/.test(label)) bad.push("end 关键字");
        if (bad.length) {
          err(rel, `第 ${ln} 行 mermaid 标签含${bad.join("、")}，需用双引号包裹：${label.slice(0, 40)}`);
        }
      }
      const idMatch = /([A-Za-z_\u4e00-\u9fa5][\w\u4e00-\u9fa5]*)\s*$/.exec(mask.slice(0, i));
      if (idMatch && MERMAID_KEYWORDS.has(idMatch[1].toLowerCase())) {
        err(rel, `第 ${ln} 行 mermaid 用关键字「${idMatch[1]}」作节点名`);
      }
      i = close + 1;
    }
  }

  if (depth > 0) err(rel, `第 ${startLine} 行 mermaid 有 ${depth} 个 subgraph/alt/class 块未闭合`);
  if (type === "xychart-beta" && !body.some((line) => /^\s*(bar|line)\s*\[/.test(line))) {
    err(rel, `第 ${startLine} 行 xychart-beta 缺少 bar/line 数据行`);
  }
}

function checkMermaid(rel, lines) {
  let i = 0;
  while (i < lines.length) {
    if (!/^\s*```mermaid\s*$/.test(lines[i])) {
      i++;
      continue;
    }
    if (/^\s+```mermaid/.test(lines[i])) {
      err(rel, `第 ${i + 1} 行 mermaid 代码块有缩进，站点不会渲染`);
    }
    let end = i + 1;
    while (end < lines.length && !/^\s*```\s*$/.test(lines[end])) end++;
    if (end >= lines.length) {
      err(rel, `第 ${i + 1} 行 mermaid 代码块缺少结束 \`\`\``);
      return;
    }
    checkMermaidBlock(rel, i + 2, lines.slice(i + 1, end));
    i = end + 1;
  }
}

/* ---------- 逐文件校验 ---------- */
const titles = new Map();

for (const file of files) {
  const rel = toPosix(path.relative(ROOT, file));
  const text = read(file);
  const { fm, body } = splitFrontMatter(text);
  const lines = text.split("\n");

  // 1. frontmatter
  if (!isExempt(rel)) {
    if (!fm) {
      err(rel, "缺少 frontmatter（需 title + description）");
    } else {
      const title = field(fm, "title");
      const description = field(fm, "description");
      if (!title) err(rel, "frontmatter 缺少 title");
      if (!description) err(rel, "frontmatter 缺少 description");
      if (title) {
        if (!titles.has(title)) titles.set(title, []);
        titles.get(title).push(rel);
      }
    }
  }

  // 2. 文件名规范
  const base = path.basename(file);
  if (!isExempt(rel) && base !== "index.md" && !/^\d{2}-[a-z0-9-]+\.md$/.test(base)) {
    err(rel, `文件名不符合 NN-topic.md 规范：${base}`);
  }

  // 4. 正文完整性
  const firstLine = body.split("\n").find((line) => line.trim() !== "");
  if (firstLine && firstLine.trimStart().startsWith("##")) {
    err(rel, "正文以二级标题开头，疑似被截断（应从 # 一级标题开始）");
  }
  const placeholder = (text.match(/待补充/g) || []).length;
  if (placeholder > 0 && !isExempt(rel)) {
    warn(rel, `含 ${placeholder} 处「待补充」占位`);
  }

  // Hub 页长度
  if (base === "index.md" && !isExempt(rel) && lines.length > HUB_MAX_LINES) {
    warn(rel, `Hub 页 ${lines.length} 行，超过 ${HUB_MAX_LINES} 行上限，建议拆出 Note`);
  }

  // 7. Mermaid 图语法（含 resource/，图表坏了就是坏页）
  checkMermaid(rel, lines);

  // 5. 链接（资源与模板目录不参与）
  if (isExempt(rel)) continue;
  for (const match of text.matchAll(LINK)) {
    const target = match[1].trim();
    if (/^(https?:|mailto:|tel:|#)/.test(target)) continue;
    if (target.startsWith("/")) {
      err(rel, `使用了根绝对路径链接（应为相对路径）：${target}`);
      continue;
    }
    const clean = target.split("#")[0].split("?")[0];
    if (!clean) continue;
    const resolved = path.resolve(path.dirname(file), decodeURIComponent(clean));
    if (!fs.existsSync(resolved)) {
      err(rel, `链接目标不存在：${target}`);
    }
  }
}

/* ---------- 目录级校验 ---------- */
const dirs = new Set();
for (const file of files) {
  let dir = path.dirname(file);
  while (toPosix(path.relative(ROOT, dir)) !== "." && dir.startsWith(ROOT)) {
    dirs.add(dir);
    dir = path.dirname(dir);
  }
}
dirs.add(ROOT);

for (const dir of dirs) {
  const relDir = toPosix(path.relative(ROOT, dir));
  if (relDir === ".") continue;
  if (EXEMPT.some((prefix) => (relDir + "/").startsWith(prefix))) continue;

  const entries = fs.readdirSync(dir, { withFileTypes: true });
  const mdFiles = entries.filter((e) => e.isFile() && e.name.endsWith(".md"));
  const subDirs = entries.filter((e) => e.isDirectory() && !e.name.startsWith("."));
  const noteFiles = mdFiles.filter((e) => e.name !== "index.md");

  // 2. 目录命名
  if (!/^[a-z0-9.-]+$/.test(path.basename(dir))) {
    err(relDir + "/", `目录名不符合小写连字符规范：${path.basename(dir)}`);
  }

  // 3. 结构一致性
  if (noteFiles.length > 0 && subDirs.length > 0) {
    err(relDir + "/", "同一目录下混放了 .md 文件与子目录");
  }
  if ((mdFiles.length > 0 || subDirs.length > 0) && !mdFiles.some((e) => e.name === "index.md")) {
    err(relDir + "/", "缺少 index.md");
  }

  // 2. 编号唯一
  const seen = new Map();
  for (const note of noteFiles) {
    const prefix = note.name.slice(0, 2);
    if (!/^\d{2}$/.test(prefix)) continue;
    if (seen.has(prefix)) {
      err(relDir + "/", `编号 ${prefix} 重复：${seen.get(prefix)} 与 ${note.name}`);
    } else {
      seen.set(prefix, note.name);
    }
  }

  // 6. index 同步
  const indexFile = path.join(dir, "index.md");
  if (!fs.existsSync(indexFile)) continue;
  const indexText = read(indexFile);
  const linked = new Set();
  for (const match of indexText.matchAll(LINK)) {
    const target = match[1].trim();
    if (/^(https?:|mailto:|tel:|#)/.test(target)) continue;
    linked.add(toPosix(path.normalize(target.split("#")[0].split("?")[0])));
  }
  for (const entry of [...noteFiles, ...subDirs]) {
    const name = entry.name;
    if (EXEMPT.some((prefix) => (name + "/").startsWith(prefix))) continue;
    const candidates =
      entry.isDirectory()
        ? [`${name}/index.md`, `${name}/`, name]
        : [name];
    if (!candidates.some((c) => linked.has(c))) {
      err(toPosix(path.relative(ROOT, indexFile)), `index.md 未链接到子项：${name}`);
    }
  }
}

/* ---------- 重复标题 ---------- */
for (const [title, list] of titles) {
  if (list.length > 1) {
    warn(list[0], `标题「${title}」重复出现于：${list.join("、")}`);
  }
}

/* ---------- 输出 ---------- */
const print = (label, list) => {
  if (list.length === 0) return;
  console.log(`\n${label}（${list.length}）`);
  const byFile = new Map();
  for (const item of list) {
    if (!byFile.has(item.file)) byFile.set(item.file, []);
    byFile.get(item.file).push(item.msg);
  }
  for (const [file, msgs] of [...byFile.entries()].sort()) {
    console.log(`  ${file}`);
    for (const msg of msgs) console.log(`    - ${msg}`);
  }
};

console.log(`检查 ${files.length} 个文件 / ${dirs.size} 个目录`);
print("❌ 错误", errors);
print("⚠️  警告", warnings);

const failed = errors.length > 0 || (STRICT && warnings.length > 0);
console.log(
  `\n结果：${errors.length} 个错误，${warnings.length} 个警告 —— ${failed ? "未通过" : "通过"}`,
);
process.exit(failed ? 1 : 0);
