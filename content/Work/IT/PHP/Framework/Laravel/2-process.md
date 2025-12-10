---
sort: 2
---

# 处理过程

## 自动注入
把有依赖关系的类放到容器中，解析出这些类的实例，就是依赖注入。目的是实现类的解耦。
- Controller 使用的 Request、Service 依赖注入

```php
public function abc(AbcRequest $request, DefService $service)
{
    try {
        return $service->doSth($request->all());

        return [
            'code' => $code,
            'msg'  => '成功|失败原因',
            'data' => [
                'page'        => 1,
                'page_size'   => 20,
                'total'       => 123,
                'list'        => [
                    'id'          => 1,
                    'xxx_code'    => 123456789,
                    'xxx_name'    => 'a123456789',
                    'status'      => '状态1',
                    'created_at'  => '2022-01-18 19:16:06',
                    'operate_list' => [
                        'name'   => '编辑|删除|状态变更',
                        'method' => 'GET|POST|PUT|DELETE',
                        'domain' => env('XYZ_DOMAIN_NAME'),
                        'url'    => '路由',
                    ],
                ],
                'action_list' => [
                    'name'   => '按钮名称|导出|下载',
                    'method' => 'GET|POST|PUT|DELETE',
                    'domain' => env('XYZ_DOMAIN_NAME'),
                    'url'    => '路由',
                ],
            ],
        ];
    } catch (Exception $e) {
        //  处理已知类型异常,日志
    } catch (Throwable $t) {
        //  处理未知类型异常,日志
    }
}
```  

- Service 使用的 Repository 依赖注入 

```php
public function doSth(array $params, Repository $repository)
{
    DB::beginTransaction();
    try {
        $repository->doA();

        $repository->doB();

        # 通用log方法记录日志(入参、错误信息、文件、行)
        $logData = [
            'params'      => $params,
            'innerParams' => 内部参数,
            'errorMsg'    => '$errorMsg',
        ];
        # 集中定义错误码、错误信息
        throw new XyzException('errorMsg', $errorCode);

        DB::commit();

        return [统一格式];
    } catch (XyzException $e) {
        DB::rollback();
        //  处理已知类型异常,日志
        return [统一格式];
    } catch (Throwable $t) {
        DB::rollback();
        //  处理未知类型异常,日志
        return [统一格式];
    }
}
```

- Repository 使用的 Model 依赖注入 

```php
public function querySth(XxxModel $model)
{
    $list = $model->all();
    $list = $model->pluck();
    
    return $list ? $list->toArray() : [];
}
```

    你可以简单地使用「类型提示」的方式在由容器解析的类的构造函数中添加依赖项，
    包括 控制器、监听事件、队列任务、中间件 等。
    事实上，这是你的大多数对象也应该由容器解析。

```php
/**
 * UserRepository 的实例对象
 */
protected $users;

//  依赖注入
public function __construct(UserRepository $users)
{
    $this->users = $users;
}
```

## Exceptions异常处理

```tip
laravel 的异常处理由类 \Illuminate\Foundation\Bootstrap\HandleExceptions::class 完成
当遇到异常情况的时候，laravel 首要做的事情就是记录 log，这个就是 report 函数的作用↓
laravel 在 Ioc 容器中默认的异常处理类是 Illuminate\Foundation\Exceptions\Handler
```

```php
class HandleExceptions
{
    public function bootstrap(Application $app)
    {
        $this->app = $app;
        error_reporting(-1);
        set_error_handler([$this, 'handleError']);
        set_exception_handler([$this, 'handleException']);
        register_shutdown_function([$this, 'handleShutdown']);
        if (! $app->environment('testing')) {
            ini_set('display_errors', 'Off');
        }
    }
}
```

在我们实际开发中，异常捕捉仅仅靠 try {} catch () 是远远不够的。

* set_exception_handler() 函数可设置处理所有未捕获异常的用户定义函数。

    当一个异常被抛出时，其后的代码将不会继续执行，PHP 会尝试查找匹配的 catch 代码块。
    如果一个异常没有被捕获，而且又没用使用set_exception_handler() 作相应的处理的话，
    那么 PHP 将会产生一个严重的错误，并且输出未能捕获异常 (Uncaught Exception ... ) 的提示信息。

* laravel 常见的异常类型

    HttpException、HttpResponseException、AuthorizationException、
    ModelNotFoundException、AuthenticationException、ValidationException

    