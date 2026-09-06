---
title: 计算机科学知识体系
description: 从计算理论出发，构建计算机科学的完整知识体系
---

# 计算机科学知识体系

> **第一性原理**：计算机科学是研究信息和计算的学科，核心问题是"什么可以被计算"和"如何高效计算"。

---

## 📚 计算机科学的公理体系

```mermaid
graph TB
    subgraph 基本假设
        A1[图灵机模型<br/>可计算性定义]
        A2[程序 = 算法 + 数据结构]
        A3[信息可编码传输]
        A4[抽象解决复杂性]
    end
    
    subgraph 核心理论
        B1[计算理论]
        B2[算法理论]
        B3[复杂度理论]
    end
    
    subgraph 工程基础
        C1[计算机组成]
        C2[操作系统]
        C3[计算机网络]
    end
    
    A1 & A2 & A3 & A4 --> B1 & B2 & B3
    B1 & B2 & B3 --> C1 & C2 & C3
    
    style A1 fill:#ffebee
    style B1 fill:#e3f2fd
    style C1 fill:#e8f5e9
```

---

## 一、离散数学 Discrete Mathematics

```mermaid
flowchart TD
    subgraph 集合论
        S1[集合运算]
        S2[关系与函数]
    end
    
    subgraph 图论
        G1[图的基本概念]
        G2[树与遍历]
        G3[最短路径]
    end
    
    subgraph 数理逻辑
        L1[命题逻辑]
        L2[谓词逻辑]
    end
    
    S1 & S2 --> CS
    G1 & G2 & G3 --> DS
    L1 & L2 --> PROG
    
    style S1 fill:#ffebee
    style G1 fill:#e3f2fd
    style L1 fill:#e8f5e9
```

---

## 二、数据结构 Data Structures

```mermaid
flowchart LR
    subgraph 线性结构
        A[数组]
        L[链表]
        St[栈 LIFO]
        Q[队列 FIFO]
    end
    
    subgraph 树形结构
        T1[二叉树]
        T2[BST]
        T3[AVL/红黑树]
        T4[堆]
    end
    
    subgraph 图结构
        G1[邻接矩阵]
        G2[邻接表]
    end
    
    A & L & St & Q --> 查找排序
    T1 & T2 & T3 & T4 --> 查找排序
    G1 & G2 --> 图算法
    
    style A fill:#fff3e0
    style T1 fill:#e3f2fd
    style G1 fill:#e8f5e9
```

---

## 三、算法 Algorithm

### 排序算法对比

```mermaid
flowchart LR
    B1[冒泡 O(n²)] --> B2[选择 O(n²)]
    B2 --> B3[插入 O(n²)]
    B3 --> B4[快速 O(nlogn)]
    B4 --> B5[归并 O(nlogn)]
    B5 --> B6[堆排 O(nlogn)]
    
    style B1 fill:#ffebee
    style B4 fill:#fff3e0
    style B6 fill:#e8f5e9
```

### 算法设计策略

```mermaid
flowchart TD
    subgraph 分治法
        D1[分解]
        D2[解决]
        D3[合并]
    end
    
    subgraph 动态规划
        DP1[重叠子问题]
        DP2[最优子结构]
    end
    
    subgraph 贪心算法
        G1[局部最优]
        G2[全局最优]
    end
    
    subgraph 回溯法
        BT1[深度优先]
        BT2[剪枝]
    end
    
    D1 & D2 & D3 --> 适用场景
    DP1 & DP2 --> 适用场景
    G1 & G2 --> 适用场景
    BT1 & BT2 --> 适用场景
    
    style D1 fill:#ffebee
    style DP1 fill:#e3f2fd
    style G1 fill:#e8f5e9
    style BT1 fill:#fce4ec
```

---

## 四、计算机组成 Computer Organization

```mermaid
flowchart TB
    subgraph CPU
        CU[控制器]
        ALU[运算器]
        Reg[寄存器]
    end
    
    subgraph 存储层次
        L1[寄存器<br/>最快最小]
        L2[Cache]
        L3[主存]
        L4[磁盘<br/>最慢最大]
    end
    
    subgraph 输入输出
        IO[输入设备]
        OU[输出设备]
    end
    
    CU & ALU & Reg --> 指令执行
    L1 & L2 & L3 & L4 --> 存储层次
    IO & OU --> 数据交换
    
    style L1 fill:#fff3e0
    style L2 fill:#e3f2fd
    style L3 fill:#e8f5e9
    style L4 fill:#fce4ec
```

---

## 五、操作系统 Operating System

```mermaid
flowchart TD
    subgraph 进程管理
        P1[进程状态<br/>就绪→运行→阻塞]
        P2[线程模型]
    end
    
    subgraph 内存管理
        M1[分页]
        M2[分段]
        M3[虚拟内存]
    end
    
    subgraph 文件系统
        F1[文件组织]
        F2[目录结构]
    end
    
    subgraph 死锁
        D1[产生条件]
        D2[预防/避免/检测]
    end
    
    style P1 fill:#ffebee
    style M1 fill:#e3f2fd
    style F1 fill:#e8f5e9
    style D1 fill:#fce4ec
```

---

## 六、计算机网络 Computer Network

### OSI七层模型

```mermaid
flowchart TD
    L7[应用层<br/>HTTP/FTP/SMTP]
    L6[表示层<br/>SSL/JPEG]
    L5[会话层<br/>RPC]
    L4[传输层<br/>TCP/UDP]
    L3[网络层<br/>IP/ICMP]
    L2[数据链路层<br/>Ethernet]
    L1[物理层<br/>USB/光纤]
    
    L7 --> L6 --> L5 --> L4 --> L3 --> L2 --> L1
    
    style L7 fill:#ffebee
    style L4 fill:#e3f2fd
    style L3 fill:#e8f5e9
    style L1 fill:#fce4ec
```

### TCP vs UDP

```mermaid
flowchart LR
    subgraph TCP
        T1[面向连接]
        T2[可靠传输]
        T3[流量控制]
    end
    
    subgraph UDP
        U1[无连接]
        U2[不可靠]
        U3[低延迟]
    end
    
    style T1 fill:#e8f5e9
    style U1 fill:#ffebee
```

---

## 七、计算理论 Theory of Computation

```mermaid
flowchart TD
    subgraph 自动机层次
        TM[图灵机<br/>可识别所有可计算问题]
        PDA[下推自动机<br/>上下文无关语言]
        FA[有限自动机<br/>正则语言]
    end
    
    subgraph 可计算性
        C1[丘奇-图灵论题<br/>任何可计算=图灵机可计算]
        C2[停机问题不可判定]
    end
    
    subgraph 复杂度
        CP[P类<br/>多项式时间可解]
        CN[NP类<br/>多项式时间可验证]
        CNP[NP完全<br/>NP最难问题]
    end
    
    TM --> C1 & C2
    C2 --> CNP
    CP & CN & CNP --> 算法设计
    
    style TM fill:#ffebee
    style C2 fill:#fff3e0
    style CNP fill:#e3f2fd
```

---

## 八、计算机科学思维方式

```mermaid
mindmap
  root((计算思维))
    抽象思维
      忽略细节
      关注本质
    分解思维
      大问题变小问题
      模块化设计
    算法思维
      步骤化解决问题
      效率优化
    系统思维
      组件关系
      整体行为
```

---

## 📖 学习路径

```mermaid
flowchart TD
    A[编程基础<br/>Python/C] --> B[离散数学<br/>逻辑与集合]
    B --> C[数据结构<br/>线性结构]
    C --> D[算法设计<br/>排序与搜索]
    D --> E[计算机组成<br/>硬件基础]
    E --> F[操作系统<br/>系统软件]
    F --> G[计算机网络<br/>网络通信]
    G --> H[专业方向<br/>AI/安全/...]]
    
    style A fill:#fff3e0
    style B fill:#e3f2fd
    style D fill:#e8f5e9
    style H fill:#f3e5f5
```

---

## 参考文献

1. 《算法导论》- CLRS
2. 《计算机程序的构造和解释》- SICP
3. 《深入理解计算机系统》- CSAPP
4. 《自动机理论、语言和计算》