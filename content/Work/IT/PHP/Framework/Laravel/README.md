---
sort: 1
---

# Laravel

laravel框架的核心就是个Ioc容器即服务容器

[Laravel 2018使用数据分析](https://www.pilishen.com/posts/laravel-numbers-2018-07)

[Laravel 扩展排行榜](https://learnku.com/laravel/projects/filter/laravel-library)

[Laravel 应用排行榜](https://learnku.com/laravel/projects/filter/laravel-app?order=github_stars)

## 最佳实践

[Laravel最佳实践](https://github.com/alexeymezenin/laravel-best-practices/blob/master/chinese.md)

代码严格分层、封装，**单向 向下调用**

| 类 | 注入 | 处理 | 常用方法 |
| ---- | ---- | ---- | ---- |
| Controller | Request <br> Service | 权限校验，参数校验 <br> 调用 service 处理业务逻辑 <br> 返回 | index、detail、report、add、edit、export、changeStatus | 
| SearchService <br> 查询、导出 | Repository | 接收参数，处理查询逻辑 <br> 外键参数转换 <br> 调用 repository 与数据库交互 | getIndex、getDetail、getDetailList、report、exportData | 
| ProcessService <br> 编辑、流转 | Repository | 接收参数，处理业务逻辑 <br> 复杂业务使用事务处理 <br> 调用 repository 与数据库交互 | add、edit、changeStatus | 
| Repository | Model | 与数据库交互 <br> 封装基础方法 | insert、batchUpdate、total、list、getMap、delete、condition、getListByMinId | 
| Model |  | 定义关联的数据表、主键、更新时间字段名 |  | 
| Request |  | 定义校验规则 <br> 校验参数 | rules | 
| Enums |  | 定义常量 <br> 获取常量映射 <br> 定义常量分组 | getNameByConst() | 
| Helper |  | 分装常用数据处理 func | getSth | 

* 使用社区认可的标准Laravel工具
* 遵循laravel命名约定
* 一个类和一个方法应该只有一个职责(单一职责SRP)。
* 在代码中使用配置、语言包和常量，而不是使用硬编码
* 注释你的代码，但是更优雅的做法是使用描述性的语言来编写你的代码
* 尽可能使用简短且可读性更好的语法
* 避免直接从 .env 文件里获取数据; 推荐在config目录下的文件中使用 env('CONST_PARAM'), 在代码中使用 config(config_file_name.param_name)
* 永远不要在路由文件中放任何的逻辑代码。
* 使用 IoC 容器(依赖注入，解耦)或 facades 代替 new ClassName
* 将验证从控制器移动到请求类
* 集中处理数据：$category->article()->create($request->validated());
* 最好倾向于使用 Eloquent 而不是 Query Builder 和原生的 SQL 查询。优先使用集合而不是数组
* 不要重复你自己(DRY)

```php
public function scopeActive($q)
{
    return $q->where('重复使用的过滤条件');
}

public function getActive()
{
    return $this->active()->get();
}

public function getArticles()
{
    return $this->whereHas('user', function ($q) {
            $q->active();
        })->get();
}
```


* 不要在模板中查询，尽量使用惰性加载；尽量把 sql 操作提到循环之外
* 使用标准格式来存储日期，用访问器和修改器来修改日期格式

```php
// Model
protected $dates = ['ordered_at', 'created_at', 'updated_at'];
public function getSomeDateAttribute($date)
{
    return $date->format('m-d');
}

// View
{{ $object->ordered_at->toDateString() }}
{{ $object->ordered_at->some_date }}
```

## 设计模式


### Facade门面模式

[Facade 门面模式](./0-how.md#Facade门面) 

相对于其他方法来说，最大的特点就是简洁

如： Route、DB

### 单例模式

./bootstrap/app.php

```php
$app->singleton(
    Illuminate\Contracts\Http\Kernel::class,
    App\Http\Kernel::class
);

$app->singleton(
    Illuminate\Contracts\Console\Kernel::class,
    App\Console\Kernel::class
);

$app->singleton(
    Illuminate\Contracts\Debug\ExceptionHandler::class,
    App\Exceptions\Handler::class
);
```

### 观察者模式 Event-Listener

app/Providers/EventServiceProvider.php 

```tip
一个Event可以对应多个监听者
一个监听者只能对应一个Event
```

```php
protected $listen = [
        //  商品编辑日志
        'App\Events\ProductEditEvent'=> [
            'App\Listeners\ProductEditLogListener',
        ],
        'App\Events\ProductDetailEditEvent'=> [
            'App\Listeners\ProductVariationEditLogListener',
        ],
        'App\Events\ProductImageEditEvent'=> [
            'App\Listeners\ProductVariationEditLogListener',
        ],
        'App\Events\ProductTagEditEvent'=> [
            'App\Listeners\ProductVariationEditLogListener',
        ],
        'App\Events\ProductVariationEditEvent'=> [
            'App\Listeners\ProductVariationEditLogListener',
        ],
    ];
```


[laravel之设计模式](https://www.jianshu.com/p/cb8e9c354921)

## 避坑

### 插件

* 插件安装成功后，须在 config/app.php 中配置 providers、aliases
* 多项目须注意 依赖的插件 保持版本统一

### toArray()

get() 、 pluck() 的结果集，在->toArray() 之前应先判空
* 非空才使用->toArray()，
* 否则返回 []

### 中间件

路由中间件过滤权限

* 对 list/index 列表页面做过滤，在列表页面以及链接页面做的操作 不需要额外过滤
* 对不经过 list/index 页面就直接操作的页面做过滤
* 没有走中间件的路由使用的函数 和 走中间件的路由使用的函数 共用时，注意参数格式 是 基本类型还是数组类型

### batchUpdate

```danger
batchUpdate方法批量更新数据时，如果被更新的字段有json类型的数据，中文json后的数据会被去掉'\' 变成乱码
```

<hr />


