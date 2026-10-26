---
title: 优化理论
description: 先学没有护栏的局部方法（梯度下降），再学有全局保证的凸优化，训练里的调参问题都能归位
---

# 优化理论

> 按认知顺序学：先拿无约束问题练手（梯度、步长、噪声）→ 再给问题加凸性与约束（全局最优、对偶、KKT）。

---

## 📚 内容导航

| 名称 | 说明 | 链接 |
|------|------|------|
| 无约束优化 | 学习率、梯度噪声 `σ²/B`、条件数与鞍点：训练不收敛的第一现场 | [进入](01-unconstrained-optimization.md) |
| 凸优化 | 一旦凸，局部就是全局；对偶乘子还会告诉你哪个约束最贵 | [进入](02-convex-optimization.md) |

---

## 🎯 按问题找答案

| 你想解决的问题 | 先看 |
|----------------|------|
| loss 不降、NaN、学习率与 batch 怎么联动 | [无约束优化](01-unconstrained-optimization.md) |
| SGD 与 Adam 怎么选、何时早停 | [无约束优化](01-unconstrained-optimization.md) |
| 要不要上复杂模型、正则项在干什么 | [凸优化](02-convex-optimization.md) |
| 排产/调度类问题报告不可行或无界 | [凸优化](02-convex-optimization.md) |

---

## 🔗 相关链接

| 主题 | 链接 |
|------|------|
| 上一级 | [打开](../index.md) |
| 微积分 | [打开](../calculus/index.md) |
| 离散数学 | [打开](../discrete-math/index.md) |
| 信息论 | [打开](../information-theory/index.md) |
| 线性代数 | [打开](../linear-algebra/index.md) |
| 概率论与数理统计 | [打开](../probability-statistics/index.md) |
