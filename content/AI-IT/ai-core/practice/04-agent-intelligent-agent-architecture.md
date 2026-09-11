# 04 — Agent 智能代理架构

> 让AI从"问答工具"进化为"自主执行者"
> 目标：掌握Agent设计模式，构建能自主决策和执行的AI系统

---

## 一、Agent 核心概念

### 1.1 什么是 Agent？

```mermaid
flowchart TB
    subgraph 传统AI["传统AI（被动响应）"]
        A1["用户提问"] --> A2["AI回答"]
        A2 --> A3["结束"]
    end
    
    subgraph Agent["Agent（主动执行）"]
        B1["用户目标"] --> B2["感知环境"]
        B2 --> B3["推理规划"]
        B3 --> B4["执行行动"]
        B4 --> B5["观察结果"]
        B5 --> B6{"目标达成？"}
        B6 -->|否| B3
        B6 -->|是| B7["完成任务"]
    end
    
    style B1 fill:#e3f2fd
    style B4 fill:#e8f5e9
    style B7 fill:#FFD700
```

**核心区别：**
- 传统AI：**你问 → 我答**（被动响应）
- Agent：**给你目标 → 我自主完成**（主动执行）

### 1.2 Agent 五大核心能力

```mermaid
graph TD
    A["智能Agent"] --> B["👁️ 感知能力<br/>获取环境信息"]
    A --> C["🧠 推理能力<br/>分析与决策"]
    A --> D["🛠️ 执行能力<br/>调用工具行动"]
    A --> E["💾 记忆能力<br/>存储历史经验"]
    A --> F["🎯 目标导向<br/>持续优化目标"]
    
    style B fill:#e3f2fd
    style C fill:#fff3e0
    style D fill:#e8f5e9
    style E fill:#f3e5f5
    style F fill:#fce4ec
```

---

## 二、Agent 架构设计

### 2.1 经典架构

```mermaid
flowchart LR
    subgraph 环境["🌍 环境"]
        E1["用户"]
        E2["外部系统"]
        E3["数据库"]
    end
    
    subgraph Agent核心["🧠 Agent核心"]
        A1["感知模块<br/>理解输入"]
        A2["知识库<br/>存储记忆"]
        A3["推理引擎<br/>制定决策"]
        A4["规划模块<br/>分解任务"]
        A5["执行模块<br/>调用工具"]
        A6["反馈模块<br/>评估结果"]
    end
    
    E1 & E2 & E3 <--> A1 & A3 & A5
    
    style A3 fill:#FFD700
    style A5 fill:#4ECDC4
```

### 2.2 LLM驱动的现代Agent架构

```mermaid
flowchart TB
    subgraph 用户交互["👤 用户层"]
        U1["用户输入"]
    end
    
    subgraph Agent核心["🧠 Agent核心（LLM驱动）"]
        LLM["LLM大脑<br/>理解意图 + 生成决策"]
        MEM["记忆模块<br/>短期对话 + 长期知识"]
        TOOL["工具调用<br/>搜索/计算/执行"]
        PLAN["规划模块<br/>任务分解 + 步骤安排"]
    end
    
    subgraph 外部世界["🌐 外部世界"]
        EXT1["搜索引擎"]
        EXT2["代码执行器"]
        EXT3["数据库"]
        EXT4["API服务"]
    end
    
    U1 --> LLM
    LLM <--> MEM
    LLM --> PLAN
    PLAN --> TOOL
    TOOL --> EXT1 & EXT2 & EXT3 & EXT4
    EXT1 & EXT2 & EXT3 & EXT4 --> TOOL
    TOOL --> LLM
    LLM --> U2["用户输出"]
    
    style LLM fill:#FFD700
    style TOOL fill:#4ECDC4
    style MEM fill:#e3f2fd
```

### 2.3 核心组件详解

#### 记忆模块

```mermaid
flowchart TB
    subgraph 记忆分层["记忆三层架构"]
        S1["短期记忆<br/>当前对话上下文<br/>约2000字"]
        S2["中期记忆<br/>近期对话记录<br/>会话期间保留"]
        S3["长期记忆<br/>向量数据库存储<br/>可永久检索"]
    end
    
    LLM["LLM"] <--> S1
    S1 <--> S2
    S2 <--> S3
    
    style S1 fill:#fff3e0
    style S2 fill:#e3f2fd
    style S3 fill:#e8f5e9
```

| 记忆类型 | 存储方式 | 访问方式 | 生命周期 |
|----------|----------|----------|----------|
| **短期记忆** | LLM Context Window | 直接读取 | 当前会话 |
| **中期记忆** | Redis/内存 | 按时间检索 | 数小时~数天 |
| **长期记忆** | 向量数据库 | 语义相似度检索 | 永久 |

#### 工具模块

```mermaid
flowchart LR
    A["工具定义"] --> B["工具注册"]
    B --> C["工具调用"]
    C --> D["结果返回"]
    
    subgraph 工具类型["常用工具类型"]
        T1["搜索工具<br/>Web搜索/站内搜索"]
        T2["计算工具<br/>计算器/代码执行"]
        T3["数据库工具<br/>SQL查询/数据检索"]
        T4["文件工具<br/>读写文件/处理文档"]
        T5["API工具<br/>外部服务调用"]
    end
    
    T1 & T2 & T3 & T4 & T5 --> A
    
    style T1 fill:#e3f2fd
    style T2 fill:#fff3e0
    style T3 fill:#e8f5e9
    style T4 fill:#f3e5f5
    style T5 fill:#fce4ec
```

---

## 三、多Agent协作系统

### 3.1 协作模式

```mermaid
flowchart TB
    subgraph 层级式["🏛️ 层级式协作"]
        C1["协调Agent<br/>任务分解与分配"]
        C1 --> C2["专家Agent 1<br/>专项执行"]
        C1 --> C3["专家Agent 2<br/>专项执行"]
        C1 --> C4["专家Agent 3<br/>专项执行"]
        C2 & C3 & C4 --> C5["结果汇总"]
    end
    
    subgraph 平等式["🤝 平等式协作"]
        E1["Agent A"] <--> E2["Agent B"]
        E1 <--> E3["Agent C"]
        E2 <--> E3
    end
    
    subgraph 混合式["⚡ 混合式协作"]
        H1["协调Agent"] --> H2["执行Agent组"]
        H2 <--> H3["评审Agent"]
        H3 --> H1
    end
```

### 3.2 典型多Agent架构

```mermaid
flowchart TD
    subgraph 协调层["🎯 协调层"]
        COORD["协调Agent<br/>意图识别 + 任务分配"]
    end
    
    subgraph 执行层["⚙️ 执行层"]
        W1["研究Agent<br/>信息搜集与整理"]
        W2["分析Agent<br/>数据分析与洞察"]
        W3["写作Agent<br/>内容生成与润色"]
        W4["审核Agent<br/>质量检查与修正"]
    end
    
    subgraph 工具层["🛠️ 工具层"]
        TOOLS["搜索工具 / 代码执行 / 文件处理 / API调用"]
    end
    
    COORD --> W1 & W2 & W3 & W4
    W1 & W2 & W3 & W4 --> TOOLS
    
    W1 --> W2 --> W3 --> W4
    
    style COORD fill:#FFD700
    style W1 fill:#e3f2fd
    style W2 fill:#fff3e0
    style W3 fill:#e8f5e9
    style W4 fill:#f3e5f5
```

---

## 四、ReAct 模式详解

### 4.1 推理-行动循环

```mermaid
flowchart LR
    O["Observation<br/>观察当前状态"] --> T["Thought<br/>思考下一步"]
    T --> A["Action<br/>执行动作"]
    A --> O
    
    style O fill:#e3f2fd
    style T fill:#fff3e0
    style A fill:#e8f5e9
```

### 4.2 ReAct 示例

```
用户：北京的天气怎么样？如果超过25度，帮我订一张去青岛的高铁票

Agent思考过程：
Thought: 我需要先查询北京今天的天气情况
Action: search_weather(city="北京")
Observation: 北京今天气温32°C，晴天

Thought: 天气超过25度，需要帮用户订高铁票
Action: search_trains(departure="北京", destination="青岛", date="今天")
Observation: 找到G101次列车，10:00发车，二等座548元

Thought: 需要确认用户是否要预订
Action: ask_confirmation(train="G101", price=548, time="10:00")
User: 好的，帮我预订
Action: book_train(train_id="G101", seat="2F")
Observation: 预订成功！订单号：CN20260816001
Thought: 任务完成，向用户报告结果
Final Answer: 已为您预订G101次高铁，10:00从北京出发，12:30抵达青岛，二等座548元，订单号CN20260816001
```

---

## 五、Agent 实现代码

### 5.1 基础Agent实现

```python
# agent.py
from langchain.agents import initialize_agent, AgentType
from langchain.tools import Tool
from langchain.llms import OpenAI

# 定义工具
def search_web(query: str) -> str:
    """搜索网页，返回相关信息"""
    # 实际调用搜索引擎API
    return f"搜索结果: {query}"

def calculate(expression: str) -> str:
    """数学计算器"""
    try:
        result = eval(expression)
        return f"计算结果: {result}"
    except:
        return "计算失败"

# 初始化Agent
llm = OpenAI(temperature=0)
tools = [
    Tool(
        name="Search",
        func=search_web,
        description="搜索网页信息"
    ),
    Tool(
        name="Calculator",
        func=calculate,
        description="执行数学计算"
    )
]

agent = initialize_agent(
    tools,
    llm,
    agent=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
    verbose=True
)

# 运行Agent
result = agent.run("北京今天天气如何？如果超过30度，计算100+200的结果")
print(result)
```

### 5.2 带记忆的Agent

```python
# memory_agent.py
from langchain.memory import ConversationBufferMemory
from langchain.chains import ConversationChain

# 带记忆的对话Agent
memory = ConversationBufferMemory(
    memory_key="chat_history",
    return_messages=True
)

conversation = ConversationChain(
    llm=llm,
    memory=memory,
    verbose=True
)

# 多轮对话，Agent会记住之前的内容
conversation.predict(input="我叫小明，我喜欢打篮球")
conversation.predict(input="我刚才说什么爱好？")
# Agent会回答："你喜欢打篮球"
```

### 5.3 多Agent协作示例

```python
# multi_agent.py
from langchain.agents import AgentExecutor, create_react_agent
from langchain import hub

class ResearchAgent:
    """研究Agent：负责信息搜集"""
    def __init__(self, llm, tools):
        self.llm = llm
        self.tools = tools
        self.prompt = hub.pull("hwchase17/react")
        self.agent = create_react_agent(llm, tools, self.prompt)
        self.executor = AgentExecutor(
            agent=self.agent, 
            tools=tools, 
            verbose=True
        )
    
    def research(self, topic: str) -> str:
        return self.executor.invoke({"input": f"研究主题：{topic}"})

class WritingAgent:
    """写作Agent：负责内容生成"""
    def __init__(self, llm):
        self.llm = llm
    
    def write(self, research: str, style: str) -> str:
        prompt = f"请基于以下研究内容，写一篇{style}风格的文章：\n{research}"
        return self.llm.invoke(prompt)

class CoordinatorAgent:
    """协调Agent：负责任务分配"""
    def __init__(self, llm, research_agent, writing_agent):
        self.llm = llm
        self.research = research_agent
        self.writing = writing_agent
    
    def run(self, topic: str, style: str) -> str:
        # 1. 研究
        research_result = self.research.research(topic)
        # 2. 写作
        article = self.writing.write(research_result, style)
        return article
```

---

## 六、Agent 评估与优化

### 6.1 评估指标

```mermaid
flowchart TD
    A["Agent性能评估"] --> B["任务完成率<br/>成功完成任务的比例"]
    A --> C["执行效率<br/>完成任务所需时间和步骤数"]
    A --> D["决策质量<br/>决策的正确性和合理性"]
    A --> E["资源消耗<br/>API调用次数和成本"]
    A --> F["用户体验<br/>用户对Agent表现的满意度"]
    
    style B fill:#e3f2fd
    style C fill:#fff3e0
    style D fill:#e8f5e9
    style E fill:#f3e5f5
    style F fill:#fce4ec
```

### 6.2 常见问题与解决

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| Agent循环执行 | 工具调用失败但未处理 | 添加最大步数限制 |
| 工具选择错误 | 工具描述不够清晰 | 优化工具描述和示例 |
| 记忆丢失 | 上下文窗口溢出 | 实现记忆压缩和摘要 |
| 响应缓慢 | 每步都调用LLM | 批处理 + 缓存机制 |
| 幻觉严重 | 缺乏事实核查 | 添加验证步骤 |

---

## 七、本章总结

```mermaid
mindmap
    root((Agent核心要点))
        核心能力
            感知环境
            推理决策
            执行行动
            记忆学习
            目标导向
        架构类型
            单Agent
            多Agent协作
            层级式/平等式/混合式
        关键模式
            ReAct
            Tree of Thoughts
            Plan-and-Execute
        核心组件
            LLM大脑
            记忆系统
            工具集
            规划器
```

> **核心结论：** Agent的本质是让AI从"问答者"变为"执行者"。关键在于赋予AI感知、推理、执行、记忆的完整闭环能力。

---

## 延伸阅读

- [03 RAG检索增强生成系统](./03-rag-retrieval-augmented-generation.md) — Agent的知识来源
- [05 AI工作流搭建](./05-ai-workflow-construction.md) — 多Agent协作的工作流编排
- [07 AI辅助软件开发体系](../engineering/03-ai-assisted-software-development.md) — Agent在实际开发中的应用
