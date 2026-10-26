---
title: 信息论
description: 先用熵量不确定性，再用互信息量关系，最后用 KL 散度量两个分布的差距
---

# 信息论

> 按认知顺序学：先会量不确定性（熵）→ 再量两个变量共多少信息（互信息）→ 最后量两个分布差多少代价（KL 散度）。

---

## 📚 内容导航

| 名称 | 说明 | 链接 |
|------|------|------|
| 信息熵 | 平均编码长度；交叉熵损失、生成采样与特征筛选的同一把尺 | [进入](01-information-entropy.md) |
| 互信息 | 知道 X 后 Y 少多少不确定；线性相关看不出的关系它能看出 | [进入](02-mutual-information.md) |
| KL 散度 | 用 q 近似 p 多付的代价；前向/反向决定模型是保覆盖还是抓主模式 | [进入](03-kl-divergence.md) |

---

## 🎯 按问题找答案

| 你想解决的问题 | 先看 |
|----------------|------|
| 交叉熵损失、温度采样、模型过度自信 | [信息熵](01-information-entropy.md) |
| 特征选哪个、相关性近 0 却明显有关 | [互信息](02-mutual-information.md) |
| 知识蒸馏/VAE 选哪个方向、分布漂移监控 | [KL 散度](03-kl-divergence.md) |

---

## 🔗 相关链接

| 主题 | 链接 |
|------|------|
| 上一级 | [打开](../index.md) |
| 微积分 | [打开](../calculus/index.md) |
| 离散数学 | [打开](../discrete-math/index.md) |
| 线性代数 | [打开](../linear-algebra/index.md) |
| 优化理论 | [打开](../optimization/index.md) |
| 概率论与数理统计 | [打开](../probability-statistics/index.md) |
