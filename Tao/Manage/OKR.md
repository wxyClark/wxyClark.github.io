# OKR敏捷绩效管理

```danger
OKR的两个核心原则：在精不在多和全体公开、透明。
```


```mermaid
graph TD

        O ==1==> P 
        A ==> KRs
        
    subgraph PDCA循环
        P((Plan<br>计划 <br>目标设定)) -.-> D  
        D[Do Design<br>方案 执行<br>实施管理] -.-> C
        C[Check Control Clean <br>检查 沟通 控制<br>考核评价] -.-> A
        A[Act Aim<br>处理 改善 清理<br>结果应用 激励]-.-> R1
        
        R1{improve<br>改进 优化}-.-> P
    end
    
        A --> W1
        H -->R1

        SMART[用SMART方法写出目标] --> O 

    subgraph OKR
        
        O((Objective<br>目标))-.-> O1[OKR敏捷目标设定]
        O1-.->O2[持续反馈与教练]
        O2-.->O3[考核与薪酬]
        O3-.->O4[激励与认可]
        O4--> KRs>Key Results<br>关键结果]

        Review[复盘]

        O4-.->Review-.->O1
    end

    subgraph 5W1H
        W1((What<br>对象 问题定义))-.->W2
        W2[Where<br>场所 地点]-.->W3
        W3[When<br>时间 程序]-.->W4
        W4[Who<br>责任人 谁干的]-.->W5
        W5[Why<br>为什么 原因]-.->H
        H[How<br>这么办 经验]
    end
```


```mermaid
graph LR
subgraph SMART原则
        SMART[用SMART方法写出目标]
        SMART --> S[Specific 具体的 需要改进的区域]
        SMART --> M[Measurable 可衡量的 数量结果或参考系]
        SMART --> AA[Attainable 可实现的 跳一跳够得着的桃子<br>Assignable 指定的 唯一负责人]
        SMART --> R[Relevant 相关性 目标要与承担目标者的工作相关]
        SMART --> T[Time-related 限时的 有明确的完成时间]
    end
```

```mermaid
graph LR
    subgraph 美军AfterActionReview复盘流程
            Review[复盘]
            Review-->RV1[回顾目标]
                RV1-->RV11[分清目的和目标]
                RV1-->RV12[确定量化模板或里程碑标志]
                RV1-->RV13[预先行动构想]
            Review-->RV2[评估结果]
                RV2-->RV21[坦诚 不抱怨 不指责]
                RV2-->RV22[重现关键事件情景]
                RV2-->RV23[找出成功和不足]
            Review-->RV3[分析原因]
                RV3-->RV31[检视 目的/目标 设定]
                RV3-->RV32[分析成功 多客观]
                RV3-->RV33[分析不足 多主观]
            Review-->RV4[总结经验]
                RV4-->RV41[尽可能扩展 不要就事论事]
                RV4-->RV42[小心谨慎 不能吧一时认识作为规律]
        end
```

## WHAT

* OKR是一个设定目标的工具
* OKR是一个组织沟通的工具
* OKR是通过结果去衡量过程的方法
* OKR是一种能促进员工与团队协同工作的思维方式
* OKR是当前(VUCAs时代)的最佳实践


### VUCA时代

| VUAC |  | VS |  | VUCA Prime |
| ---- | ---- | ---- | ---- | ---- |
| Volatility | <b>动荡</b><br>变化的速度快，明天不可知 | <b>应</b> | <b>愿景</b><br>为创造更美好的未来注入了强大的动力 | Vision |
| Uncertainty | <b>无常</b><br>不确定性大，未来难预测 | <b>对</b> | <b>明白</b><br>唯有变化是不变的，拥抱变化 | Ubderstanding |
| Complexity | <b>复杂</b><br>影响因素多赢，管理关系复杂 | <b>方</b> | <b>明确</b><br>明确事物的本质和商业的基本规律 | Clarify |
| Ambiguity | <b>模糊</b><br>对事物缺乏清晰准确的认知 | <b>法</b> | <b>敏捷</b><br>迅速感知变化并可以有效地作出反应 | Agility |

* 敏捷
> 对需求不明、变化快的项目(如：IT),敏捷开发是最佳实践
> 
> 传统金字塔组织容易导致官僚主义，敏捷组织扁平高效、领导力体现为方向和赋能
> 
> “千禧一代”引领的时代习惯于在生活中收获即使反馈，可以说是敏捷时代的一个体现

### O(目标Objective)

| 时效 | 层次 | WHAT | WHO |
| ---- | ---- | ---- | ---- |
| 长期 | <b>使命</b> | 企业存在的意义 | BOSS |
| 5~10年 | <b>愿景</b> | 企业未来清晰可描述的画面<br>远景蓝图、价值观 | CEO |
| 3~5年 | <b>战略</b> | 让愿景落地的具体实施的方向<br>什么对总体成功最重要 | 总监 |
| 季度 | <b>目标-战术</b> | 实现局部、阶段目标的具体方法<br>近期的重点<br>承诺性目标、挑战性目标 | 经理/员工 |
| 月/周 | <b>执行-关键结果</b> | 对战术分解具体的任务和工作<br>我们如何知道已经实现了目标 | 员工 |

* 目标思维：结构化目标设定
* 聚焦思维：最优先、最关键
* 协同思维：纵向分解、横向协同
* 敏捷思维：以客户为中心、快速迭代、持续跟进
* 成长思维：承诺型目标100%完成+挑战性目标

### KR(Key Results关键结果)

* 以结果为导向

## WHY

```danger
企业越大，人员越多，发生内耗和浪费的可能性越大
```

### 绩效

```tip
如何衡量组织：BSC 是围绕企业的战略目标，从 财务、顾客、内部流程、学习与成长 这四个方面对企业进行全面的测评体系

如何考核个人(外在激励、压力)：KPI 是对公司战略目标做分解，能有效反映关机业绩驱动因素变化的衡量参数

如何聚焦目标(自我管理、内驱力)：OKR 是一套明确和跟踪目标及其完成情况的管理工具和方法
```

* 绩效管理的目标
  > 战略目标落地(要干什么、怎么干)
  > 
  > 为管理提供数据支撑(干得好有什么标准？有奖惩吗)
  > 
  > 提高个体和团队能力(告诉大家怎样干得更好)
* 绩效是组织的立命之本
* 传统绩效适应稳定的工业生产环境，强制分布活力曲线2-7-1扼杀创新，加重内耗
* 当企业的管理开始迷信于某种单一化指标，也就意味着组织陷于僵化

### OKR

* OKR敏捷绩效管理模型
  > OKR敏捷目标设定(SMART原则)
  > 
  > 持续反馈与教练(及时反馈、把控) —— 反馈能够促进目标更好地实现
  > 
  > 考核与薪酬(参考，不直接画等号) —— OKR执行结果不做业绩考核
  > 
  > 激励与认可(提升主动性、积极性)


* OKR的价值

  > 提升公司战略执行的聚焦度
  > 
  > 培育团队成员的目标和结果意识
  > 
  > 加强跨部门和层级的沟通，让企业更加扁平
  > 
  > 让企业更适应快速的变化
  > 
  > 识别出搞绩效员工

## HOW

```danger
【明确战略】是设定OKR的前提，OKR不仅是一种【衡量目标进展】的方法，还是一种【沟通工具】
```
* 方向——回顾使命，澄清愿景
* 制定目标——根据上级OKR制定承诺性目标(100%完成)
* 制定目标——从使命、角色出发制定挑战性目标(内驱、创新)，对组织未来有重要意义
* 思考策略——根据目标，分析和思考如何去完成目标，寻找策略、方法、措施
* 定义任务结果——这个结果对目标有没有作用，这个结果是否能确保任务完成
* 确定结果——定义量化方法、参照
* 撰写OKR——写下目标，公开透明

### 如何撰写OKR

* 如何撰写目标
  > 目标要能支撑战略，寻找目标的意义
  > 
  > 少而精(每个季度1页A4纸；2~5个O,每个O有2~4个KR)，寻找问题的根源
  > 
  > 适当野心，不要设定一些平常的目标——没有成长
  > 
  > 有时限(双周/月/6周/季度/年)
  > 
  > 由下而上(主动参与、内驱力)
  > 
  > 定性和定量，表达清晰，避免模棱两可

* 如何撰写关键结果
  > 基于目标，抓住少量关键结果
  > 
  > 可量化，能够衡量中期进度
  > 
  > 要有挑战性，要有明确的负责人

* OKR打分原则：简单易行，[0, 1],合理分值是[0.6, 0.7]

### OKR日常管理

* 日站会：昨天做了什么来帮助团队，今天要做什么，遇到的问题和需要协调的资源
* 周例会：目标进度确认，风险预估，得失总结，下周计划
* 月例会：进度确认，根据需要调整OKR、优先级
* 季度复盘会：复盘上一季度的OKR，确定当季的OKR，1~2天
* 半年/年度复盘与展望会：评价结果，未来规划，提升与改善的具体措施

### OKR实施要点

* 要有具体的执行方案
* 负责人决定原则：谁最有利于目标实现就让谁负责，其次 谁提出的谁负责
* 定期检查，双向沟通，及时调整
* 执行结果不做业绩考核。分数的唯一用途是让员工诚实、准确地评判自身表现，以保证执行的过程不会出现畸形结果
* 公开透明
* 保持流程简洁，找到合适的工具
* 让每位员工觉得自己很重要

### 沟通与面谈

* 一对一正式面谈
  > 同步：经理与员工对所有问题的裂解保持一致
  > 
  > 表扬：表扬员工的成绩，从而激励员工
  > 
  > 解决：员工在绩效实现过程中出现的问题
  > 
  > 提高：提高员工的能力，从而提高绩效结果
  > 
  > 行动：面谈之后，员工必须积极实施行动方案

* 非正式沟通
  > 【强调平等】，管理者把姿态放低到跟员工一样的水平
  > 
  > 非正式会议：就地解决问题
  > 
  > 闲聊、吃饭：增加熟悉的机会，拉近关系
  > 
  > 体会员工视角，有利于发现组织中更加根源性的问题

* 面谈流程
  > (1)良好的气氛开场：轻松为主
  > 
  > (2)进入主题：告知本轮面谈的目的与主要内容
  > 
  > (3)倾听部属自述：多提问(开放式问题、5W1H)，多给员工发表自己意见的机会
  > 
  > (4)告知考核结果：一定要非常明确地告知考核结果与原因
  > 
  > (5)探讨沟通：讨论员工关心的问题、需要改善的方面,把关注点放在员工身上
  > 
  > (6)讨论并设定下期工作目标
  > 
  > (7)双方总结：总结讨论要点，再次确认制定的行动方案
  > 
  > (8)以积极的语气结束本轮面谈（三明治）
  > 
  > (9)整理面谈记录：会议纪要、存档

* 面谈技巧
> 我看到你的有点是……，我看你可以提高的地方是……

## 企业文化

* 敏捷
* 教练文化
* 以客户为中心
