---
title: GPU并行计算
description: GPU 只留能用的 20%：先判瓶颈（Roofline），再治占用率、带宽与分支发散三个陷阱
---

# GPU并行计算

> 一句话：GPU 快不快取决于你是在算还是在搬数据；先算清瓶颈再改内核。

---

## 📚 内容导航

| 名称 | 说明 | 链接 |
|------|------|------|
| GPU 并行计算核心 20% | SIMT 模型、Roofline 判断、占用率三约束、访存合并 | [进入](01-essentials.md) |

---

## 🔗 相关链接

| 主题 | 链接 |
|------|------|
| 硬件基础概览 | [硬件基础](../index.md) |
| 计算机体系结构 | [计算机体系结构](../computer-architecture/index.md) |
| AI核心理论 | [AI核心知识体系](../../ai-core/theory/index.md) |
