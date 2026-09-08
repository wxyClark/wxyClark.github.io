---
title: 围棋知识库
description: 围棋系统学习指南 — 9个主题，从入门到精通
---

# 围棋知识库

> 从零基础到进阶，系统化学习围棋的完整路径。

---

## 📚 知识体系总览

```mermaid
graph TB
    subgraph 入门阶段
        I1[01-beginner-guide<br/>棋盘规则术语]
        I2[02-basic-techniques<br/>吃子连接]
    end
    
    subgraph 基础阶段
        B1[03-standard-patterns<br/>常见定式]
        B2[05-life-death-training<br/>计算力]
    end
    
    subgraph 进阶阶段
        A1[04-midgame-fighting<br/>攻防技巧]
        A2[06-endgame-techniques<br/>精进球后]
        A3[07-practical-experience<br/>经验总结]
    end
    
    subgraph 高级阶段
        H1[08-thinking-methods<br/>全局思维]
        H2[09-learning-methods<br/>科学规划]
    end
    
    I1 & I2 --> B1 & B2
    B1 & B2 --> A1 & A2 & A3
    A1 & A2 & A3 --> H1 & H2
    
    style I1 fill:#fff3e0
    style B1 fill:#e3f2fd
    style A1 fill:#e8f5e9
    style H1 fill:#f3e5f5
```

---

## 🎯 学习路径图

```mermaid
flowchart LR
    subgraph 第1-2周
        L1[认识棋盘] --> L2[掌握规则]
    end
    
    subgraph 第3-4周
        L3[学习吃子] --> L4[练习连接]
    end
    
    subgraph 第1-2月
        L5[定式入门] --> L6[死活题训练]
    end
    
    subgraph 第3-6月
        L7[中盘战斗] --> L8[实战经验]
    end
    
    subgraph 持续学习
        L9[思维方式] --> L10[学习方法]
    end
    
    L1 & L2 --> L3 & L4
    L3 & L4 --> L5 & L6
    L5 & L6 --> L7 & L8
    L7 & L8 --> L9 & L10
    
    style L1 fill:#ffebee
    style L5 fill:#e3f2fd
    style L7 fill:#e8f5e9
    style L9 fill:#f3e5f5
```

---

## 📖 各主题概览

| 序号 | 主题 | 核心内容 | 文档 |
|------|------|----------|------|
| 1 | 新手入门 | 棋盘、规则、术语、第一局棋 | [01-beginner-guide.md](01-beginner-guide.md) |
| 2 | 基础技巧 | 5种吃子方法、4种连接技巧 | [02-basic-techniques.md](02-basic-techniques.md) |
| 3 | 定式入门 | 3个必学定式、布局原则 | [03-standard-patterns.md](03-standard-patterns.md) |
| 4 | 中盘战斗 | 攻击防守技巧、决策树 | [04-midgame-fighting.md](04-midgame-fighting.md) |
| 5 | 死活题训练 | 基本眼形、经典题型 | [05-life-death-training.md](05-life-death-training.md) |
| 6 | 官子技巧 | 官子计算、优先级 | [06-endgame-techniques.md](06-endgame-techniques.md) |
| 7 | 实战经验 | 开中收官经验、心态管理 | [07-practical-experience.md](07-practical-experience.md) |
| 8 | 思维方式 | 计算、判断、全局思维 | [08-thinking-methods.md](08-thinking-methods.md) |
| 9 | 学习方法 | 分阶段学习路径规划 | [09-learning-methods.md](09-learning-methods.md) |

---

## 🎓 核心概念关系图

```mermaid
graph TB
    subgraph 基础能力
        B1[数气能力]
        B2[吃子技巧]
        B3[连接技巧]
    end
    
    subgraph 战术能力
        T1[定式掌握]
        T2[死活识别]
        T3[攻防转换]
    end
    
    subgraph 战略能力
        S1[形势判断]
        S2[全局思维]
        S3[取舍决策]
    end
    
    subgraph 高手素质
        E1[丰富经验]
        E2[稳定心态]
        E3[持续学习]
    end
    
    B1 & B2 & B3 --> T1 & T2 & T3
    T1 & T2 & T3 --> S1 & S2 & S3
    S1 & S2 & S3 --> E1 & E2 & E3
    
    style B1 fill:#fff3e0
    style T1 fill:#e3f2fd
    style S1 fill:#e8f5e9
    style E1 fill:#f3e5f5
```

---

## 📊 棋力等级与对应技能

```mermaid
xychart
    title "围棋技能成长曲线"
    x-axis [入门, 初级, 中级, 高级, 专业]
    y-axis "能力水平" 0 --> 100
    bar [10, 30, 55, 75, 90]
    line [5, 15, 35, 60, 85]
```

| 等级 | 描述 | 关键技能 |
|------|------|----------|
| 入门 (10级+) | 能完整下完一局 | 规则、数气、吃子 |
| 初级 (10-20级) | 理解基本概念 | 定式、死活基础 |
| 中级 (20-30级) | 初步棋感 | 中盘战斗、形势判断 |
| 高级 (30级+) | 系统提升 | 全局思维、官子精确 |
| 专业 | 形成风格 | 创新能力、理论深度 |

---

## 🔗 快速导航

### 按学习阶段
- **入门期**：[01-beginner-guide.md](01-beginner-guide.md) → [02-basic-techniques.md](02-basic-techniques.md)
- **基础期**：[03-standard-patterns.md](03-standard-patterns.md) → [05-life-death-training.md](05-life-death-training.md)
- **进阶期**：[04-midgame-fighting.md](04-midgame-fighting.md) → [06-endgame-techniques.md](06-endgame-techniques.md) → [07-practical-experience.md](07-practical-experience.md)
- **提高期**：[08-thinking-methods.md](08-thinking-methods.md) → [09-learning-methods.md](09-learning-methods.md)

### 按技能类型
- **基础知识**：[01-beginner-guide.md](01-beginner-guide.md)、[02-basic-techniques.md](02-basic-techniques.md)
- **定式战术**：[03-standard-patterns.md](03-standard-patterns.md)、[04-midgame-fighting.md](04-midgame-fighting.md)
- **计算训练**：[05-life-death-training.md](05-life-death-training.md)
- **收官技巧**：[06-endgame-techniques.md](06-endgame-techniques.md)
- **经验思维**：[07-practical-experience.md](07-practical-experience.md)、[08-thinking-methods.md](08-thinking-methods.md)
- **学习规划**：[09-learning-methods.md](09-learning-methods.md)

---

## 🌟 学习建议

```mermaid
flowchart TD
    subgraph 每日必做
        D1[死活题5-10道]
        D2[下一盘棋]
        D3[复盘分析]
    end
    
    subgraph 每周目标
        W1[学习新定式]
        W2[研究名局]
        W3[总结错题]
    end
    
    subgraph 每月检查
        M1[棋力测试]
        M2[薄弱环节分析]
        M3[调整学习计划]
    end
    
    D1 & D2 & D3 --> W1 & W2 & W3
    W1 & W2 & W3 --> M1 & M2 & M3
    
    style D1 fill:#ffebee
    style W1 fill:#e3f2fd
    style M1 fill:#e8f5e9
```

---

**返回首页**：[体育科学](../index.md)