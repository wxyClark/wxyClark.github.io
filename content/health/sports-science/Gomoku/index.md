---
title: 五子棋知识库
description: 五子棋系统学习指南 — 8个主题，从入门到精通
---

# 五子棋知识库

> 从零基础到进阶，系统化学习五子棋的完整路径。

---

## 📚 知识体系总览

```mermaid
graph TB
    subgraph 入门阶段
        I1[01-beginner-guide<br/>规则禁手]
        I2[02-basic-techniques<br/>攻防手法]
    end
    
    subgraph 基础阶段
        B1[03-opening-patterns<br/>26种开局]
        B2[05-forbidden-rules<br/>三三/四四/长连]
    end
    
    subgraph 进阶阶段
        A1[04-midgame-tactics<br/>VCF/VCT]
        A2[06-practical-experience<br/>经验总结]
    end
    
    subgraph 高级阶段
        H1[07-thinking-methods<br/>计算判断]
        H2[08-learning-methods<br/>科学规划]
    end
    
    I1 & I2 --> B1 & B2
    B1 & B2 --> A1 & A2
    A1 & A2 --> H1 & H2
    
    style I1 fill:#fff3e0
    style B1 fill:#e3f2fd
    style A1 fill:#e8f5e9
    style H1 fill:#f3e5f5
```

---

## 🎯 五子棋 vs 围棋 对比

```mermaid
flowchart LR
    subgraph 围棋 Go
        G1[19×19棋盘]
        G2[围地取胜]
        G3[无禁手]
        G4[变化无穷]
    end
    
    subgraph 五子棋 Gomoku
        M1[15×15棋盘]
        M2[五子连珠]
        M3[黑棋有禁手]
        M4[更易入门]
    end
    
    style G1 fill:#ffebee
    style M1 fill:#e3f2fd
```

---

## 📖 各主题概览

| 序号 | 主题 | 核心内容 | 文档 |
|------|------|----------|------|
| 1 | 新手入门 | 15路棋盘、规则、禁手概念 | [01-beginner-guide.md](01-beginner-guide.md) |
| 2 | 基础技巧 | 活三冲四、四三胜、防守 | [02-basic-techniques.md](02-basic-techniques.md) |
| 3 | 开局定式 | 26种开局、云月浦月详解 | [03-opening-patterns.md](03-opening-patterns.md) |
| 4 | 中盘战术 | VCF/VCT、一子双杀 | [04-midgame-tactics.md](04-midgame-tactics.md) |
| 5 | 禁手规则 | 三三/四四/长连禁手详解 | [05-forbidden-rules.md](05-forbidden-rules.md) |
| 6 | 实战经验 | 开中收官经验、心态 | [06-practical-experience.md](06-practical-experience.md) |
| 7 | 思维方式 | 计算、判断、攻防思维 | [07-thinking-methods.md](07-thinking-methods.md) |
| 8 | 学习方法 | 分阶段学习路径规划 | [08-learning-methods.md](08-learning-methods.md) |

---

## 🎓 核心技能关系图

```mermaid
graph TB
    subgraph 基本功
        B1[识别棋形<br/>活三/冲四]
        B2[计算能力<br/>3-5步]
        B3[禁手意识<br/>避免判负]
    end
    
    subgraph 进攻技术
        T1[四三胜<br/>核心胜法]
        T2[VCF<br/>连续冲四]
        T3[VCT<br/>连续做杀]
    end
    
    subgraph 防守技术
        D1[活三防守<br/>堵哪端]
        D2[冲四防守<br/>必须挡]
        D3[反杀机会<br/>攻中带防]
    end
    
    subgraph 高级思维
        H1[禁手陷阱<br/>诱导对方]
        H2[一子双杀<br/>同时两威胁]
        H3[全局判断<br/>优劣评估]
    end
    
    B1 & B2 & B3 --> T1 & T2 & T3
    B1 & B2 & B3 --> D1 & D2 & D3
    T1 & T2 & T3 & D1 & D2 & D3 --> H1 & H2 & H3
    
    style B1 fill:#fff3e0
    style T1 fill:#e3f2fd
    style D1 fill:#e8f5e9
    style H1 fill:#f3e5f5
```

---

## 📊 学习进度图

```mermaid
xychart
    title "五子棋学习进度"
    x-axis [入门, 基础, 进阶, 提高, 精通]
    y-axis "掌握程度" 0 --> 100
    bar [15, 40, 65, 85, 95]
    line [10, 30, 55, 75, 90]
```

| 阶段 | 目标 | 关键指标 |
|------|------|----------|
| 入门 (0-15级) | 掌握规则，能完整对局 | 不犯禁手错误 |
| 基础 (15-25级) | 理解定式，会四三胜 | 能识别基本杀法 |
| 进阶 (25-35级) | 掌握VCF/VCT | 能计算5-10步 |
| 提高 (35级+) | 形成个人风格 | 稳定的胜率 |

---

## 🔗 快速导航

### 按学习阶段
- **入门期**：[01-beginner-guide.md](01-beginner-guide.md) → [02-basic-techniques.md](02-basic-techniques.md)
- **基础期**：[03-opening-patterns.md](03-opening-patterns.md) → [05-forbidden-rules.md](05-forbidden-rules.md)
- **进阶期**：[04-midgame-tactics.md](04-midgame-tactics.md) → [06-practical-experience.md](06-practical-experience.md)
- **提高期**：[07-thinking-methods.md](07-thinking-methods.md) → [08-learning-methods.md](08-learning-methods.md)

### 按技能类型
- **规则知识**：[01-beginner-guide.md](01-beginner-guide.md)、[05-forbidden-rules.md](05-forbidden-rules.md)
- **基础技巧**：[02-basic-techniques.md](02-basic-techniques.md)
- **开局定式**：[03-opening-patterns.md](03-opening-patterns.md)
- **战术组合**：[04-midgame-tactics.md](04-midgame-tactics.md)
- **实战应用**：[06-practical-experience.md](06-practical-experience.md)
- **思维方法**：[07-thinking-methods.md](07-thinking-methods.md)、[08-learning-methods.md](08-learning-methods.md)

---

## 🌟 学习建议

```mermaid
flowchart TD
    subgraph 每日训练
        D1[死活题5道]
        D2[VCF练习5道]
        D3[下一盘棋]
    end
    
    subgraph 每周目标
        W1[学习一个新开局]
        W2[复盘3盘棋]
        W3[研究名局1局]
    end
    
    subgraph 每月检查
        M1[棋力测试]
        M2[禁手错误统计]
        M3[调整学习重点]
    end
    
    D1 & D2 & D3 --> W1 & W2 & W3
    W1 & W2 & W3 --> M1 & M2 & M3
    
    style D1 fill:#ffebee
    style W1 fill:#e3f2fd
    style M1 fill:#e8f5e9
```

---

**返回首页**：[体育科学](../index.md)