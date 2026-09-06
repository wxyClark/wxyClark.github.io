---
title: 哲学知识体系
description: 从第一性原理出发，探索存在的本质与知识的边界
---

# 哲学知识体系

> **第一性原理**：哲学是对最基本、最普遍问题的反思性追问，旨在寻求终极解释和根本原则。

---

## 📚 哲学的公理体系

```mermaid
graph TB
    subgraph 基本问题
        Q1[存在是什么? 本体论]
        Q2[我们如何知道? 认识论]
        Q3[我们应该怎么做? 伦理学]
        Q4[什么是美? 美学]
    end
    
    subgraph 方法
        M1[逻辑推理]
        M2[概念分析]
        M3[反思批判]
        M4[思想实验]
    end
    
    Q1 & Q2 & Q3 & Q4 --> M1 & M2 & M3 & M4
    
    style Q1 fill:#ffebee
    style M1 fill:#e3f2fd
```

---

## 一、本体论 Ontology

```mermaid
flowchart TD
    subgraph 基本立场
        M[唯物主义<br/>物质第一性]
        I[唯心主义<br/>精神第一性]
        D[二元论<br/>物质精神并列]
    end
    
    subgraph 主要理论
        A[原子论<br/>万物由原子构成]
        P[理念论<br/>现实模仿理念]
        B[辩证法<br/>矛盾推动发展]
    end
    
    M & I & D --> A & P & B
    
    style M fill:#e8f5e9
    style I fill:#ffebee
    style A fill:#fff3e0
```

---

## 二、认识论 Epistemology

### 知识来源之争

```mermaid
flowchart LR
    E[经验主义<br/>洛克、休谟<br/>知识来自感觉经验] --> K[知识论]
    R[理性主义<br/>笛卡尔、斯宾诺莎<br/>知识来自理性推理] --> K
    
    style E fill:#ffebee
    style R fill:#e3f2fd
```

### 真理理论

```mermaid
flowchart TD
    subgraph 主要理论
        T1[符合论<br/>命题与事实相符]
        T2[融贯论<br/>与信念系统一致]
        T3[实用论<br/>有用即真理]
    end
    
    style T1 fill:#ffebee
    style T2 fill:#fff3e0
    style T3 fill:#e8f5e9
```

### 康德批判哲学

```mermaid
flowchart LR
    subgraph 三大批判
        C1[纯粹理性批判<br/>我们能知道什么?]
        C2[实践理性批判<br/>我们应该做什么?]
        C3[判断力批判<br/>我们可以希望什么?]
    end
    
    C1 & C2 & C3 --> 哲学体系
    
    style C1 fill:#ffebee
    style C2 fill:#e3f2fd
    style C3 fill:#e8f5e9
```

---

## 三、伦理学 Ethics

### 三大流派

```mermaid
flowchart TD
    subgraph 功利主义
        U1[最大幸福原则]
        U2[边沁、密尔]
        U1 & U2 --> U3[后果决定对错]
    end
    
    subgraph 义务论
        K1[绝对命令]
        K2[康德]
        K1 & K2 --> K3[动机决定对错]
    end
    
    subgraph 德性伦理学
        V1[培养良好品格]
        V2[亚里士多德]
        V1 & V2 --> V3[品格决定对错]
    end
    
    U3 & K3 & V3 --> 伦理决策
    
    style U1 fill:#ffebee
    style K1 fill:#e3f2fd
    style V1 fill:#e8f5e9
```

### 康德的绝对命令

```
1. 普遍化原则：只按照你能愿意它成为普遍法则的准则行动。
2. 人性原则：永远把人当作目的，而不仅仅是手段。
3. 自律原则：理性存在者为自己立法。
```

---

## 四、逻辑学 Logic

### 形式逻辑

```mermaid
flowchart TD
    subgraph 三段论
        M1[大前提：所有人都会死]
        M2[小前提：苏格拉底是人]
        M3[结论：苏格拉底会死]
    end
    
    subgraph 基本规律
        L1[同一律 A→A]
        L2[矛盾律 ¬A∧A]
        L3[排中律 A∨¬A]
    end
    
    M1 & M2 & M3 --> L1 & L2 & L3
    
    style M1 fill:#fff3e0
    style L1 fill:#e8f5e9
```

### 常见谬误

```mermaid
flowchart LR
    F1[稻草人谬误<br/>歪曲对方观点]
    F2[人身攻击<br/>攻击person非argument]
    F3[诉诸权威<br/>因为专家说所以正确]
    F4[滑坡谬误<br/>小错导致大灾难]
    
    style F1 fill:#ffebee
    style F2 fill:#fff3e0
    style F3 fill:#e3f2fd
    style F4 fill:#fce4ec
```

---

## 五、美学 Aesthetics

```mermaid
flowchart TD
    subgraph 美的本质
        O[客观论<br/>美是对象属性]
        S[主观论<br/>美是主体感受]
        R[关系论<br/>美是主客关系]
    end
    
    subgraph 审美判断
        A1[无目的的合目的性]
        A2[无概念的普遍性]
        A3[无概念的必然性]
    end
    
    O & S & R --> A1 & A2 & A3
    
    style O fill:#ffebee
    style S fill:#fff3e0
    style A1 fill:#e8f5e9
```

---

## 六、哲学思维方式

```mermaid
mindmap
  root((哲学思维))
    批判性思维
      质疑既定观念
      反思前提假设
    概念分析
      澄清概念含义
      分析使用条件
    系统性思维
      理解关联整体
    反思性思维
      对自身信念追问
```

---

## 📖 学习路径

```mermaid
flowchart TD
    A[哲学导论<br/>基本问题] --> B[西方哲学史<br/>古希腊到现代]
    B --> C[中国哲学<br/>儒释道]
    C --> D[逻辑学<br/>论证方法]
    D --> E[伦理学<br/>价值判断]
    E --> F[认识论<br/>知识本质]
    
    style A fill:#ffebee
    style B fill:#e3f2fd
    style D fill:#e8f5e9
    style F fill:#f3e5f5
```

---

## 参考文献

1. 《西方哲学史》- 罗素
2. 《中国哲学简史》- 冯友兰
3. 《纯粹理性批判》- 康德
4. 《尼采文集》