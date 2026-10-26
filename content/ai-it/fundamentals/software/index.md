---
title: 软件工程
description: 从需求到监控的软件开发全生命周期，每站只讲解决 80% 问题的 20% 核心
---

# 软件工程

> 用一条主线串起八道关卡：需求 → 系统分析 → 架构 → 前端/后端 → 测试 → 部署 → 运维 → 监控；主线之下有两块底座：**机器怎么执行代码**（操作系统）、**代码怎么保持可改**（开发艺术与设计模式）。

---

## 📚 内容导航

| 名称 | 说明 | 链接 |
|------|------|------|
| 全生命周期总论 | 八道关卡、三个成本杠杆、质量门禁 | [进入](00-software-engineering-overview.md) |
| 操作系统与进程模型 | 进程/线程/协程、虚拟内存、页缓存与文件系统、I/O 模型 | [进入](01-operating-systems.md) |
| 需求分析 | 三层需求、验收标准、非功能指标 | [进入](02-requirements-analysis.md) |
| 系统分析 | 领域模型、状态机、接口契约、事务边界 | [进入](03-system-analysis.md) |
| 架构设计 | 边界划分、依赖方向、单体与微服务、ADR | [进入](04-architecture-design.md) |
| 前端开发 | 渲染模式、组件与状态、性能预算、五态 | [进入](05-frontend-engineering.md) |
| 后端开发 | 分层、事务与幂等、缓存、队列、限流 | [进入](06-backend-engineering.md) |
| 测试策略 | 70/20/10 分层、用例设计、覆盖率、门禁 | [进入](07-testing-strategy.md) |
| 部署与发布 | 不可变制品、灰度、数据迁移、回滚 | [进入](08-deployment-release.md) |
| 运维与 SRE | SLO、错误预算、应急四段、备份恢复 | [进入](09-operations-sre.md) |
| 可观测性 | 三支柱、黄金信号、告警设计、看板分层 | [进入](10-observability-monitoring.md) |
| 设计模式 | OOP 四特性与常用模式的适用信号 | [进入](11-oop-design-patterns.md) |
| 代码规范 | 格式化工具、复杂度阈值、注释与提交 | [进入](12-code-standards.md) |
| 性能优化 | 分层排查、缓存、数据库与压测验证 | [进入](13-performance-optimization.md) |
| 容器化与 CI/CD | Docker、K8s、流水线与门禁 | [进入](14-containerization-cicd.md) |
| 技术团队管理 | 授权、估算、会议、绩效与决策 | [进入](15-technical-team-management.md) |
| 持续学习 | 输出驱动、T 型发展、技术选型 | [进入](16-continuous-learning.md) |
| 软件开发的艺术 | 可读性判据、坏味道到重构手法、技术债的利息计量 | [进入](17-software-craftsmanship.md) |

---

## 🎯 按问题找答案

| 你想解决的问题 | 先看 |
|----------------|------|
| 需求总是返工、验收扯皮 | [需求分析](02-requirements-analysis.md) |
| 系统内部结构理不清 | [系统分析](03-system-analysis.md) |
| 代码越改越乱、边界不清 | [架构设计](04-architecture-design.md) |
| 页面状态缺失、首屏慢 | [前端开发](05-frontend-engineering.md) |
| 接口不稳、数据错乱 | [后端开发](06-backend-engineering.md) |
| 不敢改代码、测试写不动 | [测试策略](07-testing-strategy.md) |
| 代码越改越乱、重构排不上期 | [软件开发的艺术](17-software-craftsmanship.md) |
| OOM、磁盘满、fd 耗尽等系统级报错 | [操作系统与进程模型](01-operating-systems.md) |
| 要不要上设计模式、用哪个 | [设计模式](11-oop-design-patterns.md) |
| 上线像拆炸弹 | [部署与发布](08-deployment-release.md) |
| 稳定性说不清、故障靠救火 | [运维与 SRE](09-operations-sre.md) |
| 出事只能等投诉 | [可观测性](10-observability-monitoring.md) |

---

## 🔗 相关链接

| 主题 | 链接 |
|------|------|
| 上一级 | [基础知识](../index.md) |
| 计算基础 | [算法与语言](../computing/index.md) |
| 数据基础 | [数据库与缓存](../../data-fundamentals/index.md) |
| 网络基础 | [HTTP 与网络安全](../../network-fundamentals/index.md) |
| AI 辅助开发 | [AI 工程实践](../../ai-core/engineering/03-ai-assisted-software-development.md) |
