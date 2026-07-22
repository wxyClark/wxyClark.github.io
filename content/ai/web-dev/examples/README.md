---
title: 代码示例
description: 标准代码示例参考
date: 2026-07-22
---

# 代码示例

## Model 示例

### Product 模型

```php
<?php

declare(strict_types=1);

namespace App\Domains\Catalog\Models;

use App\Domains\Catalog\Enums\ProductStatus;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $table = 'products';

    protected $fillable = [
        'name',
        'sku',
        'price',
        'category_id',
        'status',
        'is_active',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'is_active' => 'boolean',
        'status' => ProductStatus::class,
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function isActive(): bool
    {
        return $this->is_active && $this->status === ProductStatus::Active;
    }
}
```

### Category 模型

```php
<?php

declare(strict_types=1);

namespace App\Domains\Catalog\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Category extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $table = 'categories';

    protected $fillable = [
        'name',
        'slug',
        'parent_id',
    ];

    public function children(): HasMany
    {
        return $this->hasMany(self::class, 'parent_id');
    }

    public function products(): HasMany
    {
        return $this->hasMany(Product::class);
    }
}
```

## Service 示例

### ProductService

```php
<?php

declare(strict_types=1);

namespace App\Domains\Catalog\Services;

use App\Domains\Catalog\Models\Product;
use Illuminate\Support\Facades\Cache;

class ProductService
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
        $product = $this->model->create($data);
        
        Cache::forget('products_list');
        
        return $product;
    }

    public function update(Product $product, array $data): Product
    {
        $product->update($data);
        
        Cache::forget("product_{$product->id}");
        Cache::forget('products_list');
        
        return $product;
    }

    public function delete(Product $product): bool
    {
        $result = $product->delete();
        
        Cache::forget("product_{$product->id}");
        Cache::forget('products_list');
        
        return $result;
    }

    public function getActiveProducts()
    {
        return Cache::remember('active_products', 3600, function () {
            return $this->model
                ->where('is_active', true)
                ->where('status', 'active')
                ->get();
        });
    }
}
```

## Repository 示例

### ProductRepository

```php
<?php

declare(strict_types=1);

namespace App\Infrastructure\Repositories\Eloquent;

use App\Domains\Catalog\Models\Product;
use App\Domains\Catalog\Repositories\ProductRepositoryInterface;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;

class ProductRepository implements ProductRepositoryInterface
{
    public function __construct(
        private readonly Product $model
    ) {}

    public function find(int $id): ?Product
    {
        return $this->model->find($id);
    }

    public function findBySku(string $sku): ?Product
    {
        return $this->model->where('sku', $sku)->first();
    }

    public function create(array $data): Product
    {
        return $this->model->create($data);
    }

    public function paginated(int $perPage = 20): LengthAwarePaginator
    {
        return $this->model->paginate($perPage);
    }
}
```

## Controller 示例

### ProductController

```php
<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Domains\Catalog\Models\Product;
use App\Http\Requests\ProductRequest;
use App\Http\Resources\ProductResource;
use App\Services\ProductService;
use Illuminate\Http\JsonResponse;

class ProductController extends Controller
{
    public function __construct(
        private readonly ProductService $service
    ) {}

    public function index()
    {
        $products = $this->service->getActiveProducts();
        
        return ProductResource::collection($products);
    }

    public function store(ProductRequest $request): JsonResponse
    {
        $product = $this->service->create($request->validated());
        
        return response()->json([
            'data' => new ProductResource($product),
        ], 201);
    }

    public function show(Product $product)
    {
        return new ProductResource($product);
    }

    public function update(ProductRequest $request, Product $product): JsonResponse
    {
        $product = $this->service->update($product, $request->validated());
        
        return response()->json([
            'data' => new ProductResource($product),
        ]);
    }

    public function destroy(Product $product): JsonResponse
    {
        $this->service->delete($product);
        
        return response()->json(null, 204);
    }
}
```

## FormRequest 示例

### ProductRequest

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
        $productId = $this->route('product')?->id;
        
        return [
            'name' => 'required|string|max:255',
            'sku' => [
                'required',
                'string',
                'max:50',
                "unique:products,sku,{$productId}",
            ],
            'price' => 'required|numeric|min:0',
            'category_id' => 'required|exists:categories,id',
            'status' => 'required|in:draft,active,inactive',
        ];
    }
}
```

## API Resource 示例

### ProductResource

```php
<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'sku' => $this->sku,
            'price' => $this->price,
            'status' => $this->status,
            'is_active' => $this->is_active,
            'category' => new CategoryResource($this->whenLoaded('category')),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
```

## Filament Resource 示例

### ProductResource

```php
<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources;

use App\Domains\Catalog\Models\Product;
use App\Filament\Admin\Resources\ProductResource\Pages;
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
            Forms\Components\Section::make('基本信息')
                ->schema([
                    Forms\Components\TextInput::make('name')
                        ->required()
                        ->maxLength(255),
                    Forms\Components\TextInput::make('sku')
                        ->required()
                        ->unique(Product::class, 'sku')
                        ->maxLength(50),
                    Forms\Components\TextInput::make('price')
                        ->required()
                        ->numeric()
                        ->minValue(0)
                        ->suffix('元'),
                ]),
            Forms\Components\Section::make('分类和状态')
                ->schema([
                    Forms\Components\Select::make('category_id')
                        ->relationship('category', 'name')
                        ->required()
                        ->searchable(),
                    Forms\Components\Select::make('status')
                        ->options([
                            'draft' => '草稿',
                            'active' => '激活',
                            'inactive' => '未激活',
                        ])
                        ->required(),
                    Forms\Components\Toggle::make('is_active')
                        ->default(true),
                ]),
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('sku')
                    ->searchable(),
                Tables\Columns\TextColumn::make('price')
                    ->money('CNY')
                    ->sortable(),
                Tables\Columns\TextColumn::make('status')
                    ->badge(),
                Tables\Columns\IconColumn::make('is_active')
                    ->boolean(),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('status')
                    ->options([
                        'draft' => '草稿',
                        'active' => '激活',
                        'inactive' => '未激活',
                    ]),
                Tables\Filters\SelectFilter::make('category_id')
                    ->relationship('category', 'name'),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListProducts::route('/'),
            'create' => Pages\CreateProduct::route('/create'),
            'edit' => Pages\EditProduct::route('/{record}/edit'),
        ];
    }
}
```

## Enum 示例

### ProductStatus

```php
<?php

declare(strict_types=1);

namespace App\Domains\Catalog\Enums;

enum ProductStatus: string
{
    case Draft = 'draft';
    case Active = 'active';
    case Inactive = 'inactive';

    public function label(): string
    {
        return match ($this) {
            self::Draft => '草稿',
            self::Active => '激活',
            self::Inactive => '未激活',
        };
    }

    public function color(): string
    {
        return match ($this) {
            self::Draft => 'gray',
            self::Active => 'success',
            self::Inactive => 'danger',
        };
    }
}
```

## Factory 示例

### ProductFactory

```php
<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Domains\Catalog\Models\Product;
use App\Domains\Catalog\Enums\ProductStatus;
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
            'status' => ProductStatus::Draft,
            'is_active' => true,
        ];
    }

    public function active(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => ProductStatus::Active,
        ]);
    }

    public function inactive(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => ProductStatus::Inactive,
        ]);
    }
}
```

## Test 示例

### Unit Test

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
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['name']);
});

test('product requires unique sku', function () {
    Product::factory()->create(['sku' => 'EXISTING-001']);
    
    $this->post('/api/products', [
        'sku' => 'EXISTING-001',
    ])->assertUnprocessable();
});
```

### Feature Test

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
        'category_id' => 1,
    ];

    $response = $this->postJson('/api/products', $data);

    $response->assertCreated()
        ->assertJsonFragment(['name' => 'API Product']);
    
    $this->assertDatabaseHas('products', ['sku' => 'API-001']);
});
```

### Filament Test

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
