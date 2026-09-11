---
title: 心理学知识体系
description: 从认知过程出发，理解人类心理与行为
---

# 心理学知识体系

> **第一性原理**：心理学是研究心理活动和行为规律的科学。所有心理现象都有生物学基础和社会文化根源。

---

## 📚 心理学的公理体系

```mermaid
graph TB
    subgraph 基本假设
        A1[心理是脑的机能]
        A2[心理是客观现实的反映]
        A3[心理具有主观能动性]
        A4[遗传与环境共同作用]
    end
    
    subgraph 研究方法
        B1[实验法]
        B2[观察法]
        B3[调查法]
        B4[测验法]
    end
    
    A1 & A2 & A3 & A4 --> B1 & B2 & B3 & B4
    
    style A1 fill:#ffebee
    style B1 fill:#e3f2fd
```

---

## 一、基础心理学 Basic Psychology

### 感觉与知觉

```mermaid
flowchart TD
    subgraph 感觉
        S1["视觉<br/>光波→视网膜"]
        S2["听觉<br/>声波→耳蜗"]
        S3[触觉]
        S4[味觉]
        S5[嗅觉]
    end
    
    subgraph 知觉组织原则
        P1["接近律<br/>相近归为一组"]
        P2["相似律<br/>相似归为一组"]
        P3["连续律<br/>连续归为一组"]
        P4["闭合律<br/>不完整被补全"]
    end
    
    S1 & S2 & S3 & S4 & S5 --> P1 & P2 & P3 & P4
    
    style S1 fill:#ffebee
    style P1 fill:#e3f2fd
```

### 记忆系统

```mermaid
flowchart LR
    subgraph 感觉记忆
        SM["<1秒<br/>形象登记"]
    end
    
    subgraph 短时记忆
        SMem["<30秒<br/>7±2个组块"]
    end
    
    subgraph 长时记忆
        LM["永久<br/>语义网络"]
    end
    
    SM -->|注意| SMem
    SMem -->|复述| LM
    
    style SM fill:#ffebee
    style SMem fill:#fff3e0
    style LM fill:#e8f5e9
```

### 遗忘规律（艾宾浩斯）

```mermaid
flowchart TD
    T1["学习后1小时<br/>遗忘40%"] --> T2["1天后<br/>遗忘66%"]
    T2 --> T3["6天后<br/>遗忘75%"]
    T3 --> T4["31天后<br/>遗忘79%"]
    
    style T1 fill:#ffebee
    style T2 fill:#fff3e0
    style T3 fill:#e3f2fd
    style T4 fill:#e8f5e9
```

---

## 二、发展心理学 Developmental Psychology

### 皮亚杰认知发展阶段

```mermaid
flowchart LR
    S1["感知运动阶段<br/>0-2岁<br/>客体永久性"] --> S2["前运算阶段<br/>2-7岁<br/>自我中心"]
    S2 --> S3["具体运算阶段<br/>7-11岁<br/>守恒、可逆"]
    S3 --> S4["形式运算阶段<br/>11岁+<br/>抽象推理"]
    
    style S1 fill:#ffebee
    style S2 fill:#fff3e0
    style S3 fill:#e3f2fd
    style S4 fill:#e8f5e9
```

### 埃里克森心理社会发展阶段

```mermaid
flowchart TD
    subgraph 儿童期
        P1["信任vs不信任<br/>0-1岁"]
        P2["自主vs羞怯<br/>1-3岁"]
        P3["主动vs内疚<br/>3-6岁"]
        P4["勤奋vs自卑<br/>6-12岁"]
    end
    
    subgraph 成年期
        A1["同一性vs角色混乱<br/>12-18岁"]
        A2["亲密vs孤独<br/>18-40岁"]
        A3["繁衍vs停滞<br/>40-65岁"]
        A4["完善vs绝望<br/>65岁+"]
    end
    
    P1 --> P2 --> P3 --> P4 --> A1 --> A2 --> A3 --> A4
    
    style P1 fill:#ffebee
    style A1 fill:#e3f2fd
    style A4 fill:#e8f5e9
```

---

## 三、社会心理学 Social Psychology

### 社会认知

```mermaid
flowchart TD
    subgraph 归因理论
        A1["内部归因<br/>性格、能力"]
        A2["外部归因<br/>环境、运气"]
    end
    
    subgraph 认知偏差
        B1["基本归因错误<br/>高估内部因素"]
        B2["自利偏差<br/>成功归内、失败归外"]
    end
    
    A1 & A2 --> B1 & B2
    
    style A1 fill:#ffebee
    style B1 fill:#fff3e0
```

### 从众与服从

```mermaid
flowchart LR
    subgraph 从众
        C1["信息性影响<br/>不确定时参考他人"]
        C2["规范性影响<br/>希望被接纳"]
    end
    
    subgraph 服从
        O1["米尔格拉姆实验<br/>权威导致服从"]
        O2["斯坦福监狱实验<br/>角色导致行为改变"]
    end
    
    C1 & C2 --> 社会影响
    O1 & O2 --> 社会影响
    
    style C1 fill:#ffebee
    style O1 fill:#e3f2fd
```

### 态度与认知失调

```mermaid
flowchart TD
    subgraph 态度成分
        T1["认知成分<br/>信念"]
        T2["情感成分<br/>情绪"]
        T3["行为成分<br/>倾向"]
    end
    
    subgraph 认知失调
        D1["认知不一致<br/>产生心理不适"]
        D2["改变态度或行为<br/>恢复一致"]
    end
    
    T1 & T2 & T3 --> D1 --> D2
    
    style T1 fill:#fff3e0
    style D1 fill:#ffebee
```

---

## 四、临床心理学 Clinical Psychology

### 心理障碍分类

```mermaid
flowchart LR
    D1["焦虑障碍<br/>过度担忧、惊恐"] --> D2["抑郁障碍<br/>持续低落"]
    D2 --> D3["人格障碍<br/>持久行为异常"]
    D3 --> D4["精神病性障碍<br/>幻觉、妄想"]
    
    style D1 fill:#fff3e0
    style D2 fill:#ffebee
    style D3 fill:#e3f2fd
    style D4 fill:#e8f5e9
```

### 治疗方法

```mermaid
flowchart TD
    subgraph 心理治疗
        P1["认知行为疗法<br/>CBT"]
        P2[精神分析]
        P3[人本主义]
    end
    
    subgraph 药物治疗
        M1[抗抑郁药]
        M2[抗焦虑药]
        M3[抗精神病药]
    end
    
    P1 & P2 & P3 --> 综合治疗
    M1 & M2 & M3 --> 综合治疗
    
    style P1 fill:#e8f5e9
    style M1 fill:#e3f2fd
```

---

## 五、心理学思维方式

```mermaid
mindmap
  root((心理思维))
    生物-心理-社会
      生物因素
      心理因素
      社会因素
    实证思维
      观察与实验
      证据为基础
    发展思维
      生命周期视角
      阶段性特征
    个体差异
      尊重差异性
      因材施教
```

---

## 📖 学习路径

```mermaid
flowchart TD
    A["基础心理学<br/>感觉知觉记忆"] --> B["发展心理学<br/>认知发展"]
    B --> C["社会心理学<br/>人际互动"]
    C --> D["异常心理学<br/>心理障碍"]
    D --> E[心理学研究方法]
    
    style A fill:#ffebee
    style B fill:#e3f2fd
    style D fill:#e8f5e9
    style E fill:#f3e5f5
```

---

## 参考文献

1. 《心理学导论》- 津巴多
2. 《发展心理学》- 林崇德
3. 《社会心理学》- 阿伦森
4. 《普通心理学》- 彭聃龄