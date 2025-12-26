# Markdown Extension Examples

This page demonstrates some of the built-in markdown extensions provided by VitePress.

## Syntax Highlighting

VitePress provides Syntax Highlighting powered by [Shiki](https://github.com/shikijs/shiki), with additional features like line-highlighting:

**Input**

````md
```js{4}
export default {
  data () {
    return {
      msg: 'Highlighted!'
    }
  }
}
```
````

**Output**

```js{4}
export default {
  data () {
    return {
      msg: 'Highlighted!'
    }
  }
}
```

## Custom Containers

**Input**

```md
::: info
This is an info box.
:::

::: tip
This is a tip.
:::

::: warning
This is a warning.
:::

::: danger
This is a dangerous warning.
:::

::: details
This is a details block.
:::
```

**Output**

::: info
This is an info box.
:::

::: tip
This is a tip.
:::

::: warning
This is a warning.
:::

::: danger
This is a dangerous warning.
:::

::: details
This is a details block.
:::

## More

Check out the documentation for the [full list of markdown extensions](https://vitepress.dev/guide/markdown).



## 图片
![本地图片引用]({{ '/assets/images/mandala-type4.jpg' | relative_url }})

## 图形

### 流程图 Flowchart
适用场景：业务流程、决策逻辑、步骤说明。
> graph TB 表示垂直流程图（TB=从上到下，LR=从左到右）。
> 节点用 [ ]（矩形）、{ }（菱形判断）、( )（圆角矩形）等符号定义。
> 箭头用 --> （实线）、-.->（虚线）、-- 标签 -->（带文本箭头）表示。
> subgraph 可创建子流程块，增强可读性。

```mermaid
graph TD
    A[用户] -->|输入账号密码| B[登录页面]
    
    subgraph "前端层"
        B --> C{表单验证}
        C -->|通过| D[发送登录请求]
        C -->|失败| E[显示错误提示]
    end
    
    D --> F[API 网关]
    
    subgraph "后端服务"
        F --> G[认证服务]
        G --> H{账号密码校验}
        H -->|成功| I[生成 JWT 令牌]
        H -->|失败| J[返回 401 错误]
    end
    
    I --> K[前端存储令牌]
    K --> L[跳转到主页]
    
    %% 样式定义
    classDef frontend fill:#f9f,stroke:#333,stroke-width:2px
    classDef backend fill:#9f9,stroke:#333,stroke-width:2px
    class A,B,C,D,E,F,G,H,I,J,K,L frontend
    class F,G,H,I,J backend
```

### 时序图（Sequence Diagram）

适用场景：系统交互、API 调用流程、多角色协作。
工具：Mermaid 或 PlantUML。

```mermaid
sequenceDiagram
    title 用户登录时序图
    participant User as 用户
    participant App as 客户端
    participant Server as 后端服务
    participant DB as 数据库
    
    User ->> App: 输入账号密码
    App ->> Server: 发送登录请求【Token】
    activate Server  
    
    Server ->> DB: 查询用户信息
    DB -->> Server: 返回用户数据
    Server -->> App: 登录结果【成功/失败】
    deactivate Server  
    
    alt 登录成功
        App ->> User: 显示首页
    else 登录失败
        App ->> User: 提示"账号或密码错误"
    end
    
    loop 30分钟无操作
        App ->> Server: 心跳检测
        Server -->> App: 保持连接
    end
```

### 类图（Class Diagram）
适用场景：面向对象设计、数据模型定义、类间关系。
```mermaid
classDiagram
    class Animal {
        - name: String
        - age: int
        + eat(food: String): void
        + sleep(): void
    }
    
    class Dog {
        + breed: String
        + bark(): void
    }
    
    class Cat {
        + color: String
        + climb(): void
    }
    
    Animal <|-- Dog  
    Animal <|-- Cat
    Dog "1" --> "*" Toy : 玩耍  
    note for Cat "擅长抓老鼠"  
```
说明：
> 类成员用 +（公有）、-（私有）、#（保护）标记可见性。
> 关系符号：<|--（继承）、-->（关联）、..|>（实现接口）、--*（聚合）。

### 甘特图（Gantt Chart）
适用场景：项目排期、任务进度管理、时间规划。

```mermaid
gantt
    dateFormat  YYYY-MM-DD
    title 产品开发甘特图
    axisFormat  %m-%d 
    
    section 设计阶段
    需求分析       :a1, 2023-10-01, 10d
    UI设计         :after a1, 8d
    技术方案评审   :after a1, 5d
    
    section 开发阶段
    后端API开发    :a2, 2023-10-15, 15d
    前端页面开发   :parallel, after a2, 12d  
    数据库设计     :after a1, 7d
    
    section 测试阶段
    单元测试       :a3, after a2, 5d
    集成测试       :a4, after a3, 7d
    note right of 集成测试 : 含压力测试
```

说明：
> dateFormat 定义日期格式，section 划分任务组。
> 任务用 任务名 : 标识, 开始日期, 持续时间 定义，after 任务标识 表示依赖关系。
> parallel 标记并行任务，note 可添加说明文本。

### 状态图（State Diagram）

```mermaid
stateDiagram-v2
    [*] --> 创建订单
    创建订单 --> 支付中 : 用户提交订单
    支付中 --> 支付成功 : 完成支付
    支付中 --> 支付失败 : 余额不足
    支付失败 --> 创建订单 : 重新支付
    支付成功 --> 发货中 : 商家处理
    发货中 --> 已收货 : 用户确认
    已收货 --> [*] : 订单完成
    发货中 --> 退款中 : 用户申请退款
    退款中 --> [*] : 退款完成
```

### 饼图（Pie Chart）
```mermaid
pie title "用户付费类型占比"
    "免费用户" : 65
    "月度会员" : 20
    "年度会员" : 10
    "终身会员" : 5
    %% 数据来源：2023年Q3统计
```