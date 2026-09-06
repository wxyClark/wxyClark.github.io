---
title: 物理学知识体系
description: 从第一性原理出发，构建完整的物理学知识体系
---

# 物理学知识体系

> **第一性原理**：物理学是从最基本的自然规律出发，理解物质、能量、空间和时间的学科。

---

## 📚 物理学的公理体系

```mermaid
graph TB
    subgraph 基本假设
        A1[自然界遵循确定的规律]
        A2[规律可用数学描述]
        A3[实验可验证理论]
        A4[简单原理解释复杂现象]
    end
    
    subgraph 核心概念
        B1[物质与能量]
        B2[时间与空间]
        B3[力与相互作用]
        B4[对称性与守恒律]
    end
    
    subgraph 四大守恒
        C1[能量守恒]
        C2[动量守恒]
        C3[角动量守恒]
        C4[电荷守恒]
    end
    
    A1 & A2 & A3 & A4 --> B1 & B2 & B3 & B4
    B4 --> C1 & C2 & C3 & C4
    
    style A1 fill:#ffebee
    style B1 fill:#e3f2fd
    style C1 fill:#e8f5e9
```

---

## 一、力学 Mechanics

### 牛顿三大定律

```mermaid
flowchart LR
    L1[第一定律<br/>惯性定律<br/>F=0 → v=const] --> L2[第二定律<br/>F=ma<br/>力的定量描述]
    L2 --> L3[第三定律<br/>作用反作用<br/>力的相互性]
    
    style L1 fill:#fff3e0
    style L2 fill:#e3f2fd
    style L3 fill:#e8f5e9
```

### 力学知识体系

```mermaid
graph TB
    subgraph 运动学
        K1[位移/速度/加速度]
        K2[匀速直线运动]
        K3[匀加速运动]
        K4[抛体运动]
    end
    
    subgraph 动力学
        D1[牛顿定律]
        D2[摩擦力]
        D3[圆周运动]
    end
    
    subgraph 能量与动量
        E1[功与能]
        E2[动能定理]
        E3[动量定理]
        E4[角动量]
    end
    
    subgraph 振动与波
        W1[简谐振动]
        W2[波动方程]
        W3[声波]
    end
    
    K1 & K2 & K3 & K4 --> D1
    D1 --> D2 & D3
    D1 & D2 & D3 --> E1
    E1 --> E2 & E3 & E4
    E3 --> W1 & W2
    
    style K1 fill:#fff3e0
    style D1 fill:#e3f2fd
    style E1 fill:#e8f5e9
    style W1 fill:#fce4ec
```

### 重要定理

| 定理 | 公式 | 意义 |
|------|------|------|
| 动能定理 | $W = \Delta E_k = \frac{1}{2}mv^2 - \frac{1}{2}mv_0^2$ | 功是能量转化的量度 |
| 动量定理 | $Ft = \Delta p = mv - mv_0$ | 冲量是动量变化的量度 |
| 万有引力 | $F = G\frac{m_1m_2}{r^2}$ | 解释天体运动 |
| 胡克定律 | $F = -kx$ | 弹性体的恢复力 |

---

## 二、热学 Thermodynamics

### 热力学四大定律

```mermaid
flowchart TD
    Z[第零定律<br/>温度定义<br/>热平衡传递性] --> T1[第一定律<br/>能量守恒<br/>ΔU = Q - W]
    T1 --> T2[第二定律<br/>熵增原理<br/>孤立系统熵永不减少]
    T2 --> T3[第三定律<br/>绝对零度<br/>不可达到]
    
    style Z fill:#ffebee
    style T1 fill:#fff3e0
    style T2 fill:#e8f5e9
    style T3 fill:#e3f2fd
```

### 核心概念关系

```mermaid
graph TB
    subgraph 宏观量
        M1[温度 T]
        M2[压强 P]
        M3[体积 V]
        M4[内能 U]
    end
    
    subgraph 微观解释
        micro[分子运动<br/>平均动能 ↔ 温度]
    end
    
    subgraph 热力学过程
        P1[等温过程 PV=const]
        P2[等容过程]
        P3[等压过程]
        P4[绝热过程 PV^γ=const]
    end
    
    M1 & M2 & M3 --> micro
    micro --> M4
    M1 & M2 & M3 --> P1 & P2 & P3 & P4
    
    style M1 fill:#ffebee
    style micro fill:#e3f2fd
```

---

## 三、电磁学 Electromagnetism

### 麦克斯韦方程组

```mermaid
quadrantChart
    title 电磁场统一理论
    x-axis "电场" --> "磁场"
    y-axis "静态" --> "动态"
    "静电学": [0.2, 0.3]
    "静磁学": [0.8, 0.3]
    "电磁感应": [0.8, 0.7]
    "电磁波": [0.9, 0.9]
```

### 电磁学核心方程

```
∇·E = ρ/ε₀        高斯定律（电荷产生电场）
∇·B = 0            磁高斯定律（无磁单极）
∇×E = -∂B/∂t     法拉第定律（变化磁场产生电场）
∇×B = μ₀J + μ₀ε₀∂E/∂t  安培-麦克斯韦定律
```

### 重要定律

| 定律 | 公式 | 意义 |
|------|------|------|
| 库仑定律 | $F = k\frac{q_1q_2}{r^2}$ | 电荷间相互作用 |
| 欧姆定律 | $V = IR$ | 电路基本关系 |
| 法拉第定律 | $\varepsilon = -\frac{d\Phi}{dt}$ | 电磁感应 |

---

## 四、光学 Optics

```mermaid
flowchart LR
    subgraph 几何光学
        G1[光的直线传播]
        G2[反射定律]
        G3[折射定律<br/>n₁sinθ₁=n₂sinθ₂]
    end
    
    subgraph 波动光学
        W1[干涉<br/>杨氏双缝]
        W2[衍射<br/>单缝/光栅]
        W3[偏振]
    end
    
    subgraph 量子光学
        Q1[光电效应]
        Q2[光子概念]
    end
    
    G1 & G2 & G3 --> W1 & W2 & W3
    W3 --> Q1 & Q2
    
    style G1 fill:#fff3e0
    style W1 fill:#e3f2fd
    style Q1 fill:#e8f5e9
```

---

## 五、近代物理 Modern Physics

### 相对论

```mermaid
flowchart TD
    subgraph 狭义相对论
        SR1[光速不变原理]
        SR2[相对性原理]
        SR1 & SR2 --> SR3["质能方程<br/>E = mc²"]
        SR3 --> SR4[时间膨胀]
        SR3 --> SR5[长度收缩]
    end
    
    subgraph 广义相对论
        GR1[等效原理]
        GR2[时空弯曲]
        GR1 & GR2 --> GR3[引力场方程]
    end
    
    style SR1 fill:#ffebee
    style GR1 fill:#e3f2fd
```

### 量子力学

```mermaid
graph TB
    subgraph 核心原理
        Q1[波粒二象性<br/>λ = h/p]
        Q2[不确定性原理<br/>Δx·Δp ≥ ℏ/2]
        Q3[薛定谔方程<br/>iℏ∂ψ/∂t = Ĥψ]
    end
    
    subgraph 应用领域
        A1[原子物理]
        A2[核物理]
        A3[凝聚态物理]
        A4[粒子物理]
    end
    
    Q1 & Q2 & Q3 --> A1 & A2 & A3 & A4
    
    style Q1 fill:#ffebee
    style Q2 fill:#fff3e0
    style Q3 fill:#e8f5e9
```

---

## 六、物理学思维方式

```mermaid
mindmap
  root((物理思维))
    模型思维
      简化现实
      抓住主要因素
      建立理想模型
    对称性思维
      寻找对称性
      推导守恒律
      简化计算
    量纲分析
      检查量纲一致性
      推导关系式
      估算数量级
    极限思维
      极端情况分析
      简化问题
      验证结果
    场的概念
      用场描述相互作用
      避免超距作用
      局域性原理
```

---

## 📖 学习路径

```mermaid
flowchart TD
    A[牛顿力学<br/>经典基础] --> B[电磁学<br/>麦克斯韦统一]
    B --> C[热力学与统计物理]
    C --> D[光学]
    D --> E[狭义相对论]
    E --> F[量子力学入门]
    F --> G[现代物理专题]
    
    style A fill:#fff3e0
    style B fill:#e3f2fd
    style F fill:#e8f5e9
    style G fill:#f3e5f5
```

---

## 参考文献

1. 《力学》- 朗道
2. 《电动力学》- 格里菲斯
3. 《热力学与统计物理》- 汪志诚
4. 《费曼物理学讲义》