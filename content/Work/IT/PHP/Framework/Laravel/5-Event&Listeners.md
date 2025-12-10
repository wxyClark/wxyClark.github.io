---
sort: 5
---

# 事件监听 event&listeners

```tip
默认是同步执行，可以继承ShouldQueue 实现异步执行
```

## 绑定

## 触发

```php
Event::fire(new XxxEvent($Xxx));
```
或
```php
event(new XxxEvent($Xxx));
```

## 队列

## 分发

## 订阅

## 运行机制

注册 事件-监听 app/Providers/EventServiceProvider.php
```php
    /**
     * The event listener mappings for the application.
     *
     * @var array
     */
    protected $listen = [
            //配货状态
            'App\Events\DeliverStatus' => [
                'App\Listeners\DeliverStatusListener'
            ],
    ];
```

定义事件参数 app/Events/DeliverStatus.php
```php
class DeliverStatus
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $tenant_id;

    public $order_code;

    public $user_name;

    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($tenant_id, $order_code, $user_name)
    {
        $this->tenant_id = $tenant_id;
        $this->order_code = $order_code;
        $this->user_name = $user_name;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return \Illuminate\Broadcasting\Channel|array
     */
    public function broadcastOn()
    {
        return new PrivateChannel('channel-name');
    }
}
```

定义监听者 app/Listeners/AllowDeliverListener.php
```php
class AllowDeliverListener
{
    /**
     * Create the event listener.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     *
     * @param  AllowDeliver  $event
     * @return void
     */
    public function handle(AllowDeliver $event)
    {
        app(OrderDeliverService::class)->allowDeliver($event->order_code);
    }
}
```

app/Services/Orders/OrderDeliverService.php
```php
    // 监听者的具体行为
    public function allowDeliver($orderCode)
    {

    }
```

app/Services/ModuleName/ProcessService.php
```php
    public function doSth($params)
    {
        //  do sth

        //  埋点监听
        event(new AllowDeliver($eventParams));
    }
```