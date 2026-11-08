// 构建期把「今日日期 + 星期」注入 content/resource/homework.md 的 # 近日作业（...）标题
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
const dateStr = `${parts.year}年${Number(parts.month)}月${Number(parts.day)}日，${weekdays[parts.weekday]}`;

const before = text;
text = text.replace(/^(#\s*近日作业（)[^）]*）/m, (_m, p1) => `${p1}${dateStr}）`);
if (text === before) {
  console.error(`WARN: 未找到近日作业标题（${file}）`);
  process.exit(0);
}
fs.writeFileSync(file, text);
console.log(`homework date updated to: ${dateStr}`);
