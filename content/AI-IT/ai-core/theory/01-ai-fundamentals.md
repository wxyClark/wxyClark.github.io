# 01 — AI 基础知识与概念

> 建立AI认知框架：从历史到原理，从模型到工具
> 目标：理解AI系统的核心概念，为后续学习打下基础

---

## 一、AI 发展历程

### 1.1 发展阶段

```mermaid
flowchart LR
    A["1956-1970<br/>初创期"] --> B["1970-1980<br/>AI寒冬"]
    B --> C["1980-1990<br/>专家系统"]
    C --> D["1990-2010<br/>机器学习"]
    D --> E["2010-2020<br/>深度学习"]
    E --> F["2020-至今<br/>大模型时代"]
    
    style A fill:#e3f2fd
    style B fill:#ffebee
    style C fill:#fff3e0
    style D fill:#e8f5e9
    style E fill:#f3e5f5
    style F fill:#e0f2f1,color:#004d40
```

| 阶段 | 时间 | 标志性事件 | 核心特点 |
|------|------|-----------|----------|
| **初创期** | 1956 | 达特茅斯会议，AI概念诞生 | 符号主义，逻辑推理 |
| **寒冬期** | 1970s | 计算能力不足，预期落空 | 研究资金减少 |
| **专家系统** | 1980s | MYCIN等知识系统 | 基于规则的推理 |
| **机器学习** | 1990s | 统计学习方法兴起 | 从数据中学习 |
| **深度学习** | 2010s | AlexNet、ImageNet突破 | 神经网络革命 |
| **大模型时代** | 2020s | GPT-3/4、Claude发布 | 通用语言智能 |

### 1.2 关键技术里程碑

```mermaid
timeline
    title AI技术关键里程碑
    1956 : 达特茅斯会议<br/>AI概念正式提出
    1997 : 深蓝击败国际象棋冠军<br/>AI在特定领域超越人类
    2012 : AlexNet深度学习爆发<br/>ImageNet竞赛颠覆性胜利
    2017 : Transformer架构发布<br/>奠定大模型基础
    2020 : GPT-3发布<br/>大规模预训练范式确立
    2022 : ChatGPT发布<br/>大模型商业化元年
```

---

## 二、大语言模型（LLM）基础

### 2.1 核心概念

```mermaid
graph TB
    subgraph 输入层["📥 输入层"]
        A1["原始文本"]
        A2["Tokenization<br/>文本→Token序列"]
    end
    
    subgraph 模型层["🧠 模型层（Transformer）"]
        B1["Embedding层<br/>Token→向量"]
        B2["Attention机制<br/>理解上下文关系"]
        B3["多层Transformer<br/>特征提取与融合"]
    end
    
    subgraph 输出层["📤 输出层"]
        C1["概率分布<br/>预测下一个Token"]
        C2["采样/解码<br/>生成文本"]
    end
    
    A1 --> A2 --> B1 --> B2 --> B3 --> C1 --> C2
    
    style A1 fill:#e3f2fd
    style B2 fill:#fff3e0
    style C1 fill:#e8f5e9
```

### 2.2 关键术语

| 术语 | 解释 | 重要性 |
|------|------|:------:|
| **Token** | 文本的最小处理单位，一个词或子词 | ⭐⭐⭐ |
| **Embedding** | 将文本转换为高维向量表示 | ⭐⭐⭐ |
| **Attention** | 模型关注输入不同部分的机制 | ⭐⭐⭐ |
| **Transformer** | 现代大模型的基础架构 | ⭐⭐⭐ |
| **Context Window** | 模型能同时处理的文本长度 | ⭐⭐ |
| **Temperature** | 控制生成结果的随机性（0-1） | ⭐⭐ |
| **Top-k / Top-p** | 控制采样策略的参数 | ⭐ |
| **Fine-tuning** | 在特定数据上继续训练模型 | ⭐⭐⭐ |

### 2.3 主流模型对比

```mermaid
flowchart TD
    subgraph 国外模型["🌍 国外模型"]
        M1["GPT-4/4o<br/>OpenAI"]
        M2["Claude 3<br/>Anthropic"]
        M3["Gemini 1.5<br/>Google"]
    end
    
    subgraph 国内模型["🇨🇳 国内模型"]
        M4["通义千问 Qwen<br/>阿里"]
        M5["文心一言<br/>百度"]
        M6["DeepSeek<br/>深度求索"]
        M7["混元<br/>腾讯"]
    end
    
    subgraph 开源模型["🔓 开源模型"]
        O1["Llama 3<br/>Meta"]
        O2["Qwen2<br/>阿里"]
        O3["GLM-4<br/>智谱"]
    end
```

| 模型 | 特点 | 适用场景 |
|------|------|----------|
| **GPT-4/4o** | 综合能力最强，多模态 | 通用任务、复杂推理 |
| **Claude 3** | 长上下文，写作质量高 | 长文档处理、内容创作 |
| **DeepSeek** | 性价比高，代码能力强 | 软件开发、成本敏感场景 |
| **通义千问** | 中文能力强，生态丰富 | 中文内容、企业应用 |
| **文心一言** | 中文理解好，百度生态 | 国内企业应用 |
| **Llama 3** | 开源可私有部署 | 数据敏感场景 |

---

## 三、Transformer 架构详解

### 3.1 核心机制

```mermaid
flowchart LR
    A["输入文本"] --> B["Tokenization<br/>分词"]
    B --> C["Embedding<br/>向量化"]
    C --> D["Positional Encoding<br/>位置编码"]
    D --> E["Multi-Head Attention<br/>多头注意力"]
    E --> F["Feed Forward Network<br/>前馈网络"]
    F --> G["Layer Normalization<br/>层归一化"]
    G --> H["输出层<br/>生成Token"]
    
    style E fill:#fff3e0
    style F fill:#fff3e0
```

### 3.2 注意力机制

```mermaid
graph LR
    A["查询 Query"] --> D["注意力权重"]
    B["键 Key"] --> D
    C["值 Value"] --> D
    D --> E["加权输出"]
    
    style D fill:#FF6B6B,color:#fff
```

> **核心思想：** 在处理每个词时，模型会"关注"句子中所有其他词，并决定关注程度。这使模型能够理解词与词之间的关系。

---

## 四、自然语言处理（NLP）基础

### 4.1 核心任务

```mermaid
mindmap
    root((NLP核心任务))
        理解类
            文本分类
            情感分析
            意图识别
            命名实体识别 NER
        生成类
            文本生成
            摘要生成
            翻译
            对话生成
        检索类
            语义搜索
            问答系统
            信息检索
```

### 4.2 典型应用场景

| 场景 | 技术 | 应用 |
|------|------|------|
| 智能客服 | 对话系统 + RAG | 自动回答用户问题 |
| 内容审核 | 文本分类 + 情感分析 | 识别违规内容 |
| 知识检索 | 向量检索 + LLM | 精准回答专业问题 |
| 代码生成 | LLM + Code Interpreter | 辅助编程开发 |
| 数据分析 | NL2SQL + Agent | 自然语言查询数据 |

---

## 五、向量数据库原理

### 5.1 什么是向量？

```mermaid
flowchart TD
    A["文本：'我喜欢人工智能'"] --> B["Embedding模型"]
    B --> C["向量：[0.12, -0.45, 0.78, ...]"]
    C --> D["存储在向量数据库中"]
    
    E["查询：'AI是什么'"] --> F["Embedding模型"]
    F --> G["向量：[0.15, -0.42, 0.81, ...]"]
    G --> H["相似度检索"]
    H --> I["返回最相关的文档"]
    
    style C fill:#e3f2fd
    style G fill:#e8f5e9
```

### 5.2 向量数据库选型

```mermaid
pie title 向量数据库使用场景分布
    "轻量级/开发测试<br/>Chroma" : 30
    "生产环境/分布式<br/>Milvus/Pinecone" : 35
    "高性能/单机部署<br/>FAISS" : 20
    "商业托管<br/>Pinecone/Weaviate" : 15
```

| 数据库 | 类型 | 特点 | 推荐场景 |
|--------|------|------|----------|
| **Chroma** | 开源 | 轻量，Python友好 | 开发测试、小项目 |
| **Milvus** | 开源 | 分布式，高性能 | 大规模生产环境 |
| **Pinecone** | 商业 | 托管式，易用 | 快速上线、商业项目 |
| **FAISS** | 开源 | Meta出品，极高性能 | 单机高性能场景 |
| **Qdrant** | 开源 | Rust编写，过滤强 | 需要复杂过滤的场景 |

### 5.3 相似度计算方法

| 方法 | 公式 | 特点 | 适用场景 |
|------|------|------|----------|
| **余弦相似度** | cos(θ) = A·B / (\|A\|\|B\|) | 最常用，适合高维 | 文本语义检索 |
| **欧氏距离** | √Σ(Ai-Bi)² | 简单直观 | 低维向量 |
| **点积** | A·B | 计算效率高 | 推荐系统 |

---

## 六、AI 技术栈总览

```mermaid
flowchart TB
    subgraph 应用层["🎯 应用层"]
        A1["智能客服"]
        A2["内容生成"]
        A3["代码助手"]
        A4["数据分析"]
    end
    
    subgraph 能力层["⚡ 能力层"]
        B1["RAG系统"]
        B2["Agent系统"]
        B3["工作流引擎"]
    end
    
    subgraph 基础层["🔧 基础层"]
        C1["大语言模型 LLM"]
        C2["向量数据库"]
        C3["Embedding模型"]
    end
    
    subgraph 数据层["📚 数据层"]
        D1["知识库文档"]
        D2["API数据源"]
        D3["业务数据库"]
    end
    
    D1 & D2 & D3 --> C2 & C3
    C1 & C2 & C3 --> B1 & B2 & B3
    B1 & B2 & B3 --> A1 & A2 & A3 & A4
    
    style C1 fill:#FFD700
    style B1 fill:#4ECDC4
    style A1 fill:#FF6B6B,color:#fff
```

---

## 七、本章总结

```mermaid
flowchart LR
    A["AI发展六阶段"] --> B["Transformer是基石"]
    B --> C["LLM是核心能力"]
    C --> D["向量数据库是记忆"]
    D --> E["RAG/Agent是应用形态"]
    
    style A fill:#e3f2fd
    style B fill:#fff3e0
    style C fill:#e8f5e9
    style D fill:#f3e5f5
    style E fill:#fce4ec
```

> **核心结论：** AI系统 = **LLM（大脑）+ 向量数据库（记忆）+ Agent（手脚）+ 工作流（神经系统）**。理解这四大组件的关系，就理解了AI系统的本质。

---

## 延伸阅读

- [02 LLM与提示词工程](./02-llm-prompt-engineering.md) — 深入理解如何与AI有效交互
- [03 RAG检索增强生成系统](../practice/03-rag-retrieval-augmented-generation.md) — AI系统的核心记忆机制
- [12 AI术语表](./03-ai-glossary.md) — 快速查阅专业术语
