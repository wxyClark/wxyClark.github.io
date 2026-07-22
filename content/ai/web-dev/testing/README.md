---
title: 测试策略
description: 完整的测试策略和最佳实践
date: 2026-07-22
---

# 测试策略

## 测试金字塔

```
         ┌─────────┐
         │  E2E    │  10%
         │  (API)  │
         ├─────────┤
         │Integration│  20%
         │  (Feature)│
         ├─────────┤
         │  Unit   │  70%
         │ (Service)│
         └─────────┘
```

## 测试类型

### 1. 单元测试 (Unit)

**位置**: `tests/Unit/Domains/{Domain}/`

**职责**: 测试单个类/方法的逻辑

```php
<?php

declare(strict_types=1);

use App\Domains\Catalog\Models\Product;
use App\Domains\Catalog\Services\ProductService;

test('can create product', function () {
    $data = [
        'name' => 'Test Product',
        'sku' => 'TEST-001',
        'price' => 99.99,
    ];

    $product = app(ProductService::class)->create($data);

    expect($product)
        ->name->toBe('Test Product')
        ->sku->toBe('TEST-001')
        ->price->toBe('99.99');
});

test('product price must be positive', function () {
    $data = [
        'name' => 'Test Product',
        'sku' => 'TEST-001',
        'price' => -10,
    ];

    app(ProductService::class)->create($data);
})->throws(InvalidArgumentException::class);
```

### 2. 集成测试 (Feature)

**位置**: `tests/Feature/Api/`

**职责**: 测试 API 端到端流程

```php
<?php

declare(strict_types=1);

use App\Domains\Catalog\Models\Product;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

test('can list products', function () {
    Product::factory()->count(5)->create();

    $response = $this->getJson('/api/products');

    $response->assertOk()
        ->assertJsonCount(5, 'data');
});

test('can create product via api', function () {
    $data = [
        'name' => 'API Product',
        'sku' => 'API-001',
        'price' => 199.99,
    ];

    $response = $this->postJson('/api/products', $data);

    $response->assertCreated()
        ->assertJsonFragment(['name' => 'API Product']);
    
    $this->assertDatabaseHas('products', ['sku' => 'API-001']);
});

test('cannot create product with duplicate sku', function () {
    Product::factory()->create(['sku' => 'EXISTING-001']);

    $response = $this->postJson('/api/products', [
        'sku' => 'EXISTING-001',
    ]);

    $response->assertUnprocessable()
        ->assertJsonValidationErrors(['sku']);
});
```

### 3. Filament 资源测试

**位置**: `tests/Feature/Filament/`

**职责**: 测试 Filament CRUD 操作

```php
<?php

declare(strict_types=1);

use App\Domains\Catalog\Models\Product;
use App\Filament\Admin\Resources\ProductResource;
use Livewire\Livewire;

test('product resource form', function () {
    $product = Product::factory()->create();

    Livewire::test(ProductResource::class, 'edit', ['record' => $product->id])
        ->assertOk();
});

test('product resource table', function () {
    Product::factory()->count(10)->create();

    Livewire::test(ProductResource::class, 'list')
        ->assertOk()
        ->assertCanSeeTableRecords(Product::all());
});

test('can create product via filament', function () {
    Livewire::test(ProductResource::class, 'create')
        ->fillForm([
            'name' => 'Filament Product',
            'sku' => 'FIL-001',
            'price' => 299.99,
        ])
        ->call('create')
        ->assertHasNoFormErrors();
    
    $this->assertDatabaseHas('products', ['sku' => 'FIL-001']);
});
```

## 测试配置

### Pest.php 配置

```php
<?php

// tests/Pest.php

declare(strict_types=1);

use Illuminate\Foundation\Testing\RefreshDatabase;

uses(Tests\TestCase::class, RefreshDatabase::class);

// 全局配置
pest()->extend(function ($test) {
    // 每个测试前执行
    $this->setUpTraits();
});
```

### phpunit.xml 配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="vendor/phpunit/phpunit/phpunit.xsd"
         bootstrap="vendor/autoload.php"
         colors="true">
    <testsuites>
        <testsuite name="Unit">
            <directory>tests/Unit</directory>
        </testsuite>
        <testsuite name="Feature">
            <directory>tests/Feature</directory>
        </testsuite>
    </testsuites>
    <source>
        <include>
            <directory>app</directory>
        </include>
    </source>
</phpunit>
```

## 测试约定

### 命名约定

```php
// ✓ 正确：使用 test()
test('can create product', function () {
    // ...
});

// ✗ 错误：使用 it()
it('can create product', function () {
    // ...
});
```

### AAA 模式

```php
test('can calculate total price', function () {
    // Arrange
    $items = [
        ['price' => 10, 'quantity' => 2],
        ['price' => 20, 'quantity' => 1],
    ];

    // Act
    $total = calculateTotal($items);

    // Assert
    expect($total)->toBe(40);
});
```

### 使用 Factory

```php
// ✓ 正确
$product = Product::factory()->create();
$products = Product::factory()->count(10)->create();

// ✗ 错误
$product = Product::create([
    'name' => 'Test Product',
    'sku' => 'TEST-001',
]);
```

### 具体断言

```php
// ✓ 正确
$response->assertSuccessful();
$response->assertNotFound();
$response->assertCreated();

// ✗ 错误
$response->assertStatus(200);
$response->assertStatus(404);
```

## 测试运行

### 常用命令

```bash
# 运行所有测试
./vendor/bin/pest

# 运行特定文件
./vendor/bin/pest tests/Feature/Api/ProductTest.php

# 运行特定测试
./vendor/bin/pest --filter="can create product"

# 运行并行测试（CI 模式）
./vendor/bin/pest --parallel

# 紧凑输出
./vendor/bin/pest --compact
```

### 测试覆盖率

```bash
# 生成覆盖率报告
./vendor/bin/pest --coverage --min=80

# 生成 HTML 报告
./vendor/bin/pest --coverage-html=coverage
```

## 测试数据管理

### Factory 定义

```php
<?php

// database/factories/ProductFactory.php

declare(strict_types=1);

namespace Database\Factories;

use App\Domains\Catalog\Models\Product;
use Illuminate\Database\Eloquent\Factories\Factory;

class ProductFactory extends Factory
{
    protected $model = Product::class;

    public function definition(): array
    {
        return [
            'name' => fake()->words(3, true),
            'sku' => strtoupper(fake()->bothify('???-####')),
            'price' => fake()->randomFloat(2, 10, 1000),
            'category_id' => 1,
        ];
    }

    public function active(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'active',
        ]);
    }

    public function inactive(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'inactive',
        ]);
    }
}
```

### 测试数据清理

```php
<?php

declare(strict_types=1);

use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

test('test with clean database', function () {
    // 每个测试后自动清理
    Product::factory()->count(5)->create();
    
    // 测试结束后自动回滚
});
```

## 测试最佳实践

### 1. 测试命名

```php
// ✓ 正确：描述行为
test('can create product with valid data', function () {
    // ...
});

test('cannot create product with duplicate sku', function () {
    // ...
});

// ✗ 错误：描述实现
test('test_create_product', function () {
    // ...
});
```

### 2. 测试独立性

```php
// ✓ 正确：每个测试独立
test('can create product', function () {
    $product = Product::factory()->create();
    expect($product)->toBeInstanceOf(Product::class);
});

test('can update product', function () {
    $product = Product::factory()->create();
    $product->update(['name' => 'Updated']);
    expect($product->name)->toBe('Updated');
});

// ✗ 错误：测试依赖
test('can create product', function () {
    $this->product = Product::factory()->create();
});

test('can update product', function () {
    $this->product->update(['name' => 'Updated']);
});
```

### 3. 测试粒度

```php
// ✓ 正确：一个测试一个断言
test('product has name', function () {
    $product = Product::factory()->create(['name' => 'Test']);
    expect($product->name)->toBe('Test');
});

test('product has sku', function () {
    $product = Product::factory()->create(['sku' => 'TEST-001']);
    expect($product->sku)->toBe('TEST-001');
});

// ✗ 错误：一个测试多个断言
test('product attributes', function () {
    $product = Product::factory()->create([
        'name' => 'Test',
        'sku' => 'TEST-001',
    ]);
    expect($product->name)->toBe('Test');
    expect($product->sku)->toBe('TEST-001');
});
```

### 4. 测试边界

```php
// ✓ 正确：测试边界条件
test('price must be positive', function () {
    Product::factory()->create(['price' => -10]);
})->throws(InvalidArgumentException::class);

test('sku must be unique', function () {
    Product::factory()->create(['sku' => 'TEST-001']);
    Product::factory()->create(['sku' => 'TEST-001']);
})->throws(UniqueViolationException::class);
```

## 测试报告

### 生成报告

```bash
# 文本报告
./vendor/bin/pest --compact > test-report.txt

# HTML 报告
./vendor/bin/pest --coverage-html=coverage

# JSON 报告
./vendor/bin/pest --log-junit=test-results.xml
```

### CI 集成

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.5'
          
      - name: Install Dependencies
        run: composer install
        
      - name: Run Tests
        run: ./vendor/bin/pest --parallel
        
      - name: Run PHPStan
        run: ./vendor/bin/phpstan analyse
        
      - name: Run Pint
        run: ./vendor/bin/pint --test
```

## 测试检查清单

### 提交前检查

- [ ] 单元测试通过
- [ ] 集成测试通过
- [ ] Filament 资源测试通过
- [ ] 测试覆盖率达标 (≥80%)
- [ ] 无重复测试
- [ ] 测试命名规范
- [ ] 测试数据使用 Factory

### 代码审查检查

- [ ] 测试覆盖核心业务逻辑
- [ ] 测试边界条件
- [ ] 测试异常情况
- [ ] 测试命名清晰
- [ ] 测试独立可重复
