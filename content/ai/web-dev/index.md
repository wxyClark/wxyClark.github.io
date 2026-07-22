---
title: AI辅助开发体系
description: 基于 Laravel/Filament 的 AI 辅助开发完整体系
date: 2026-07-22
---

# AI辅助开发体系

一套完整的、系统化的 AI 辅助开发框架，覆盖从需求到部署的全生命周期。

## 核心理念

```
需求 → 理解(多轮) → 增强 → 确认 → 执行 → 验证
```

## 体系架构

### 7层架构

| 层级 | 内容 | 文档 |
|------|------|------|
| 战略层 | 工具链、工作流、质量保证 | [工作流](workflow/) |
| 战术层 | 度量、风险管理 | [标准](standards/) |
| 执行层 | 代码规范、测试策略 | [实践](practices/) |
| 支持层 | 团队、培训、知识管理 | [测试](testing/) |
| 优化层 | 性能、安全 | [性能](performance/) |
| 自动化层 | 任务拆分、执行 | [自动化](automation/) |
| 示例层 | 标准代码参考 | [示例](examples/) |

## 快速开始

### 1. 环境要求

- PHP 8.5+
- Laravel 12
- Filament 3.x
- MySQL 8.4
- Redis

### 2. 核心工作流

```bash
# 代码质量检查顺序
pint → phpstan → pest

# 快速验证
./vendor/bin/pint --test
./vendor/bin/phpstan analyse
./vendor/bin/pest --compact
```

### 3. TDD 流程

```
需求分析 → 架构设计 → 数据库设计 → 先写测试 → 实现代码 → 重构优化 → 架构测试 → 联调验证
```

## 文档结构

```
web-dev/
├── workflow/          # 工作流和流程
├── standards/         # 代码标准和规范
├── practices/         # 最佳实践
├── testing/           # 测试策略
├── performance/       # 性能和安全
├── automation/        # 自动化任务
└── examples/          # 示例代码
```

## 核心原则

1. **先理解后实现**：多轮对话挖掘需求
2. **测试先行**：TDD 保证质量
3. **质量门禁**：pint → phpstan → pest
4. **复用优先**：参考现有模式
5. **文档驱动**：PRD → 设计 → 开发 → 测试
