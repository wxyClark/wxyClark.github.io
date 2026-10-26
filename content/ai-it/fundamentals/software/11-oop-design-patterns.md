---
title: "面向对象与设计模式"
description: "核心规律：找不变的东西抽象出来"
---

# 设计模式 — 先有问题，再找模式

> 一句话：模式不是名词展览，而是对「某类变化」的标准应对；说不出你要隔离哪种变化，就不要用模式。

## 🎯 这 20% 能解决哪些问题

| 你遇到的困惑 | 本质原因 | 马上能改的动作 |
|---|---|---|
| 一个方法里写了十几个 `if/else` 分支 | 用条件判断代替了多态 | 改为策略模式 + 映射表，分支变成实现类 |
| 对象创建越来越复杂 | 构造函数参数爆炸，依赖顺序混乱 | 参数 ≥4 个时用建造者，简单场景直接用工厂方法 |
| 想给类加日志/缓存/鉴权 | 直接改原类，职责膨胀 | 用装饰器或中间件包裹，原类保持不变 |
| 一处变更要通知多个模块 | 调用方硬编码下游列表 | 用观察者/事件，发送方只发事件 |
| 为了「以后可能扩展」提前抽象 | YAGNI，抽象成本高于收益 | 第二次出现重复时再抽象 |

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

## 🎓 实战场景（TIL）

- **场景**：单测互相污染，跑顺序不同就失败。**本质**：单例成了全局可变状态，测试无法隔离。**要点**：单例只用于无状态服务（连接池、配置）；依赖由容器注入，测试里换成内存实现。
- **场景**：下单函数里 5 层 `switch($type)`，每加一种价格都要改它。**本质**：行为随类型变化，却用条件分支堆叠。**要点**：策略 + 映射表（类型 → 处理器），新增类型只加类不改调用方；但只有 2 个分支时直接写 `if` 更清楚。
- **场景**：积分、通知、日志都写在下单流程里，一个外部服务超时导致下单失败。**本质**：不该强相关的联动被写进同一事务。**要点**：观察者/领域事件解耦，监听方异常不拖垮主流程；跨服务时改为走消息队列并保证至少一次投递 + 消费幂等。
- **场景**：给缓存加一层、给日志加一层，最后类谱系深得像树。**本质**：用继承堆功能。**要点**：横切能力用装饰器/中间件组合，能运行时开关也能单独测试；抽象层数超过三层先问一句是否真需要。

---

## 📋 一页速查

| 我遇到的信号 | 用什么 | 注意 |
|---|---|---|
| 长 if/else 按类型分支 | 策略 + 映射表 | 新增类型只加类，不改调用方 |
| 创建逻辑复杂、参数多 | 工厂 / 建造者 | 参数 ≤3 个时别上建造者 |
| 需要给对象加横切行为 | 装饰器 / 中间件 | 保持同一接口，可多层嵌套 |
| 跨模块通知 | 观察者 / 事件 | 注意失败隔离，监听方异常不能拖垮主流程 |
| 访问外部资源需控制 | 代理 | 懒加载、鉴权、缓存都适用 |
| 多个处理器按序尝试 | 责任链 | 必须有终止条件，否则死循环 |
| 只是「以后可能扩展」 | 先不抽象 | 第二次重复时再提炼 |

---

## 🔗 相关链接

- [架构设计](./04-architecture-design.md) — 架构层面的设计原则
