# 06 — 面向对象与设计模式

> 核心规律：找不变的东西抽象出来
> 一句话：设计模式是前人总结的解决特定问题的最佳实践

---

## 一、OOP四大特性

### 1.1 封装

```
封装 = 隐藏内部实现，只暴露必要的接口

好处：
├── 降低复杂度（使用者不需要知道内部细节）
├── 保护数据（防止外部随意修改）
└── 易于维护（内部实现可变，接口不变）
```

```php
// ❌ 坏示例：属性直接暴露
class User {
    public $balance;  // 可以是负数！
}

// ✅ 好示例：封装 + 验证
class User {
    private float $balance = 0.0;
    
    public function deposit(float $amount): void {
        if ($amount <= 0) throw new Exception('金额必须大于0');
        $this->balance += $amount;
    }
    
    public function getBalance(): float {
        return $this->balance;
    }
}
```

### 1.2 继承

```
继承 = 代码复用 + 多态的基础

使用原则：
├── is-a关系：子类必须是父类的一种
├── 优先组合：能用组合不用继承
└── 继承深度≤3层：过深说明设计有问题
```

### 1.3 多态

```
多态 = 同一接口，不同实现

好处：
├── 可扩展：新增实现不影响调用方
├── 可替换：运行时切换实现
└── 可测试：轻松mock替换
```

```php
interface PaymentMethod {
    public function pay(float $amount): bool;
}

class Alipay implements PaymentMethod { ... }
class WechatPay implements PaymentMethod { ... }

// 调用方无需关心具体实现
class Order {
    public function checkout(PaymentMethod $method, float $amount): void {
        $method->pay($amount);  // 多态调用
    }
}
```

### 1.4 抽象

```
抽象 = 提取共同特征，隐藏差异

方式：
├── 抽象类：可以有实现，只能单继承
└── 接口：只能有声明，可以多实现
```

---

## 二、创建型设计模式

### 2.1 单例模式 Singleton

```php
class Database {
    private static ?self $instance = null;
    private function __construct() {}
    
    public static function instance(): self {
        return self::$instance ??= new self();
    }
}
```

**适用场景：** 数据库连接、配置管理器、日志对象

### 2.2 工厂模式 Factory

```php
// 简单工厂
class NotificationFactory {
    public static function create(string $type): Notification {
        return match($type) {
            'email' => new EmailNotification(),
            'sms'   => new SmsNotification(),
            default => throw new Exception("Unknown type: $type"),
        };
    }
}
```

**适用场景：** 对象创建逻辑复杂、需要隐藏创建细节

### 2.3 建造者模式 Builder

```php
class OrderBuilder {
    private string $userId;
    private array $items = [];
    
    public function setUserId(string $id): self {
        $this->userId = $id;
        return $this;
    }
    
    public function addItem(string $product, int $qty): self {
        $this->items[] = compact('product', 'qty');
        return $this;
    }
    
    public function build(): Order {
        return new Order($this->userId, $this->items);
    }
}

// 使用
$order = (new OrderBuilder())
    ->setUserId('u123')
    ->addItem('book', 2)
    ->build();
```

**适用场景：** 对象参数多、构建过程复杂

---

## 三、结构型设计模式

### 3.1 适配器模式 Adapter

```php
// 将旧API适配为新接口
class AlipayAdapter implements PaymentGateway {
    public function __construct(private AlipayOldApi $api) {}
    
    public function charge(float $amount): array {
        return $this->api->pay(['amount' => $amount]);
    }
}
```

**适用场景：** 集成第三方库、兼容旧接口

### 3.2 装饰器模式 Decorator

```php
// 类似Laravel中间件
class LoggingDecorator implements RequestHandler {
    public function handle(string $uri): string {
        $this->logger->info("Handling: $uri");
        $result = $this->next->handle($uri);
        $this->logger->info("Result: {$result['status']}");
        return $result;
    }
}
```

**适用场景：** 动态添加功能、AOP编程

### 3.3 代理模式 Proxy

```php
// 懒加载代理
class ImageProxy {
    private ?RealImage $realImage = null;
    
    public function display(): void {
        if (!$this->realImage) {
            $this->realImage = new RealImage($this->path);
        }
        $this->realImage->display();
    }
}
```

**适用场景：** 懒加载、访问控制、远程代理

---

## 四、行为型设计模式

### 4.1 观察者模式 Observer

```php
// Laravel事件系统就是观察者模式
event(new OrderShipped($order));  // 触发事件
// 所有监听OrderShipped的处理器会被调用
```

**适用场景：** 事件驱动、解耦发布订阅

### 4.2 策略模式 Strategy

```php
interface DiscountStrategy {
    public function calculate(float $amount): float;
}

class PercentDiscount implements DiscountStrategy {
    public function calculate(float $amount): float {
        return $amount * (1 - $this->percent / 100);
    }
}

// 运行时切换策略
$order->applyDiscount(new PercentDiscount(20));
```

**适用场景：** 多种算法可替换、避免大量if-else

### 4.3 责任链模式 Chain of Responsibility

```php
// Laravel中间件管道
Pipeline::send($request)
    ->through([
        Authenticate::class,
        CheckPermission::class,
        LogRequest::class,
    ])
    ->then(function ($request) {
        return $this->handle($request);
    });
```

**适用场景：** 请求处理链、过滤器链

---

## 五、Laravel中的设计模式

| 模式 | Laravel体现 |
|------|------------|
| **IoC容器** | app() / resolve() |
| **单例** | Facade（静态代理） |
| **工厂** | ModelFactory / Factory类 |
| **观察者** | Event/Listener系统 |
| **策略** | Payment Gateway接口 |
| **责任链** | Middleware管道 |
| **适配器** | Service Provider绑定 |

---

## 六、本章总结

> **核心规律：设计模式不是目的，而是解决特定问题的最佳实践。找到问题，选择模式，而不是拿着模式找问题。**

### 关键记忆点
- ✅ OOP四大特性：封装、继承、多态、抽象
- ✅ 创建型模式：单例、工厂、建造者
- ✅ 结构型模式：适配器、装饰器、代理
- ✅ 行为型模式：观察者、策略、责任链
- ✅ Laravel本身就是设计模式的集大成者

---

## 延伸阅读

- [05 架构设计原则](./05-架构设计原则.md) — 架构层面的设计原则
- [oop/](../oop/) — 现有OOP专题内容（MVC、DI、服务容器等）
