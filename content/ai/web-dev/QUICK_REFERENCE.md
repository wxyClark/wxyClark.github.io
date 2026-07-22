---
title: 快速参考
description: AI开发体系快速参考卡片
date: 2026-07-22
---

# 快速参考卡片

## 核心工作流

```
需求 → 理解(多轮) → 增强 → 确认 → 执行 → 验证
```

## 质量门禁（每次提交前）

```bash
./vendor/bin/pint --test          # 代码格式
./vendor/bin/phpstan analyse      # 静态分析
./vendor/bin/pest --compact       # 测试
```

## TDD 8步流程

```
1. 需求分析 → 2. 架构设计 → 3. 数据库设计 → 4. 先写测试
5. 实现代码 → 6. 重构优化 → 7. 架构测试 → 8. 联调验证
```

## DDD 分层

```
Domain (业务逻辑)
    ↓
Infrastructure (实现接口)
    ↓
Http (调用 Service)
```

## 快速命令

```bash
# 创建资源
php artisan make:model Domain/Product/Product -mf
php artisan make:filament-resource Domain/Product/Product

# 代码检查
./vendor/bin/pint
./vendor/bin/phpstan analyse
./vendor/bin/pest

# 测试运行
./vendor/bin/pest --filter="testName"
./vendor/bin/pest tests/Unit/Domains/Product/
```

## 代码规范速查

| 规则 | 说明 |
|------|------|
| `declare(strict_types=1)` | 必须声明 |
| 短数组语法 | `[]` 不是 `array()` |
| 4空格缩进 | |
| import 排序 | 字母顺序 |
| 类成员顺序 | trait → constant → property → constructor → method |

## 性能铁律

1. **禁止 N+1 查询**：使用 `with()` 预加载
2. **禁止逐行 INSERT**：使用 `chunk()` 批量插入
3. **Filament 缓存选项**：`Cache::remember()` 缓存下拉框
4. **公共 API 缓存**：所有查询必须有缓存层

## 安全铁律

1. **文件下载 realpath 验证**：防止路径穿越
2. **公开路由限流**：`throttle:60,1`
3. **密码哈希一致性**：使用 `'password' => 'hashed'` cast
4. **导出 Token 绑定用户**：防止 token 猜解

## 测试金字塔

```
E2E (API)      10%
Integration    20%
Unit           70%
```

## 目录结构

```
app/
├── Domains/          # 业务域
├── Infrastructure/   # 基础设施
├── Filament/         # Filament 资源
├── Http/             # 控制器、请求、资源
└── Services/         # 共享服务
```

## 文档结构

```
doc/
├── PRD/              # 产品需求
├── design/           # 设计文档
├── development/      # 开发文档
├── testing/          # 测试文档
└── deployment/       # 部署文档
```

## 已知陷阱

- [ ] Filament 方法调用位置：defaultSort/Table, badge/Column
- [ ] 枚举 pluck：用静态数组
- [ ] `'hashed'` cast：直接赋明文密码
- [ ] toSql() vs toRawSql()：导出用 toSql()
- [ ] 数据库表名只在 Model 中定义

## 检查清单

### 提交前

- [ ] pint --test 通过
- [ ] phpstan analyse 通过
- [ ] pest --compact 通过
- [ ] 测试覆盖率 ≥ 80%

### 代码审查

- [ ] 无 N+1 查询
- [ ] 使用 FormRequest
- [ ] 使用 API Resource
- [ ] 使用 Service 层
- [ ] 使用 Factory 生成测试数据
