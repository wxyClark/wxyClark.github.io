城市规模持续增长，企业和人总会消亡，而生活节奏变得越来越快

```danger
系统化思考

模型思维

【五问法】有助于识别问题的根本原因
```

# 架构师应该知道的37件事情

```tip
37是值 。37 口径的 弹药，指重要的事情，不是指数量
```

## 架构

```danger
系统如果有太多的外部依赖，就会陷入麻烦
```


* 架构现实世界
* 任何系统都有架构，但可能是大泥球(棚户区)架构
* 优秀的架构会为你带来灵活性

* 架构应该记录重要决策并注明基于什么原理、协议、原因
* 判定架构是否符合应用目标

* 企业管理扁平化
* 企业架构是业务流程和IT基础设施的组织逻辑。二者共同反映了企业运营模式的集成和标准化需求
* 企业架构是业务和IT架构之间的黏合剂

* 大多数时间浪费在排队中


## 架构师

* 定义IT战略
* 架构师是变革促进者：是大型企业IT转型中至关重要的一员

## 架构师的技能

```tip
架构师用三条腿立足：技能、影响力、领导力
```

* 能够上下沟通
* 不止一种角色模型
* 明白自己在企业中的位置
* 具备专业技能
* 是优秀的决策者
* 刨根问底以找到问题的根源

### IT技能
  
### 沟通

```danger
加速反馈
```

* 无法理解就无法管理
* 你无法管理你无法衡量的东西
* 【重点突出】胜过面面俱到
* 突击检测，检验听众的接受程度
* 技术作家的目标是：应该仔细斟酌词句结构来帮助读者理解概念，为他们搭建一个平缓的“斜坡”
* 文档是写给大忙人的：不要指望每个人都会逐字阅读，让读者轻松些
* 写作曲线——线性化，思路金字塔，语言言简意赅、突出重点
* 一眼可见的成果展示能获取关注（玩具店里做好的海盗船）
* 一图胜千言，绘图规范（元素、关系、行为）：图例、连线

* 保持人性
* 避免同步点——会议无法扩展
> 会议、电话 是中断、打断

> 电子邮件、聊天工具 是异步通信，可堆积而无须退避

* 规范化的定义和数据模型

### 架构师做什么

```tip
按承诺交付

以客户为中心
```

* 制定标准、原则驱动决策
* 架构师最重要的任务之一就是消除软件设计中那些不可逆的决策
* 重复良性循环
> 第一次我们可能只是学会了【如何完成】某件事情

> 第二次才可能明白【为什么】要这样做，理解更深刻

* 五问法找到问题的根源：反复追问才可以揭示出决策和假设
* (构建-衡量-学习) 无限循环

## 系统

```tip
质量与速度 反相关
```

* 系统抗拒改变
* 大多数稳定的系统包括让其保持某个稳定状态的负反馈回路
* 简单化与灵活性：简单的事情应该简单，但依旧保有完成复杂事情的可能
* 遗留系统都是基于过时的技术构建的，依然发挥业务功能，变更会让开发者恐惧
* 遗留系统出现问题时，难以排查。如果变更会疼，就多做几次
* 系统供应商的地图会失真(为了突出自己)，架构师应该有自己的IT全景图
* 把【变更】和【运行】分开，制定【发布】标准流程
* 永远不要派人去干机器的活——自动化，部署必须可重复
* 自动化测试就是IT系统的安全带
* 缓慢的混乱并不是有序
* 运行时间必须有弹性
* 开发速率确保你能敏捷地完成代码变更。（如果diam里充满了技术债务，你就会在这些地方变慢）
* 吃自家狗粮——员工也是客户


* 同步点限制了系统的吞吐量
* 队列可以处理 流量整形，这样就允许“服务”以最优速率来处理请求，不会超载

## 软件定义世界 

* SDX：Software Defined Anything
* 像软件工程师一样思考
* 使用版本控制，可以快速回滚
  使用构建管道：开发、自动化测试、持续集成
* 质量检验自动化


## 管理

* 控制就是假象：控制需要双向沟通，包括理解系统的当前状态
* 速度经济
* 显性知识才是好知识，明确规则，沉淀技术方案
* 延迟成本

## 转型

```danger
如果组织没有痛苦就不会改变

大多数数字化市场是赢家通吃的市场——寡头

保持组织自身的学习能力
```

* 变化是渐进发生的，需要付出大量的时间和心血（类比健身、减肥）、
* 要改变看到的系统行为，你必须改变系统本身
* 设定航向，明确目标
* 有些变更项目远远驶离了大陆(公司总部)，以摆脱旧世界世家的限制

## 拥抱变化

* 拥抱变更的文化
> 谷歌公司有个笑话：每个API都有两个版本，一个已经过时了，另一个还没有完全准备好

## 架构模式

### 消息传递模式

* 每条消息都带有唯一的关联标识
* 异常处理：忽略、幂等性重试、补偿操作
* 高吞吐的系统需要针对最优路径做优化，而不是在出错的时候为那些罕见的情况进行事务处理


## 杂

* 走钢丝编程：只要保持走直线，一切都没问题，但是只要走错一步，就会跌入万丈深渊
* 配置就是编程，不要难为软件使用者
* 配置应该由软件使用者在界面上配置，系统不写死任何业务数据
* 如果不杀死任何系统，你就会被僵尸包围

## 推荐书籍

* 《系统之美》
* 《公用地悲剧》
* 《企业集成模式》
* 《企业架构战略》
* 《思考，快与慢》
* 《决策分析基础》
* 《排队论》