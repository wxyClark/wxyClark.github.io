---
title: 工作流和流程
description: AI辅助开发的标准工作流程
date: 2026-07-22
---

# 工作流和流程

## 标准工作流（5步）

```
用户提示词 → 1.理解 → 2.增强 → 3.确认 → 4.执行 → 5.验证
```

### 步骤 1：理解（多轮对话挖掘）

**目标**: 通过多轮对话深度理解需求，挖掘隐含需求

**对话框架**:

```
Phase 1: 初始理解 (1-2轮)
├── 核心功能是什么？
├── 使用角色有哪些？
└── 有参考来源吗？

Phase 2: 深度挖掘 (3-5轮)
├── 数据生命周期？
├── 权限边界？
├── 异常场景？
├── 性能预期？
└── 集成需求？

Phase 3: 逻辑验证 (2-3轮)
├── 状态机完整性？
├── 权限覆盖？
├── 数据一致性？
├── 并发安全？
└── 边界完整？

Phase 4: 全局一致性 (1-2轮)
├── 术语一致？
├── 数据模型一致？
├── 状态一致？
├── 权限一致？
└── 风格一致？

Phase 5: 文档沉淀 (1轮)
├── 输出需求文档
├── 记录对话摘要
└── 列出待确认事项
```

**追问技巧**:

| 技巧 | 示例 |
|------|------|
| 5W1H | Who/What/When/Where/Why/How |
| 场景化 | "如果用户在XX情况下会怎样？" |
| 边界测试 | "数据量很大时怎么处理？" |
| 异常流程 | "如果API调用失败了呢？" |

### 步骤 2：增强

**目标**: 读取 PRD/rules/skills，形成结构化提示词

**增强内容**:
- 读取相关 PRD 文档
- 应用代码规范规则
- 参考现有实现模式
- 识别复用机会

### 步骤 3：确认

**目标**: 呈现增强后的提示词，有模糊处提出疑问

**确认内容**:
- 需求理解是否正确
- 技术方案是否合理
- 是否有遗漏点
- 预估工作量

### 步骤 4：执行

**目标**: 用户确认后，按约束条件编写代码

**执行原则**:
- 遵循代码规范
- 使用 TDD 流程
- 复用现有代码
- 保持DDD分层

### 步骤 5：验证

**目标**: 确保代码质量

**验证顺序**:
```bash
# 1. 代码格式
./vendor/bin/pint --test

# 2. 静态分析
./vendor/bin/phpstan analyse

# 3. 测试运行
./vendor/bin/pest --compact
```

## TDD 流程（8步）

```
1. 需求分析 → Read PRD docs in doc/PRD/{module}/
2. 架构设计 → Plan files per DDD layer
3. 数据库设计 → Create migration (make:migration)
4. 先写测试 → Red phase (Pest tests)
5. 实现代码 → Green phase (minimal code to pass)
6. 重构优化 → Refactor phase (Pint + PHPStan)
7. 架构测试 → Architecture phase (DDD boundaries + naming)
8. 联调验证 → End-to-end verification
```

### TDD 示例

```bash
# 1. 创建 migration
docker compose exec app php artisan make:migration create_products_table

# 2. 创建 Model + Factory
docker compose exec app php artisan make:model Domain/Product/Product -mf

# 3. 编写测试 (Red)
# tests/Unit/Domains/Catalog/ProductTest.php

# 4. 实现代码 (Green)
# app/Domains/Catalog/Services/ProductService.php

# 5. 重构 (Refactor)
./vendor/bin/pint
./vendor/bin/phpstan analyse

# 6. 验证
./vendor/bin/pest --filter="ProductTest"
```

## 快速开发模式

### 新功能开发流程

```bash
# 1. 创建数据库迁移
docker compose exec app php artisan make:migration create_xxx_table

# 2. 创建 Model + Factory
docker compose exec app php artisan make:model Domain/ModelName -mf

# 3. 创建 Filament Resource
docker compose exec app php artisan make:filament-resource Domain/ModelName

# 4. 编写测试
# tests/Unit/Domains/Domain/ModelTest.php

# 5. 验证代码质量
docker compose exec app ./vendor/bin/pint
docker compose exec app ./vendor/bin/phpstan analyse
docker compose exec app ./vendor/bin/pest
```

### 批量操作

```bash
# 创建完整域
docker compose exec app php artisan make:model Domain/Order/Order -mfs
docker compose exec app php artisan make:filament-resource Domain/Order/Order

# 运行所有测试
./vendor/bin/pest

# 运行特定域测试
./vendor/bin/pest tests/Unit/Domains/Order/
```

## 错误处理流程

```
检查/测试失败
    ↓
向用户说明失败原因
    ↓
提供改进方案
    ↓
等待用户确认
    ↓
修复后重新检查
```

## 文档沉淀

每次开发完成后，记录：
- 需求文档 → `doc/PRD/`
- 设计文档 → `doc/design/`
- 开发文档 → `doc/development/`
- 测试文档 → `doc/testing/`
