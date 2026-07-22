---
title: 自动化任务
description: 任务拆分和自动执行
date: 2026-07-22
---

# 自动化任务

## 任务拆分系统

### 核心流程

```
需求 → 分析 → 拆分 → 依赖 → 排序 → 执行
```

### 1. 需求分析

```php
<?php

declare(strict_types=1);

namespace App\Services\TaskSplitter;

class RequirementAnalyzer
{
    public function analyze(string $requirement): array
    {
        return [
            'features' => $this->extractFeatures($requirement),
            'entities' => $this->extractEntities($requirement),
            'rules' => $this->extractRules($requirement),
        ];
    }
    
    private function extractFeatures(string $requirement): array
    {
        // 提取功能点
        preg_match_all('/(?:可以|能够|支持|实现)(.*?)(?:。|；|$)/', $requirement, $matches);
        return $matches[1] ?? [];
    }
}
```

### 2. 任务生成

```php
<?php

declare(strict_types=1);

namespace App\Services\TaskSplitter;

class TaskGenerator
{
    public function generate(array $analysis): array
    {
        $tasks = [];
        
        // 数据库任务
        foreach ($analysis['entities'] as $entity) {
            $tasks[] = [
                'type' => 'database',
                'name' => "创建 {$entity} 表",
                'priority' => 'high',
            ];
        }
        
        // 模型任务
        foreach ($analysis['entities'] as $entity) {
            $tasks[] = [
                'type' => 'model',
                'name' => "创建 {$entity} 模型",
                'priority' => 'high',
            ];
        }
        
        // 服务任务
        foreach ($analysis['features'] as $feature) {
            $tasks[] = [
                'type' => 'service',
                'name' => "实现 {$feature}",
                'priority' => 'medium',
            ];
        }
        
        return $tasks;
    }
}
```

### 3. 依赖分析

```php
<?php

declare(strict_types=1);

namespace App\Services\TaskSplitter;

class DependencyAnalyzer
{
    public function analyze(array $tasks): array
    {
        $dependencies = [];
        
        foreach ($tasks as $task) {
            $deps = [];
            
            // 模型依赖数据库
            if ($task['type'] === 'model') {
                $deps[] = "database_{$task['entity']}";
            }
            
            // 服务依赖模型
            if ($task['type'] === 'service') {
                $deps[] = "model_{$task['entity']}";
            }
            
            // 测试依赖服务
            if ($task['type'] === 'test') {
                $deps[] = "service_{$task['feature']}";
            }
            
            $dependencies[$task['id']] = $deps;
        }
        
        return $dependencies;
    }
}
```

### 4. 执行排序

```php
<?php

declare(strict_types=1);

namespace App\Services\TaskSplitter;

class TaskScheduler
{
    public function schedule(array $tasks, array $dependencies): array
    {
        $scheduled = [];
        $completed = [];
        
        while (count($scheduled) < count($tasks)) {
            foreach ($tasks as $task) {
                if (in_array($task['id'], $scheduled)) {
                    continue;
                }
                
                $deps = $dependencies[$task['id']] ?? [];
                $allDepsCompleted = true;
                
                foreach ($deps as $dep) {
                    if (!in_array($dep, $completed)) {
                        $allDepsCompleted = false;
                        break;
                    }
                }
                
                if ($allDepsCompleted) {
                    $scheduled[] = $task['id'];
                    $completed[] = $task['id'];
                    break;
                }
            }
        }
        
        return $scheduled;
    }
}
```

## 自动执行

### 1. 代码生成

```php
<?php

declare(strict_types=1);

namespace App\Services\TaskSplitter;

class CodeGenerator
{
    public function generateModel(array $entity): string
    {
        $name = $entity['name'];
        $table = Str::snake(Str::plural($name));
        
        return <<<PHP
<?php

declare(strict_types=1);

namespace App\\Domains\\{$entity['domain']}\\Models;

use Illuminate\\Database\\Eloquent\\Model;
use Illuminate\\Database\\Eloquent\\SoftDeletes;

class {$name} extends Model
{
    use SoftDeletes;

    protected \$table = '{$table}';

    protected \$fillable = [
        // TODO: 添加字段
    ];
}
PHP;
    }
    
    public function generateMigration(array $entity): string
    {
        $name = $entity['name'];
        $table = Str::snake(Str::plural($name));
        $timestamp = date('Y_m_d_His');
        
        return <<<PHP
<?php

use Illuminate\\Database\\Migrations\\Migration;
use Illuminate\\Database\\Schema\\Blueprint;
use Illuminate\\Support\\Facades\\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('{$table}', function (Blueprint \$table) {
            \$table->id();
            // TODO: 添加字段
            \$table->timestamps();
            \$table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('{$table}');
    }
};
PHP;
    }
}
```

### 2. 测试生成

```php
<?php

declare(strict_types=1);

namespace App\Services\TaskSplitter;

class TestGenerator
{
    public function generateModelTest(array $entity): string
    {
        $name = $entity['name'];
        $namespace = "App\\Domains\\{$entity['domain']}\\Models\\{$name}";
        
        return <<<PHP
<?php

declare(strict_types=1);

use {$namespace};

test('can create ' . strtolower('{$name}'), function () {
    $name = strtolower('{$name}');
    $model = app("{$namespace}")->create([
        // TODO: 添加测试数据
    ]);

    expect($model)->toBeInstanceOf({$name}::class);
});

test('can update ' . strtolower('{$name}'), function () {
    $name = strtolower('{$name}');
    $model = app("{$namespace}")->create([
        // TODO: 添加测试数据
    ]);

    $model->update([
        // TODO: 更新字段
    ]);

    expect($model->wasChanged())->toBeTrue();
});

test('can delete ' . strtolower('{$name}'), function () {
    $name = strtolower('{$name}');
    $model = app("{$namespace}")->create([
        // TODO: 添加测试数据
    ]);

    $model->delete();

    expect($model->trashed())->toBeTrue();
});
PHP;
    }
}
```

### 3. Filament Resource 生成

```php
<?php

declare(strict_types=1);

namespace App\Services\TaskSplitter;

class FilamentGenerator
{
    public function generateResource(array $entity): string
    {
        $name = $entity['name'];
        $resource = "{$name}Resource";
        
        return <<<PHP
<?php

declare(strict_types=1);

namespace App\\Filament\\Admin\\Resources;

use Filament\\Forms;
use Filament\\Forms\\Form;
use Filament\\Resources\\Resource;
use Filament\\Tables;
use Filament\\Tables\\Table;

class {$resource} extends Resource
{
    protected static ?string \$model = {$name}::class;

    protected static ?string \$navigationIcon = 'heroicon-o-clipboard-document-list';

    public static function form(Form \$form): Form
    {
        return \$form->schema([
            // TODO: 添加表单字段
        ]);
    }

    public static function table(Table \$table): Table
    {
        return \$table
            ->columns([
                // TODO: 添加表格列
            ])
            ->filters([
                //
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => List{$name}s::route('/'),
            'create' => Create{$name}::route('/create'),
            'edit' => Edit{$name}::route('/{record}/edit'),
        ];
    }
}
PHP;
    }
}
```

## 执行流程

### 1. 需求分析

```bash
# 分析需求
php artisan task:analyze "实现商品管理功能"

# 输出
Features:
- 商品 CRUD
- 商品分类
- 商品状态管理

Entities:
- Product
- Category
- ProductStatus

Rules:
- 商品名称必填
- SKU 唯一
- 价格大于 0
```

### 2. 任务生成

```bash
# 生成任务
php artisan task:generate --requirement="商品管理"

# 输出
Tasks:
1. 创建 categories 表 (database)
2. 创建 products 表 (database)
3. 创建 Category 模型 (model)
4. 创建 Product 模型 (model)
5. 实现 CategoryService (service)
6. 实现 ProductService (service)
7. 创建 CategoryResource (filament)
8. 创建 ProductResource (filament)
9. 编写 CategoryTest (test)
10. 编写 ProductTest (test)
```

### 3. 依赖分析

```bash
# 分析依赖
php artisan task:dependency

# 输出
Dependencies:
1. categories 表 → 无依赖
2. products 表 → 依赖 categories 表
3. Category 模型 → 依赖 categories 表
4. Product 模型 → 依赖 products 表
5. CategoryService → 依赖 Category 模型
6. ProductService → 依赖 Product 模型
7. CategoryResource → 依赖 Category 模型
8. ProductResource → 依赖 Product 模型
9. CategoryTest → 依赖 CategoryService
10. ProductTest → 依赖 ProductService
```

### 4. 执行计划

```bash
# 生成执行计划
php artisan task:schedule

# 输出
Execution Plan:
Wave 1 (无依赖):
- 创建 categories 表
- 创建 products 表

Wave 2 (依赖 Wave 1):
- 创建 Category 模型
- 创建 Product 模型

Wave 3 (依赖 Wave 2):
- 实现 CategoryService
- 实现 ProductService

Wave 4 (依赖 Wave 3):
- 创建 CategoryResource
- 创建 ProductResource

Wave 5 (依赖 Wave 4):
- 编写 CategoryTest
- 编写 ProductTest
```

### 5. 自动执行

```bash
# 执行单个任务
php artisan task:execute 1

# 执行整个 Wave
php artisan task:execute --wave=1

# 执行所有任务
php artisan task:execute --all

# 输出
Executing: 创建 categories 表
✓ Migration created
Executing: 创建 products 表
✓ Migration created
Executing: 创建 Category 模型
✓ Model created
...
```

## 执行验证

### 1. 代码质量检查

```bash
# 每个任务执行后自动检查
php artisan task:execute --with-check

# 输出
Executing: 创建 Product 模型
✓ Model created
Running checks:
  ✓ php -l app/Domains/Catalog/Models/Product.php
  ✓ ./vendor/bin/pint --test
  ✓ ./vendor/bin/phpstan analyse
All checks passed!
```

### 2. 测试验证

```bash
# 执行测试验证
php artisan task:execute --with-test

# 输出
Executing: 实现 ProductService
✓ Service created
Running tests:
  ✓ tests/Unit/Domains/Catalog/ProductServiceTest.php
All tests passed!
```

### 3. 回滚机制

```bash
# 回滚单个任务
php artisan task:rollback 1

# 回滚整个 Wave
php artisan task:rollback --wave=1

# 回滚所有任务
php artisan task:rollback --all
```

## 最佳实践

### 1. 任务粒度

```php
// ✓ 正确：小粒度任务
$tasks = [
    ['type' => 'database', 'name' => '创建 products 表'],
    ['type' => 'model', 'name' => '创建 Product 模型'],
    ['type' => 'service', 'name' => '实现 ProductService'],
];

// ✗ 错误：大粒度任务
$tasks = [
    ['type' => 'feature', 'name' => '实现商品管理'],
];
```

### 2. 依赖管理

```php
// ✓ 正确：明确依赖
$dependencies = [
    'model_product' => ['database_products'],
    'service_product' => ['model_product'],
];

// ✗ 错误：循环依赖
$dependencies = [
    'task_a' => ['task_b'],
    'task_b' => ['task_a'],
];
```

### 3. 错误处理

```php
// ✓ 正确：错误恢复
try {
    $this->executeTask($task);
} catch (\Exception $e) {
    Log::error('Task execution failed', [
        'task' => $task,
        'error' => $e->getMessage(),
    ]);
    
    $this->rollbackTask($task);
    throw $e;
}

// ✗ 错误：忽略错误
$this->executeTask($task);
```

### 4. 日志记录

```php
// ✓ 正确：详细日志
Log::info('Task executed', [
    'task_id' => $task['id'],
    'task_name' => $task['name'],
    'status' => 'success',
    'duration' => $duration,
]);

// ✗ 错误：无日志
$this->executeTask($task);
```

## 检查清单

### 任务拆分

- [ ] 需求分析完整
- [ ] 任务粒度合适
- [ ] 依赖关系正确
- [ ] 执行顺序合理

### 执行验证

- [ ] 代码质量检查
- [ ] 测试通过
- [ ] 文档更新
- [ ] 日志记录

### 错误处理

- [ ] 错误捕获
- [ ] 回滚机制
- [ ] 错误报告
- [ ] 恢复策略
