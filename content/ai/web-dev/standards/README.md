---
title: 代码标准和规范
description: PHP/Laravel/Filament 代码标准
date: 2026-07-22
---

# 代码标准和规范

## 技术栈

- PHP 8.5+
- Laravel 12
- Filament 3.x
- MySQL 8.4
- Redis

## 代码质量门禁

### 必须通过（每次提交前）

```bash
./vendor/bin/pint --test          # 代码风格
./vendor/bin/phpstan analyse      # 静态分析 (Level 5)
./vendor/bin/pest --compact       # 测试
```

### 质量检查顺序

```
pint → phpstan → pest
```

## PHP 规范

### 基础要求

```php
<?php

declare(strict_types=1);

namespace App\Domains\Catalog\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    use SoftDeletes;

    protected $table = 'products';

    protected $fillable = [
        'name',
        'sku',
        'price',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'is_active' => 'boolean',
    ];
}
```

### 关键规则

1. **必须声明严格类型**
   ```php
   declare(strict_types=1);
   ```

2. **使用短数组语法**
   ```php
   // ✓ 正确
   $array = [1, 2, 3];
   
   // ✗ 错误
   $array = array(1, 2, 3);
   ```

3. **4空格缩进**

4. **import 语句按字母排序**

5. **类成员顺序**
   ```
   trait → constant → property → constructor → method
   ```

## Laravel 规范

### Controller

```php
<?php

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

### 关键规则

1. **Controller 必须用 FormRequest**
   ```php
   // ✓ 正确
   public function store(ProductRequest $request): JsonResponse
   
   // ✗ 错误
   public function store(Request $request): JsonResponse
   ```

2. **API 响应必须用 API Resource**
   ```php
   // ✓ 正确
   return new ProductResource($product);
   
   // ✗ 错误
   return $product;
   ```

3. **业务逻辑在 Service 层**
   ```php
   // ✓ 正确
   $product = $this->service->create($data);
   
   // ✗ 错误
   $product = Product::create($data);
   ```

4. **所有方法必须有返回类型**

5. **禁止魔法字符串**
   ```php
   // ✓ 正确
   enum ProductStatus: string
   {
       case Active = 'active';
       case Inactive = 'inactive';
   }
   
   // ✗ 错误
   $status = 'active';
   ```

## DDD 分层规范

### 目录结构

```
app/
├── Domains/          # 业务域
│   ├── {Domain}/
│   │   ├── Models/       # Eloquent 模型
│   │   ├── Enums/        # 状态枚举
│   │   ├── Services/     # 业务逻辑
│   │   ├── Data/         # DTO
│   │   ├── Events/       # 领域事件
│   │   ├── Repositories/ # 仓储接口
│   │   └── Policies/     # 授权策略
├── Infrastructure/   # 基础设施层
│   ├── Filament/Resources/
│   ├── Repositories/Eloquent/
│   └── Support/Traits/
├── Filament/         # Filament 面板资源
├── Http/             # 控制器、请求、资源
├── Models/           # 跨域共享模型
└── Services/         # 共享服务
```

### 分层规则

```
Domain → 无框架依赖
Infrastructure → 实现 Domain 接口
Http → 仅调用 Service
```

## 数据库规范

### 字段类型

```php
// 金额字段：必须使用 decimal(10, 2)
$table->decimal('price', 10, 2);

// 禁止使用 FLOAT/DOUBLE
```

### 软删除

```php
// 核心业务表必须开启 SoftDeletes
$table->softDeletes();
```

### 迁移文件名

```
// ✓ 正确
2026_07_22_000001_create_products_table.php

// ✗ 错误（双后缀）
2026_07_22_000001_create_products_table.php.php
```

## Filament 规范

### Resource 结构

```php
<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources;

use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class ProductResource extends Resource
{
    protected static ?string $model = Product::class;

    protected static ?string $navigationIcon = 'heroicon-o-shopping-bag';

    public static function form(Form $form): Form
    {
        return $form->schema([
            Forms\Components\TextInput::make('name')
                ->required()
                ->maxLength(255),
            Forms\Components\TextInput::make('sku')
                ->required()
                ->unique(Product::class, 'sku'),
            Forms\Components\TextInput::make('price')
                ->required()
                ->numeric(),
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->searchable(),
                Tables\Columns\TextColumn::make('sku')
                    ->searchable(),
                Tables\Columns\TextColumn::make('price')
                    ->money('CNY'),
            ])
            ->filters([
                //
            ]);
    }
}
```

### 关键规则

1. **必须实现 `form()` 和 `table()` 方法**

2. **同一个 Model 只能有一个 Resource 定义**

3. **下拉框选项必须使用缓存**
   ```php
   // ✓ 正确
   Select::make('category_id')
       ->options(fn () => Cache::remember('categories', 3600, fn () => 
           Category::pluck('name', 'id')
       ))
   
   // ✗ 错误
   Select::make('category_id')
       ->options(Category::pluck('name', 'id'))
   ```

## 测试规范

### 测试结构

```
tests/
├── Unit/Domains/{Domain}/         # 单元测试
├── Feature/Api/                   # API 集成测试
├── Feature/Filament/              # Filament 资源测试
└── Pest.php                       # 全局配置
```

### 测试约定

```php
<?php

declare(strict_types=1);

use App\Domains\Catalog\Models\Product;
use App\Domains\Catalog\Services\ProductService;

test('can create product', function () {
    // Arrange
    $data = [
        'name' => 'Test Product',
        'sku' => 'TEST-001',
        'price' => 99.99,
    ];

    // Act
    $product = app(ProductService::class)->create($data);

    // Assert
    expect($product)
        ->name->toBe('Test Product')
        ->sku->toBe('TEST-001')
        ->price->toBe('99.99');
});

test('product requires name', function () {
    $this->post('/api/products', [])
        ->assertUnprocessable();
});
```

### 关键规则

1. **使用 `test()` 风格**（不是 `it()`）

2. **AAA 模式**：Arrange → Act → Assert

3. **使用 Factory 生成测试数据**
   ```php
   $product = Product::factory()->create();
   ```

4. **使用具体断言**
   ```php
   // ✓ 正确
   $response->assertSuccessful();
   $response->assertNotFound();
   
   // ✗ 错误
   $response->assertStatus(200);
   ```

## 性能规范

### 禁止 N+1 查询

```php
// ✓ 正确：批量加载
$orders = Order::with('items.product')->get();

// ✗ 错误：循环查询
foreach ($orders as $order) {
    foreach ($order->items as $item) {
        $item->product; // N+1
    }
}
```

### 禁止逐行 INSERT

```php
// ✓ 正确：批量插入
DB::table('products')->insert($chunks);

// ✗ 错误：循环创建
foreach ($data as $item) {
    Product::create($item);
}
```

### 缓存公共查询

```php
// ✓ 正确
$categories = Cache::remember('categories', 3600, fn () => 
    Category::pluck('name', 'id')
);

// ✗ 错误
$categories = Category::pluck('name', 'id');
```

## 安全规范

### 文件下载验证

```php
// ✓ 正确
$path = realpath(storage_path('exports/' . $filename));
if ($path && str_starts_with($path, storage_path('exports'))) {
    return response()->download($path);
}

// ✗ 错误
return response()->download(storage_path('exports/' . $filename));
```

### 公开路由限流

```php
// ✓ 正确
Route::middleware('throttle:60,1')->group(function () {
    Route::get('/open/products', [ProductController::class, 'index']);
});

// ✗ 错误
Route::get('/open/products', [ProductController::class, 'index']);
```

## 代码质量铁律

1. **禁止代码重复**：超过 10 行的相同逻辑必须提取
2. **禁止空 stub 方法**：必须删除或实现
3. **DDD 目录不允许空壳**：必须有实际代码
4. **Migration 文件名必须正确**：禁止双后缀
