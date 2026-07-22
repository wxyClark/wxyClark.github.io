---
title: TDD/DDD 实践指南
description: 测试驱动开发和领域驱动设计实践
date: 2026-07-22
---

# TDD/DDD 实践指南

## TDD 核心理念

**测试先行，代码后行**

```
Red → Green → Refactor
```

1. **Red**: 先写失败的测试
2. **Green**: 写最少的代码让测试通过
3. **Refactor**: 重构代码保持质量

## TDD 8步流程

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

## 实战示例：商品管理

### Step 1: 需求分析

```markdown
# 商品管理需求

## 功能
- 商品 CRUD
- 商品分类
- 商品状态管理
- 库存管理

## 角色
- 管理员：完全权限
- 运营：查看、编辑
```

### Step 2: 架构设计

```
app/Domains/Catalog/
├── Models/
│   ├── Product.php
│   ├── Category.php
│   └── ProductStatus.php (Enum)
├── Services/
│   ├── ProductService.php
│   └── CategoryService.php
├── Data/
│   └── ProductData.php
└── Repositories/
    └── ProductRepository.php
```

### Step 3: 数据库设计

```bash
# 创建迁移
docker compose exec app php artisan make:migration create_products_table
docker compose exec app php artisan make:migration create_categories_table
```

```php
// database/migrations/xxx_create_products_table.php
public function up(): void
{
    Schema::create('products', function (Blueprint $table) {
        $table->id();
        $table->foreignId('category_id')->constrained();
        $table->string('name');
        $table->string('sku')->unique();
        $table->decimal('price', 10, 2);
        $table->enum('status', ['draft', 'active', 'inactive']);
        $table->boolean('is_active')->default(true);
        $table->timestamps();
        $table->softDeletes();
    });
}
```

### Step 4: 先写测试 (Red)

```php
<?php

// tests/Unit/Domains/Catalog/ProductTest.php

declare(strict_types=1);

use App\Domains\Catalog\Models\Product;
use App\Domains\Catalog\Services\ProductService;

test('can create product', function () {
    $data = [
        'name' => 'Test Product',
        'sku' => 'TEST-001',
        'price' => 99.99,
        'category_id' => 1,
    ];

    $product = app(ProductService::class)->create($data);

    expect($product)
        ->name->toBe('Test Product')
        ->sku->toBe('TEST-001')
        ->price->toBe('99.99');
});

test('product requires name', function () {
    $this->post('/api/products', [])
        ->assertUnprocessable();
});

test('product requires unique sku', function () {
    Product::factory()->create(['sku' => 'EXISTING-001']);
    
    $this->post('/api/products', [
        'sku' => 'EXISTING-001',
    ])->assertUnprocessable();
});
```

### Step 5: 实现代码 (Green)

```php
<?php

// app/Domains/Catalog/Services/ProductService.php

declare(strict_types=1);

namespace App\Domains\Catalog\Services;

use App\Domains\Catalog\Models\Product;
use App\Domains\Catalog\Data\ProductData;

class ProductService
{
    public function create(array $data): Product
    {
        return Product::create($data);
    }

    public function update(Product $product, array $data): Product
    {
        $product->update($data);
        return $product;
    }

    public function delete(Product $product): bool
    {
        return $product->delete();
    }
}
```

### Step 6: 重构优化

```bash
# 代码格式
./vendor/bin/pint

# 静态分析
./vendor/bin/phpstan analyse

# 运行测试
./vendor/bin/pest --filter="ProductTest"
```

### Step 7: 架构测试

```php
<?php

// tests/Feature/Architecture/CatalogArchitectureTest.php

declare(strict_types=1);

use App\Domains\Catalog\Models\Product;
use App\Domains\Catalog\Services\ProductService;

test('product model uses soft deletes', function () {
    expect((new Product)->getDeletedAtColumn())
        ->toBe('deleted_at');
});

test('product service has proper return types', function () {
    $reflection = new ReflectionClass(ProductService::class);
    
    foreach ($reflection->getMethods() as $method) {
        expect($method->getReturnType())
            ->not->toBeNull();
    }
});
```

### Step 8: 联调验证

```bash
# 运行所有测试
./vendor/bin/pest

# 运行特定域测试
./vendor/bin/pest tests/Unit/Domains/Catalog/

# 运行架构测试
./vendor/bin/pest tests/Feature/Architecture/
```

## DDD 分层实践

### Domain 层

**职责**：纯业务逻辑，无框架依赖

```php
<?php

// app/Domains/Catalog/Models/Product.php

declare(strict_types=1);

namespace App\Domains\Catalog\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'name',
        'sku',
        'price',
        'category_id',
    ];

    protected $casts = [
        'price' => 'decimal:2',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }
}
```

### Infrastructure 层

**职责**：实现 Domain 接口，框架依赖

```php
<?php

// app/Infrastructure/Repositories/Eloquent/ProductRepository.php

declare(strict_types=1);

namespace App\Infrastructure\Repositories\Eloquent;

use App\Domains\Catalog\Models\Product;
use App\Domains\Catalog\Repositories\ProductRepositoryInterface;

class ProductRepository implements ProductRepositoryInterface
{
    public function __construct(
        private readonly Product $model
    ) {}

    public function find(int $id): ?Product
    {
        return $this->model->find($id);
    }

    public function create(array $data): Product
    {
        return $this->model->create($data);
    }
}
```

### Http 层

**职责**：仅调用 Service，不含业务逻辑

```php
<?php

// app/Http/Controllers/ProductController.php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Http\Requests\ProductRequest;
use App\Http\Resources\ProductResource;
use App\Services\ProductService;
use Illuminate\Http\JsonResponse;

class ProductController extends Controller
{
    public function __construct(
        private readonly ProductService $service
    ) {}

    public function store(ProductRequest $request): JsonResponse
    {
        $product = $this->service->create($request->validated());
        
        return response()->json([
            'data' => new ProductResource($product),
        ], 201);
    }
}
```

## 测试最佳实践

### 单元测试

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

test('product validation requires name', function () {
    $this->post('/api/products', [])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['name']);
});
```

### 集成测试

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

test('can search products by name', function () {
    Product::factory()->create(['name' => 'Laptop']);
    Product::factory()->create(['name' => 'Phone']);

    $response = $this->getJson('/api/products?search=Laptop');

    $response->assertOk()
        ->assertJsonCount(1, 'data');
});
```

### Filament 资源测试

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
```

## 代码质量检查

### 检查顺序

```bash
# 1. 代码格式
./vendor/bin/pint --test

# 2. 静态分析
./vendor/bin/phpstan analyse

# 3. 测试运行
./vendor/bin/pest --compact
```

### 自动化检查

```bash
# 使用 make 命令
make lint
make test
make all

# 或使用 composer
composer lint
composer test
composer all
```

## 已知陷阱检查清单

- [ ] Filament 方法调用位置：defaultSort/Table, badge/Column
- [ ] 枚举 pluck：用静态数组，不用动态 pluck
- [ ] 列表页 action：不要加 header DeleteAction
- [ ] 复制文件：必须更新 namespace 和 use 语句
- [ ] 文件语法：修改后立即执行 `php -l` 检查
- [ ] `'hashed'` cast：创建用户时直接赋明文密码
- [ ] toSql() vs toRawSql()：导出存储用 toSql()
- [ ] Blade 模板中 Collection 方法在纯数组上报错：改用 empty()
- [ ] 数据库表名只在 Model 中定义，禁止硬编码
