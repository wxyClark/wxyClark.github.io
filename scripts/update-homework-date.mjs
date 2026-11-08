// 构建期把「今日日期 + 星期」写入 content/resource/homework.md 的 # 今日作业 标题下方的日期行
// 按 Asia/Shanghai 时区取日期，保证定时任务在北京午夜后运行也显示正确当天
import fs from "node:fs";
import path from "node:path";

const file = path.resolve(process.cwd(), "content/resource/homework.md");
let text = fs.readFileSync(file, "utf8");

const fmt = new Intl.DateTimeFormat("en-US", {
  timeZone: "Asia/Shanghai",
  year: "numeric", month: "numeric", day: "numeric", weekday: "long",
});
const parts = Object.fromEntries(
  fmt.formatToParts(new Date()).map((p) => [p.type, p.value])
);
const weekdays = {
  Sunday: "星期日", Monday: "星期一", Tuesday: "星期二", Wednesday: "星期三",
  Thursday: "星期四", Friday: "星期五", Saturday: "星期六",
};
const dateStr = `${parts.year}年${Number(parts.month)}月${Number(parts.day)}日 ${weekdays[parts.weekday]}`;

const lines = text.split("\n");
// 恰好 H1「# 今日作业」（避免误匹配 ## 或带后缀的标题）
const hi = lines.findIndex((l) => /^#\s+今日作业\s*$/.test(l));
if (hi === -1) {
  console.error(`ERROR: 未找到「# 今日作业」标题（${file}）——请检查 homework.md 结构`);
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
console.log(`homework date updated to: ${dateStr}`);
