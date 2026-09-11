# 06 — AI 工程化实践

> 从实验到生产：AI系统的全生命周期工程化管理
> 目标：掌握AI系统的架构设计、部署运维和性能优化方法

---

## 一、系统架构设计

### 1.1 整体架构

```mermaid
flowchart TB
    subgraph 用户层["👥 用户层"]
        U1["Web应用"]
        U2["移动App"]
        U3["API客户端"]
    end
    
    subgraph 网关层["🚪 网关层"]
        G1["API网关<br/>路由/限流/认证"]
    end
    
    subgraph 服务层["⚡ 服务层"]
        S1["RAG服务"]
        S2["Agent服务"]
        S3["工作流服务"]
        S4["工具服务"]
    end
    
    subgraph 模型层["🧠 模型层"]
        M1["LLM服务<br/>GPT/Claude/DeepSeek"]
        M2["Embedding服务"]
        M3["重排序服务"]
    end
    
    subgraph 数据层["💾 数据层"]
        D1["向量数据库"]
        D2["关系数据库"]
        D3["缓存服务"]
        D4["对象存储"]
    end
    
    subgraph 支撑层["🔧 支撑层"]
        Sup1["监控系统"]
        Sup2["日志系统"]
        Sup3["告警系统"]
    end
    
    U1 & U2 & U3 --> G1 --> S1 & S2 & S3 & S4
    S1 & S2 & S3 & S4 --> M1 & M2 & M3
    S1 --> D1 & D2 & D3
    Sup1 & Sup2 & Sup3 -.-> S1 & S2 & S3 & S4
    
    style G1 fill:#FFD700
    style M1 fill:#FF6B6B,color:#fff
    style D1 fill:#e3f2fd
```

### 1.2 微服务拆分

| 服务 | 职责 | 技术栈 |
|------|------|--------|
| **RAG服务** | 文档处理、向量检索、问答生成 | Python/FastAPI |
| **Agent服务** | 智能代理、工具调用、任务执行 | Python/LangChain |
| **工作流服务** | 流程编排、任务调度、状态管理 | Python/FastAPI |
| **LLM网关** | 模型路由、负载均衡、成本管控 | Go/Node.js |
| **向量服务** | 向量存储、相似度检索 | Python/Chroma-Milvus |
| **文档服务** | 文档上传、解析、版本管理 | PHP/Python |

---

## 二、开发环境搭建

### 2.1 本地开发环境

```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  # LLM服务（本地部署）
  llm-server:
    image: ghcr.io/open-webui/open-webui:latest
    ports:
      - "3000:8080"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - MODEL_ENDPOINT=http://llm-api:8000
  
  # 向量数据库
  chroma:
    image: chromadb/chroma:latest
    ports:
      - "8001:8000"
    volumes:
      - chroma_data:/chroma/chroma
  
  # Redis缓存
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
  
  # PostgreSQL
  postgres:
    image: postgres:15-alpine
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: ai_project
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  chroma_data:
  postgres_data:
```

### 2.2 环境变量配置

```bash
# .env
# API Keys
OPENAI_API_KEY=sk-xxxxxxxx
DEEPSEEK_API_KEY=xxxxxxxx
ANTHROPIC_API_KEY=sk-ant-xxxxxxxx

# 数据库
DATABASE_URL=postgresql://admin:password@localhost:5432/ai_project
REDIS_URL=redis://localhost:6379/0

# 向量数据库
CHROMA_HOST=http://localhost:8001
CHROMA_COLLECTION=ai_documents

# 应用配置
APP_ENV=development
LOG_LEVEL=debug
RATE_LIMIT=100
```

---

## 三、代码实现与测试

### 3.1 项目结构

```
ai-project/
├── app/
│   ├── api/              # API路由
│   │   ├── v1/
│   │   │   ├── rag.py
│   │   │   ├── agent.py
│   │   │   └── workflow.py
│   ├── core/             # 核心配置
│   │   ├── config.py
│   │   └── security.py
│   ├── services/         # 业务逻辑
│   │   ├── rag_service.py
│   │   ├── agent_service.py
│   │   └── workflow_service.py
│   ├── models/           # 数据模型
│   └── main.py           # 应用入口
├── tests/                # 测试
│   ├── test_rag.py
│   ├── test_agent.py
│   └── test_workflow.py
├── docs/                 # 文档
├── scripts/              # 脚本
├── Dockerfile
├── docker-compose.yml
└── pyproject.toml
```

### 3.2 核心服务实现

```python
# app/services/rag_service.py
from typing import List, Dict, Any
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.chains import RetrievalQA
from langchain.llms import OpenAI
import redis

class RAGService:
    def __init__(self):
        self.embeddings = OpenAIEmbeddings()
        self.vector_store = Chroma(
            collection_name="ai_documents",
            embedding_function=self.embeddings,
            persist_directory="./chroma_db"
        )
        self.llm = OpenAI(temperature=0.1)
        self.qa_chain = RetrievalQA.from_chain_type(
            llm=self.llm,
            chain_type="stuff",
            retriever=self.vector_store.as_retriever()
        )
        self.cache = redis.Redis()
    
    def query(self, question: str, top_k: int = 3) -> Dict[str, Any]:
        """执行RAG查询（带缓存）"""
        cache_key = f"rag:{question}"
        
        # 检查缓存
        cached = self.cache.get(cache_key)
        if cached:
            return {"answer": cached.decode(), "cached": True}
        
        # 执行查询
        result = self.qa_chain.invoke({"query": question})
        answer = result["result"]
        
        # 写入缓存（1小时过期）
        self.cache.setex(cache_key, 3600, answer)
        
        return {"answer": answer, "cached": False}
    
    def add_document(self, file_path: str) -> Dict[str, Any]:
        """添加文档到向量库"""
        from langchain.document_loaders import TextLoader
        from langchain.text_splitter import CharacterTextSplitter
        
        loader = TextLoader(file_path)
        documents = loader.load()
        
        text_splitter = CharacterTextSplitter(
            chunk_size=800,
            chunk_overlap=150
        )
        split_docs = text_splitter.split_documents(documents)
        
        self.vector_store.add_documents(split_docs)
        self.vector_store.persist()
        
        return {
            "status": "success",
            "document_count": len(split_docs),
            "message": f"文档添加成功，共{len(split_docs)}个片段"
        }
```

### 3.3 测试策略

```mermaid
flowchart TB
    subgraph 测试金字塔["测试金字塔"]
        P1["E2E测试<br/>10%"]
        P2["集成测试<br/>20%"]
        P3["单元测试<br/>70%"]
    end
    
    subgraph 测试类型["测试类型"]
        T1["功能测试<br/>验证正确性"]
        T2["性能测试<br/>验证速度"]
        T3["安全测试<br/>验证合规"]
        T4["回归测试<br/>验证稳定"]
    end
    
    style P1 fill:#fce4ec
    style P2 fill:#fff3e0
    style P3 fill:#e8f5e9
```

---

## 四、部署与监控

### 4.1 CI/CD 流水线

```mermaid
flowchart LR
    A["代码提交"] --> B["单元测试"]
    B --> C["集成测试"]
    C --> D["镜像构建"]
    D --> E["安全扫描"]
    E --> F["部署测试环境"]
    F --> G["E2E测试"]
    G --> H["部署生产环境"]
    
    style B fill:#e8f5e9
    style E fill:#ffebee
    style H fill:#e3f2fd
```

### 4.2 监控体系

```mermaid
flowchart TD
    subgraph 监控指标["📊 监控指标"]
        M1["业务指标<br/>请求量/成功率/响应时间"]
        M2["模型指标<br/>Token消耗/生成质量"]
        M3["系统指标<br/>CPU/内存/磁盘"]
    end
    
    subgraph 告警阈值["⚠️ 告警阈值"]
        A1["P0: 系统宕机<br/>5分钟告警"]
        A2["P1: 错误率>5%<br/>15分钟告警"]
        A3["P2: 响应时间>5s<br/>30分钟告警"]
    end
    
    M1 & M2 & M3 --> A1 & A2 & A3
    
    style M1 fill:#e3f2fd
    style M2 fill:#fff3e0
    style M3 fill:#e8f5e9
```

### 4.3 关键监控指标

| 指标 | 健康值 | 告警阈值 |
|------|--------|----------|
| **API响应时间** | < 2s | > 5s |
| **请求成功率** | > 99% | < 95% |
| **Token消耗/小时** | 按需 | > 预算80% |
| **向量库查询时间** | < 100ms | > 500ms |
| **LLM调用失败率** | < 1% | > 5% |

---

## 五、性能优化

### 5.1 优化策略

```mermaid
flowchart TB
    subgraph 优化方向["🚀 优化方向"]
        O1["缓存优化"]
        O2["并发优化"]
        O3["模型优化"]
        O4["查询优化"]
    end
    
    O1 --> O1_1["响应缓存<br/>Redis"]
    O1 --> O1_2["向量缓存<br/>热门查询"]
    
    O2 --> O2_1["异步处理<br/>Celery/Redis Queue"]
    O2 --> O2_2["批量处理<br/>减少API调用"]
    
    O3 --> O3_1["模型蒸馏<br/>大模型→小模型"]
    O3 --> O3_2["量化压缩<br/>FP16→INT8"]
    
    O4 --> O4_1["索引优化<br/>HNSW/IVF"]
    O4 --> O4_2["分片策略<br/>水平扩展"]
    
    style O1 fill:#e3f2fd
    style O2 fill:#fff3e0
    style O3 fill:#e8f5e9
    style O4 fill:#f3e5f5
```

### 5.2 缓存策略

```python
# 多级缓存架构
# L1: 内存缓存（最快，容量最小）
# L2: Redis缓存（中等，容量中等）
# L3: 向量数据库（最慢，容量最大）

import redis
from functools import lru_cache

# L1: 内存缓存
@lru_cache(maxsize=100)
def memory_cache_query(question: str) -> str | None:
    """内存缓存热门查询"""
    return None  # 实际实现

# L2: Redis缓存
class RedisCache:
    def __init__(self):
        self.redis = redis.Redis()
    
    def get(self, key: str) -> str | None:
        return self.redis.get(f"cache:{key}")
    
    def set(self, key: str, value: str, ttl: int = 3600):
        self.redis.setex(f"cache:{key}", ttl, value)

# L3: 向量缓存（延迟加载）
class VectorCache:
    def __init__(self, vector_store):
        self.store = vector_store
        self.recent_queries = []
    
    def get(self, question: str, top_k: int = 3) -> list:
        self.recent_queries.append(question)
        return self.store.similarity_search(question, k=top_k)
```

---

## 六、常见问题解决

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| LLM响应慢 | 模型过大/网络延迟 | 使用更快模型+缓存 |
| 向量检索慢 | 数据量大/索引不佳 | 优化索引算法+分片 |
| 内存溢出 | 大批量处理 | 流式处理+分批加载 |
| API限流 | 调用频率过高 | 限流+排队+降级 |
| 成本超支 | Token消耗过大 | 模型降级+提示词优化 |

---

## 七、本章总结

> **核心结论：** AI工程化 = 可靠的架构 + 完善的测试 + 高效的部署 + 持续的监控。只有在工程化层面做到位，AI应用才能从实验走向生产。

---

## 延伸阅读

- [07 AI辅助软件开发体系](./03-ai-assisted-software-development.md) — AI在开发中的具体应用
- [10 AI安全合规与伦理](./06-ai-safety-compliance.md) — 生产环境的合规要求
