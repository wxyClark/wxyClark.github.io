---
title: 性能和安全
description: 性能优化和安全防护最佳实践
date: 2026-07-22
---

# 性能和安全

## 性能优化

### 1. 数据库优化

#### 避免 N+1 查询

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

#### 使用 Chunk 分批处理

```php
// ✓ 正确：大批量数据处理
Product::chunk(100, function ($products) {
    foreach ($products as $product) {
        // 处理逻辑
    }
});

// ✗ 错误：一次性加载全部
$products = Product::all();
foreach ($products as $product) {
    // 内存溢出
}
```

#### 索引优化

```php
// 数据库迁移
Schema::table('products', function (Blueprint $table) {
    $table->index('sku');
    $table->index('category_id');
    $table->index(['status', 'is_active']);
    $table->index('created_at');
});
```

### 2. 缓存策略

#### 查询缓存

```php
// ✓ 正确：使用 Cache::remember
$categories = Cache::remember('categories', 3600, function () {
    return Category::pluck('name', 'id');
});

// ✗ 错误：每次查询
$categories = Category::pluck('name', 'id');
```

#### 缓存失效

```php
// 更新数据后清除缓存
public function updateCategory(Category $category, array $data): Category
{
    $category->update($data);
    
    Cache::forget('categories');
    Cache::forget("category_{$category->id}");
    
    return $category;
}
```

#### 缓存标签

```php
// 使用标签管理缓存
Cache::tags(['products', 'catalog'])->put('featured', $products, 3600);

// 清除特定标签缓存
Cache::tags(['products'])->flush();
```

### 3. 队列处理

#### 异步任务

```php
// ✓ 正确：耗时任务入队
ProcessExport::dispatch($exportId);

// ✗ 错误：同步执行
$this->processExport($exportId);
```

#### 队列配置

```php
// config/queue.php
'default' => env('QUEUE_CONNECTION', 'redis'),

'connections' => [
    'redis' => [
        'driver' => 'redis',
        'connection' => 'default',
        'queue' => env('REDIS_QUEUE', 'default'),
        'retry_after' => 90,
        'block_for' => null,
    ],
],
```

### 4. API 优化

#### 分页

```php
// ✓ 正确：使用分页
$products = Product::paginate(20);

// ✗ 错误：加载全部
$products = Product::all();
```

#### 响应缓存

```php
// ✓ 正确：缓存 API 响应
return Cache::remember('products_list', 60, function () {
    return Product::all();
});

// ✗ 错误：每次查询
return Product::all();
```

#### 条件加载

```php
// ✓ 正确：按需加载关联
$products = Product::with('category:id,name')->get();

// ✗ 错误：加载全部字段
$products = Product::with('category')->get();
```

### 5. Filament 优化

#### 下拉框缓存

```php
// ✓ 正确：缓存选项
Select::make('category_id')
    ->options(fn () => Cache::remember('category_options', 3600, function () {
        return Category::pluck('name', 'id');
    })),

// ✗ 错误：每次渲染查询
Select::make('category_id')
    ->options(Category::pluck('name', 'id')),
```

#### 表格优化

```php
// ✓ 正确：使用索引列搜索
TextColumn::make('sku')
    ->searchable()
    ->index(),

// ✗ 错误：搜索非索引列
TextColumn::make('description')
    ->searchable(),
```

## 安全防护

### 1. 输入验证

#### FormRequest 验证

```php
<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ProductRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'sku' => 'required|string|max:50|unique:products,sku',
            'price' => 'required|numeric|min:0',
            'category_id' => 'required|exists:categories,id',
        ];
    }
}
```

#### SQL 注入防护

```php
// ✓ 正确：使用参数绑定
$products = DB::select(
    'SELECT * FROM products WHERE name = ?',
    [$name]
);

// ✗ 错误：字符串拼接
$products = DB::select(
    "SELECT * FROM products WHERE name = '$name'"
);
```

#### XSS 防护

```php
// ✓ 正确：转义输出
{!! e($user->name) !!}

// ✗ 错误：直接输出
{{ $user->name }}

// Blade 模板中
{{ $user->bio }}  // 自动转义
{!! $user->bio !!}  // 不转义（危险）
```

### 2. 认证授权

#### 路由中间件

```php
// ✓ 正确：使用中间件
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('products', ProductController::class);
});

// ✗ 错误：无认证
Route::apiResource('products', ProductController::class);
```

#### 授权策略

```php
<?php

declare(strict_types=1);

namespace App\Policies;

use App\Models\User;
use App\Domains\Catalog\Models\Product;

class ProductPolicy
{
    public function viewAny(User $user): bool
    {
        return $user->can('view_products');
    }

    public function update(User $user, Product $product): bool
    {
        return $user->can('update_products')
            && $user->id === $product->user_id;
    }
}
```

### 3. 文件安全

#### 路径穿越防护

```php
// ✓ 正确：验证路径
$filename = basename($request->file);
$path = realpath(storage_path("exports/{$filename}"));

if (!str_starts_with($path, storage_path('exports'))) {
    abort(403, 'Invalid path');
}

return response()->download($path);

// ✗ 错误：直接拼接
return response()->download(
    storage_path("exports/{$request->file}")
);
```

#### 文件类型验证

```php
// ✓ 正确：验证文件类型
$validated = $request->validate([
    'file' => 'required|file|mimes:pdf,xlsx,csv|max:10240',
]);

// ✗ 错误：无验证
$request->file('file')->store('uploads');
```

### 4. API 安全

#### 限流

```php
// ✓ 正确：添加限流中间件
Route::middleware('throttle:60,1')->group(function () {
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/register', [AuthController::class, 'register']);
});

// ✗ 错误：无限流
Route::post('/login', [AuthController::class, 'login']);
```

#### Token 安全

```php
// ✓ 正确：绑定用户 ID
$token = Cache::remember(
    "export_token_{$user->id}",
    3600,
    fn () => Str::random(60)
);

// ✗ 错误：不绑定用户
$token = Cache::remember('export_token', 3600, fn () => Str::random(60));
```

#### 密码哈希

```php
// ✓ 正确：使用 hashed cast
class User extends Model
{
    protected $casts = [
        'password' => 'hashed',
    ];
}

// 创建用户时直接赋值
User::create([
    'password' => 'plain-text-password',
]);

// ✗ 错误：手动哈希
User::create([
    'password' => Hash::make('plain-text-password'),
]);
```

### 5. 日志安全

#### 敏感信息过滤

```php
// ✓ 正确：过滤敏感信息
Log::info('User login', [
    'user_id' => $user->id,
    'ip' => $request->ip(),
    // 不记录密码
]);

// ✗ 错误：记录敏感信息
Log::info('User login', [
    'user_id' => $user->id,
    'password' => $request->password,
]);
```

#### 审计日志

```php
// 记录重要操作
Activity::log('product.updated')
    ->subject($product)
    ->withProperties([
        'old' => $product->getOriginal(),
        'new' => $product->getChanges(),
    ])
    ->log('Product updated by user');
```

### 6. 依赖安全

#### 定期更新依赖

```bash
# 检查漏洞
composer audit

# 更新依赖
composer update

# 安全更新
composer update --with-dependencies
```

#### 依赖扫描

```bash
# 使用 Enlightn Security Checker
composer require enlightn/security-checker --dev
php artisan security:check
```

## 性能监控

### 1. 查询监控

```php
// 记录慢查询
DB::listen(function ($query) {
    if ($query->time > 100) { // 超过 100ms
        Log::warning('Slow query', [
            'sql' => $query->sql,
            'time' => $query->time,
            'bindings' => $query->bindings,
        ]);
    }
});
```

### 2. 应用性能

```php
// 使用 Laravel Telescope
// config/telescope.php
'middleware' => [
    'web',
    Authorize::class,
],
```

### 3. 缓存命中率

```php
// 监控缓存命中率
$hits = Cache::get('cache_hits', 0);
$misses = Cache::get('cache_misses', 0);

$hitRate = $hits / ($hits + $misses) * 100;
```

## 安全检查清单

### 代码审查

- [ ] 输入验证完整
- [ ] SQL 注入防护
- [ ] XSS 防护
- [ ] CSRF 防护
- [ ] 文件路径验证
- [ ] 密码哈希处理
- [ ] 敏感信息过滤

### 部署前检查

- [ ] 环境变量配置
- [ ] 调试模式关闭
- [ ] 错误日志配置
- [ ] HTTPS 启用
- [ ] 安全头配置

### 定期检查

- [ ] 依赖漏洞扫描
- [ ] 日志审查
- [ ] 权限审查
- [ ] 备份验证
- [ ] 安全更新

## 性能检查清单

### 代码审查

- [ ] N+1 查询检查
- [ ] 缓存使用检查
- [ ] 分页实现检查
- [ ] 队列任务检查
- [ ] 索引使用检查

### 部署前检查

- [ ] 数据库索引
- [ ] 缓存配置
- [ ] 队列配置
- [ ] CDN 配置
- [ ] 压缩配置

### 定期检查

- [ ] 慢查询日志
- [ ] 缓存命中率
- [ ] 队列积压
- [ ] 内存使用
- [ ] CPU 使用
