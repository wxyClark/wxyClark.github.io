---
title: 嵌入式与单片机
description: 微控制器架构、中断系统与外设、实时操作系统三篇核心笔记，按「硬件底座→硬件事件→并发与实时」的认知顺序组织
---

# 嵌入式与单片机

> 按认知顺序学：**先搞清楚代码跑在什么物理机上**（架构与存储器）→ **再看硬件事件如何打断执行**（中断与外设）→ **最后管理并发与实时性**（RTOS 与可靠性）。

---

## 📚 内容导航

| 名称 | 说明 | 链接 |
|------|------|------|
| 微控制器架构 | 存储器映射、栈预算、启动流程、时钟与功耗、最小系统、HardFault | [进入](01-microcontroller-architecture.md) |
| 中断系统与外设 | 中断响应与优先级、ISR 铁律、GPIO/定时器/ADC/UART-I2C-SPI/DMA | [进入](02-interrupts-and-peripherals.md) |
| 实时操作系统与可靠性 | 截止期与抖动、任务与优先级、同步原语、看门狗与故障降级、选型 | [进入](03-rtos-and-realtime.md) |

---

## 🎯 按问题找答案

| 你想解决的问题 | 先看 |
|----------------|------|
| 随机复位、跑飞、偶发死机 | [微控制器架构](01-microcontroller-architecture.md) 栈与上电可靠性 |
| 休眠电流降不下来 | [微控制器架构](01-microcontroller-architecture.md) 时钟树与低功耗 |
| 全局变量初值不生效、OTA 后变砖 | [微控制器架构](01-microcontroller-architecture.md) 启动流程与向量表 |
| 中断一进不停、丢数据 | [中断系统与外设](02-interrupts-and-peripherals.md) ISR 四条铁律 |
| ADC 抖动、UART 丢字节、I2C 卡死 | [中断系统与外设](02-interrupts-and-peripherals.md) 外设分节 |
| CPU 占用高、采样跟不上 | [中断系统与外设](02-interrupts-and-peripherals.md) DMA 一节 |
| 任务不响应、栈溢出、优先级反转 | [实时操作系统与可靠性](03-rtos-and-realtime.md) |
| 该用裸机、RTOS 还是 Linux | [实时操作系统与可靠性](03-rtos-and-realtime.md) 选型一节 |

---

## 🔗 相关链接

| 主题 | 链接 |
|------|------|
| 上一级 | [打开](../index.md) |
| 计算机体系结构 | [打开](../computer-architecture/index.md) |
| 芯片设计 | [打开](../chip-design/index.md) |
| 操作系统与进程模型 | [打开](../../fundamentals/software/01-operating-systems.md) |
| 机器人系统 | [打开](../../applications/intelligent-systems/robotics/index.md) |
