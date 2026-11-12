// 构建期同步「今日日期」到页面元数据和正文日期行，避免 Quartz 使用旧的 git 修改时间。
// 按 Asia/Shanghai 时区取日期，保证定时任务在北京午夜后运行也显示正确当天。
import fs from "node:fs";
import path from "node:path";

const file = path.resolve(process.cwd(), "content/resource/homework.md");
const text = fs.readFileSync(file, "utf8");

const fmt = new Intl.DateTimeFormat("en-US", {
  timeZone: "Asia/Shanghai",
  year: "numeric", month: "numeric", day: "numeric", weekday: "long",
});
const parts = Object.fromEntries(
  fmt.formatToParts(new Date()).map((p) => [p.type, p.value])
);
const year = parts.year;
const month = String(Number(parts.month)).padStart(2, "0");
const day = String(Number(parts.day)).padStart(2, "0");
const isoDate = `${year}-${month}-${day}`;
const weekdays = {
  Sunday: "星期日", Monday: "星期一", Tuesday: "星期二", Wednesday: "星期三",
  Thursday: "星期四", Friday: "星期五", Saturday: "星期六",
};
const dateStr = `${year}年${Number(parts.month)}月${Number(parts.day)}日 ${weekdays[parts.weekday]}`;

let lines = text.split("\n");

// Quartz 默认按 modified 日期展示页面日期。明确设置 frontmatter date，
// 使页面日期与正文的「今日作业」日期一致，而不是沿用上次 git 修改时间。
if (lines[0] === "---") {
  const end = lines.indexOf("---", 1);
  if (end === -1) {
    console.error(`ERROR: homework.md 的 frontmatter 未闭合（${file}）`);
    process.exit(1);
  }
  const dateIndex = lines.findIndex((line, index) => index > 0 && index < end && /^date:\s*/.test(line));
  if (dateIndex === -1) {
    lines.splice(end, 0, `date: ${isoDate}`);
  } else {
    lines[dateIndex] = `date: ${isoDate}`;
  }
} else {
  lines = ["---", "title: 今日作业", `date: ${isoDate}`, "---", "", ...lines];
}

// 恰好 H1「# 今日作业」（避免误匹配 ## 或带后缀的标题）
const hi = lines.findIndex((line) => /^#\s+今日作业\s*$/.test(line));
if (hi === -1) {
  console.error(`ERROR: 未找到「# 今日作业」标题（${file}���——请检查 homework.md 结构`);
  process.exit(1);
}
// 标题下方第一个非空行即日期行，覆写为今日日期（若该行不是日期格式则报警，避免误砸）
let di = hi + 1;
while (di < lines.length && lines[di].trim() === "") di++;
if (di >= lines.length || !/^[0-9]{4}年/.test(lines[di].trim())) {
  console.error(`ERROR: 「# 今日作业」标题后未找到日期行（${file}）`);
  process.exit(1);
}
lines[di] = dateStr;
fs.writeFileSync(file, lines.join("\n"));
console.log(`homework page date updated to: ${isoDate} (${dateStr})`);
