# 码农翻身

## 尾递归

* n的阶乘 普通递归
> factorial函数在递归过程中会入栈【n】次
```javascript
int factorial(int n) {
    if (n==1) {
        return 1;
    } else {
        return n * factorial(n-1) 
    }
}
```

```tip
【尾递归】生成优化的代码，复用栈帧
```
* n的阶乘 尾递归
> factorial函数在递归过程中会入栈【1】次，复用【n】次
```javascript
int factorial(int n, int result) {
    if (n==1) {
        return 1;
    } else {
        return factorial(n -1, n * result) 
    }
}
```

## 正交性

* 不同的类组合实现功能时，职责划分应朝着正交的方向努力，【把变化封装在一个维度上】
> 如：X轴、Y轴、Z轴，每个维度可以独立变化，互不影响
> 
> 如：日志系统的Logger、Appender、Formatter
>
> 如：(用户管理、订单管理、支付管理) 和 (日志、安全、事务、性能统计)

* AOP 面向切面编程


## 设计模式：装饰者

* 可用于解决重复代码
> 如：入参日志、try{业务逻辑}catch{异常处理}、返回结果日志、执行耗时

```phpregexp
<?php

interface Decorator
{
    public function display();
}

/**
* 核心类
*/
class XiaoFang implements Decorator
{
    private $name;
    
    public function __construct($name)
    {
        $this->name = $name;
    }

    public function display()
    {
        echo "我是" . $this->name . "我要出门" . PHP_EOL;
    }
}

/**
* 装饰边框类
*/
class Finery implements Decorator
{
    private $componment;

    public function __construct(Decorator $componment)
    {
        $this->componment = $componment;
    }

    public function display()
    {
        $this->componment->display();
    }
}

/**
* 装饰物类1
*/
class Shoes extends Finery
{
    public function display()
    {
        echo "穿上鞋子" . PHP_EOL;
        parent::display();
    }
}

/**
* 装饰物类2
*/
class Fire extends Finery
{
    public function display()
    {
        echo "出门前整理头发" . PHP_EOL;
        parent::display();
        echo "出门后整理头发" . PHP_EOL;   
    }
}

$xiaofeng = new XiaoFang("小方");
$shoes = new Shoes($xiaofeng);
$fire = new Fire($shoes);
$fire->display();
```


## web服务

* WSDL 数据传输方式：XML
* SOAP 数据传输方式：XML
* HTTP GET/POST：JSON

## RSA非对称加密

* 一个保密的私钥+一个公开的公钥
* 用私钥加密的数据，只有对应的公钥才能解密
* 用公钥加密的数据，只有对应的私钥才能解密
* HTTPS 非对称解密(安全性高)+数字签名+对称加密(速度快)

## 不经过后端处理的token

```tip
Hash Fragment www.a.com/callback#token=<授权方返回的token>

#token=<授权方返回的token> 只会停留在浏览器端，只有JavaScript能访问它

并且不会再次通过HTTP Request 发送到别的服务器
```

* 更安全的token：授权码+token
> 限制授权码的有限期，如：5分钟内有效
>
> 限制使用次数：授权码只能换取一次token，第二次需要用refresh_token换取


## 码农需要知道的“潜规则”

```tip
吴思《潜规则》——中国历史中的真实游戏

要透彻地理解一门技术的本质——WHY
```

* 上帝的游戏：局部性原理(时间局部性、空间局部性)
* 访问速度不匹配的解决方案：缓存(硬盘——>内存，内存——>CPU)
* 抛弃细节——抽象
* 减少交流——分层
* 减少等待——异步调用
* 分而治之：子问题、递归
* 养成计算机的思维方式 
* 写作——主动性学习，效率最高
* 保持好奇心，热爱并行动