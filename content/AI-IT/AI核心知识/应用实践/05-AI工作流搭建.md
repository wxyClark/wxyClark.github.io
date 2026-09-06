# 05 — AI 工作流搭建

> 将AI能力集成到业务流程中，实现自动化与智能化
> 目标：掌握工作流引擎选型、编排设计和监控优化方法

---

## 一、工作流基础概念

### 1.1 什么是AI工作流？

```mermaid
flowchart LR
    subgraph 传统流程["传统自动化流程"]
        A1["触发条件"] --> A2["固定步骤1"]
        A2 --> A3["固定步骤2"]
        A3 --> A4["固定步骤3"]
        A4 --> A5["输出结果"]
    end
    
    subgraph AI工作流["AI增强工作流"]
        B1["触发条件"] --> B2["AI理解意图"]
        B2 --> B3{"分支判断"}
        B3 -->|情况A| B4["AI执行方案A"]
        B3 -->|情况B| B5["AI执行方案B"]
        B4 & B5 --> B6["人工审核"]
        B6 --> B7["输出结果"]
    end
    
    style B2 fill:#FFD700
    style B3 fill:#FFD700
    style B6 fill:#e8f5e9
```

**核心差异：** AI工作流 = **固定流程** + **AI动态决策** + **人机协作**

### 1.2 工作流核心要素

```mermaid
graph TB
    subgraph 要素["工作流六大要素"]
        N1["⏰ 触发器<br/>何时启动"]
        N2["📋 节点<br/>执行什么"]
        N3["🔀 条件分支<br/>走向哪里"]
        N4["🔄 循环控制<br/>重复执行"]
        N5["📊 数据流转<br/>传递什么"]
        N6["⚠️ 错误处理<br/>异常怎么办"]
    end
    
    style N1 fill:#e3f2fd
    style N2 fill:#fff3e0
    style N3 fill:#e8f5e9
    style N4 fill:#f3e5f5
    style N5 fill:#fce4ec
    style N6 fill:#e0f2f1
```

---

## 二、工作流引擎选型

### 2.1 主流引擎对比

```mermaid
quadrantChart
    title AI工作流引擎选型矩阵
    x-axis 开发复杂度低 --> 开发复杂度高
    y-axis 轻量级 --> 企业级
    quadrant-1 企业级重型方案
    quadrant-2 轻量快速方案
    quadrant-3 空白区域
    quadrant-4 中间地带
    
    "LangChain<br/>LangGraph" : [0.4, 0.8]
    "n8n" : [0.3, 0.6]
    "Airflow" : [0.6, 0.9]
    "Camunda" : [0.7, 0.95]
    "Dify" : [0.25, 0.5]
    "Coze Workflows" : [0.15, 0.4]
```

| 引擎 | 类型 | 特点 | 适用场景 |
|------|------|------|----------|
| **LangChain/LangGraph** | LLM原生 | 专为AI设计，支持Agent | AI应用开发 |
| **n8n** | 可视化 | 拖拽式设计，无需编码 | 业务自动化 |
| **Dify** | LLM原生 | 低代码平台，中文友好 | 快速原型 |
| **Airflow** | 数据流 | 强大的调度监控 | 数据管道 |
| **Camunda** | BPMN | 企业级流程引擎 | 复杂业务流程 |

### 2.2 选型决策树

```mermaid
flowchart TD
    A["选择工作流引擎"] --> B{"是否需要LLM原生支持?"}
    B -->|是| C{"是否需要可视化设计?"}
    B -->|否| D{"流程复杂度?"}
    
    C -->|是| E["LangGraph<br/>代码优先+可视化"]
    C -->|否| F["n8n<br/>纯可视化设计"]
    
    D -->|简单| G["n8n / Dify"]
    D -->|复杂| H["Camunda / Airflow"]
    
    style E fill:#e8f5e9
    style F fill:#fff3e0
    style G fill:#e3f2fd
    style H fill:#f3e5f5
```

---

## 三、工作流设计原则

### 3.1 设计原则

```mermaid
flowchart LR
    P1["模块化<br/>独立可复用"] --> P2
    P2["清晰顺序<br/>执行路径明确"] --> P3
    P3["异常处理<br/>完善错误机制"] --> P4
    P4["可监控<br/>状态可追踪"] --> P5
    P5["可扩展<br/>易于添加新节点"] --> P6
    P6["测试友好<br/>便于调试验证"]
    
    style P1 fill:#e3f2fd
    style P2 fill:#fff3e0
    style P3 fill:#e8f5e9
    style P4 fill:#f3e5f5
    style P5 fill:#fce4ec
    style P6 fill:#e0f2f1
```

### 3.2 典型工作流模式

#### 模式一：串行流水线

```mermaid
flowchart LR
    A["输入"] --> B["处理节点1"]
    B --> C["处理节点2"]
    C --> D["处理节点3"]
    D --> E["输出"]
```

#### 模式二：条件分支

```mermaid
flowchart TD
    A["输入"] --> B{"条件判断"}
    B -->|条件A| C["处理路径A"]
    B -->|条件B| D["处理路径B"]
    B -->|条件C| E["处理路径C"]
    C & D & E --> F["合并输出"]
```

#### 模式三：循环处理

```mermaid
flowchart LR
    A["输入集合"] --> B["遍历每个元素"]
    B --> C["AI处理"]
    C --> D{"还有元素?"}
    D -->|是| B
    D -->|否| E["汇总输出"]
```

#### 模式四：并行编排

```mermaid
flowchart TB
    A["输入"] --> B1["并行任务1"]
    A --> B2["并行任务2"]
    A --> B3["并行任务3"]
    B1 & B2 & B3 --> C["结果汇聚"]
    C --> D["最终输出"]
```

---

## 四、工作流编排实践

### 4.1 LangChain 工作流示例

```python
# workflow.py
from langchain.prompts import PromptTemplate
from langchain.llms import OpenAI
from langchain.chains import LLMChain, SequentialChain
from langchain.tools import Tool

# 定义链1：意图识别
intent_prompt = PromptTemplate(
    input_variables=["text"],
    template="""分析以下文本的意图：
{text}
请用以下格式输出：
意图：[搜索/计算/翻译/其他]
关键词：[关键词列表]"""
)
intent_chain = LLMChain(llm=OpenAI(), prompt=intent_prompt, output_key="intent")

# 定义链2：内容生成
generate_prompt = PromptTemplate(
    input_variables=["intent", "keywords"],
    template="""基于意图【{intent}】和关键词【{keywords}】，
生成一段简洁的回答。"""
)
generate_chain = LLMChain(llm=OpenAI(), prompt=generate_prompt, output_key="answer")

# 组合工作流
workflow = SequentialChain(
    chains=[intent_chain, generate_chain],
    input_variables=["text"],
    output_variables=["intent", "answer"],
    verbose=True
)

# 运行工作流
result = workflow({"text": "北京今天天气怎么样？"})
print(result["answer"])
```

### 4.2 带条件的智能工作流

```python
# intelligent_workflow.py
from langchain.agents import AgentExecutor, create_tool_calling_agent
from langchain.tools import tool

# 定义工具
@tool
def search_weather(city: str) -> str:
    """查询城市天气"""
    return f"{city}今天晴朗，气温25°C"

@tool
def calculate_math(expression: str) -> str:
    """数学计算"""
    return f"结果是: {eval(expression)}"

@tool
def translate_text(text: str, target_lang: str) -> str:
    """翻译文本"""
    return f"翻译结果: {text} -> [{target_lang}]"

# 创建智能Agent工作流
agent = create_tool_calling_agent(llm, [search_weather, calculate_math, translate_text], prompt)
agent_executor = AgentExecutor(agent=agent, tools=[search_weather, calculate_math, translate_text], verbose=True)

# 工作流执行
result = agent_executor.invoke({
    "input": "帮我查一下上海的天气，然后计算100*200"
})
```

### 4.3 带记忆的工作流

```python
# memory_workflow.py
from langchain.memory import ConversationBufferWindowMemory

memory = ConversationBufferWindowMemory(
    k=5,  # 保留最近5轮对话
    memory_key="chat_history",
    return_messages=True
)

# 工作流中使用记忆
workflow_with_memory = SequentialChain(
    chains=[intent_chain, generate_chain],
    input_variables=["text"],
    output_variables=["intent", "answer"],
    memory=memory,  # 注入记忆
    verbose=True
)
```

---

## 五、工作流监控与优化

### 5.1 监控指标

```mermaid
flowchart TB
    subgraph 运行监控["📊 运行监控"]
        M1["执行成功率"]
        M2["平均执行时间"]
        M3["错误率分布"]
    end
    
    subgraph 成本监控["💰 成本监控"]
        M4["API调用次数"]
        M5["Token消耗"]
        M6["单次执行成本"]
    end
    
    subgraph 质量监控["🎯 质量监控"]
        M7["用户满意度"]
        M8["输出质量评分"]
        M9["人工干预率"]
    end
    
    style M1 fill:#e3f2fd
    style M4 fill:#fff3e0
    style M7 fill:#e8f5e9
```

### 5.2 优化策略

```mermaid
flowchart TD
    A["工作流优化"] --> B["性能优化"]
    A --> C["成本优化"]
    A --> D["质量优化"]
    
    B --> B1["减少LLM调用次数"]
    B --> B2["并行执行可并行节点"]
    B --> B3["实现结果缓存"]
    
    C --> C1["使用更便宜的模型"]
    C --> C2["优化提示词减少Token"]
    C --> C3["批量处理请求"]
    
    D --> D1["添加人工审核节点"]
    D --> D2["设置质量阈值"]
    D --> D3["收集用户反馈迭代"]
```

### 5.3 错误处理机制

```mermaid
flowchart LR
    E1["错误检测"] --> E2["分类处理"]
    E2 --> E3["临时错误"]
    E2 --> E4["永久错误"]
    E3 --> E5["重试机制<br/>指数退避"]
    E4 --> E6["降级处理<br/>返回默认值"]
    E5 & E6 --> E7["日志记录"]
    E7 --> E8["告警通知"]
    
    style E1 fill:#ffebee
    style E5 fill:#e8f5e9
    style E6 fill:#fff3e0
```

---

## 六、实战案例：AI内容生产工作流

### 6.1 工作流设计

```mermaid
flowchart TB
    subgraph 输入层["📥 输入"]
        I1["用户选题"]
        I2["关键词"]
    end
    
    subgraph 处理层["⚙️ 处理"]
        P1["AI大纲生成"]
        P2["资料检索"]
        P3["内容撰写"]
        P4["AI润色优化"]
        P5["人工审核"]
    end
    
    subgraph 输出层["📤 输出"]
        O1["发布准备"]
        O2["多平台分发"]
    end
    
    I1 & I2 --> P1
    P1 --> P2
    P2 --> P3
    P3 --> P4
    P4 --> P5
    P5 --> O1 --> O2
    
    style P1 fill:#e3f2fd
    style P3 fill:#fff3e0
    style P5 fill:#e8f5e9
```

### 6.2 各节点实现

```python
# content_workflow.py
from langchain.chains import SequentialChain, LLMChain
from langchain.prompts import PromptTemplate
from langchain.llms import OpenAI

# 节点1：大纲生成
outline_prompt = PromptTemplate(
    input_variables=["topic"],
    template="请为'{topic}'生成文章大纲，包含3-5个主要章节"
)

# 节点2：资料检索（调用搜索工具）
research_prompt = PromptTemplate(
    input_variables=["outline"],
    template="基于以下大纲，列出需要搜索的关键点：\n{outline}"
)

# 节点3：内容撰写
writing_prompt = PromptTemplate(
    input_variables=["outline", "research"],
    template="根据大纲和资料，撰写完整文章：\n大纲：{outline}\n资料：{research}"
)

# 节点4：AI润色
polish_prompt = PromptTemplate(
    input_variables=["content"],
    template="请润色以下文章，使其更生动有趣：\n{content}"
)

# 组装工作流
content_workflow = SequentialChain(
    chains=[
        LLMChain(llm=llm, prompt=outline_prompt, output_key="outline"),
        LLMChain(llm=llm, prompt=research_prompt, output_key="research"),
        LLMChain(llm=llm, prompt=writing_prompt, output_key="draft"),
        LLMChain(llm=llm, prompt=polish_prompt, output_key="final_content"),
    ],
    input_variables=["topic"],
    output_variables=["final_content"],
    verbose=True
)

# 执行
result = content_workflow({"topic": "AI对教育行业的影响"})
```

---

## 七、本章总结

```mermaid
mindmap
    root((AI工作流核心))
        设计原则
            模块化
            清晰顺序
            异常处理
            可监控
        主流引擎
            LangChain / LangGraph
            n8n
            Dify
            Airflow
        关键模式
            串行流水线
            条件分支
            循环处理
            并行编排
        优化方向
            性能优化
            成本优化
            质量优化
```

> **核心结论：** 好的工作流 = 清晰的结构 + 灵活的编排 + 完善的监控。将AI能力嵌入到标准化流程中，才能实现可持续的智能化升级。

---

## 延伸阅读

- [06 AI工程化实践](./06-AI工程化实践.md) — 工作流的部署与运维
- [07 AI辅助软件开发体系](./07-AI辅助软件开发体系.md) — 工作流在开发中的实际应用
