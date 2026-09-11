---
title: 经济学知识体系
description: 从稀缺性出发，理解资源配置的逻辑
---

# 经济学知识体系

## 🗂️ 内容导航

| 名称 | 说明 | 链接 |
|------|------|------|
| 投资理财 | 理解投资原理与理财实战方法 | [进入](investment/index.md) |

---


> **第一性原理**：经济学是研究如何在资源稀缺的条件下做出选择，以实现最大满足的学科。

---

## 📚 经济学的公理体系

```mermaid
graph TB
    subgraph 基本假设
        A1["资源稀缺性<br/>欲望无限性"]
        A2["理性人假设<br/>效用最大化"]
        A3[信息不完全]
    end
    
    subgraph 核心概念
        B1[机会成本]
        B2[边际分析]
        B3[均衡分析]
    end
    
    subgraph 基本定律
        C1[供求定律]
        C2[边际效用递减]
        C3[比较优势]
    end
    
    A1 & A2 & A3 --> B1 & B2 & B3
    B1 & B2 & B3 --> C1 & C2 & C3
    
    style A1 fill:#ffebee
    style B1 fill:#e3f2fd
    style C1 fill:#e8f5e9
```

---

## 一、微观经济学 Microeconomics

### 供需模型

```mermaid
flowchart LR
    D["需求定律<br/>价格↑ 需求量↓"] --> E["市场均衡<br/>Qd = Qs"]
    S["供给定律<br/>价格↑ 供给量↑"] --> E
    
    style D fill:#fff3e0
    style S fill:#e3f2fd
    style E fill:#e8f5e9
```

### 消费者行为

```mermaid
flowchart TD
    subgraph 效用理论
        U1[总效用 TU]
        U2["边际效用 MU<br/>MU = ΔTU/ΔQ"]
    end
    
    subgraph 消费者均衡
        C1["预算约束<br/>P₁X₁ + P₂X₂ = I"]
        C2["均衡条件<br/>MU₁/P₁ = MU₂/P₂"]
    end
    
    U1 & U2 --> C1 & C2
    
    style U1 fill:#ffebee
    style C2 fill:#e8f5e9
```

### 生产者理论

```mermaid
flowchart TD
    subgraph 生产函数
        P1["Q = fL, K"]
        P2["边际产量 MP<br/>MP = ΔQ/ΔL"]
    end
    
    subgraph 成本理论
        C1[总成本 TC]
        C2["边际成本 MC<br/>MC = ΔTC/ΔQ"]
        C3[平均成本 AC]
    end
    
    subgraph 利润最大化
        H1["条件：MR = MC"]
    end
    
    P1 & P2 --> C1 & C2 & C3
    C1 & C2 & C3 --> H1
    
    style P1 fill:#fff3e0
    style C2 fill:#e3f2fd
    style H1 fill:#e8f5e9
```

### 市场结构

```mermaid
flowchart LR
    M1["完全竞争<br/>无数买家卖家<br/>同质产品"] --> M2["垄断竞争<br/>较多卖家<br/>产品有差异"]
    M2 --> M3["寡头垄断<br/>少数卖家<br/>相互依赖"]
    M3 --> M4["完全垄断<br/>唯一卖家<br/>无替代品"]
    
    style M1 fill:#e8f5e9
    style M2 fill:#fff3e0
    style M3 fill:#e3f2fd
    style M4 fill:#ffebee
```

---

## 二、宏观经济学 Macroeconomics

### GDP核算

```mermaid
flowchart TD
    G["GDP = C + I + G + X - M"]
    
    subgraph 组成部分
        C[消费 Consumption]
        I[投资 Investment]
        G[政府购买 Government]
        NX[净出口 Net Exports]
    end
    
    G --> C & I & G & NX
    
    style G fill:#ffebee
    style C fill:#fff3e0
    style I fill:#e3f2fd
    style NX fill:#e8f5e9
```

### 总需求-总供给模型

```mermaid
flowchart LR
    subgraph 总需求 AD
        A1[价格↑ → 需求↓]
        A2[向下倾斜]
    end
    
    subgraph 总供给 AS
        S1[短期向上倾斜]
        S2[长期垂直]
    end
    
    A1 & A2 --> 均衡
    S1 & S2 --> 均衡
    
    style A1 fill:#ffebee
    style S1 fill:#e3f2fd
```

### 政策工具

```mermaid
flowchart TD
    subgraph 财政政策
        F1[税收 T]
        F2[政府支出 G]
    end
    
    subgraph 货币政策
        M1[利率 r]
        M2[货币供应 M]
        M3[存款准备金率]
    end
    
    F1 & F2 --> 影响总需求
    M1 & M2 & M3 --> 影响总需求
    
    style F1 fill:#fff3e0
    style M1 fill:#e3f2fd
```

---

## 三、经济学思维方式

```mermaid
mindmap
  root((经济思维))
    边际思维
      考虑边际量
      MR = MC 决策
    机会成本
      选择的代价
      放弃的最佳替代
    激励思维
      人对激励反应
      政策设计考虑激励
    均衡思维
      市场趋向均衡
      供需决定价格
    系统思维
      宏观与微观联系
      一般均衡分析
```

---

## 四、重要经济定律

```mermaid
flowchart LR
    L1["恩格尔定律<br/>收入↑ 食品支出占比↓"]
    L2["奥肯法则<br/>失业↑ GDP增长↓"]
    L3["菲利普斯曲线<br/>失业与通胀负相关"]
    L4["比较优势<br/>各国专注优势产品"]
    
    style L1 fill:#ffebee
    style L2 fill:#fff3e0
    style L3 fill:#e3f2fd
    style L4 fill:#e8f5e9
```

---

## 📖 学习路径

```mermaid
flowchart TD
    A["经济学原理<br/>供需基础"] --> B["微观经济学<br/>消费者与生产者"]
    B --> C["宏观经济学<br/>GDP与政策"]
    C --> D["专业方向<br/>金融/财政/产业"]
    
    style A fill:#ffebee
    style B fill:#e3f2fd
    style C fill:#e8f5e9
    style D fill:#f3e5f5
```

---

## 参考文献

1. 《经济学原理》- 曼昆
2. 《微观经济学》- 平狄克
3. 《宏观经济学》- 曼昆
4. 《国富论》- 亚当·斯密