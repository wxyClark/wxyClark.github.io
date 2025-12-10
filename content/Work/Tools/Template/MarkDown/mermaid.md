---
sort: 4
---

# 结构图

[markdown 中流程图详解](https://blog.csdn.net/suoxd123/article/details/84992282)

[MarkDown绘图mermaid流程graph](https://www.jianshu.com/p/598b121bdbef)

[文档](https://www.wenjiangs.com/doc/markdown-markdownflowchart)

[web216安全色](http://www.h-ui.net/websafecolors.shtml)



## 文本


## 跨部门流程图
```mermaid

graph TB
    c1-->a2
    subgraph one
    a1-->a2
    end
    subgraph two
    b1-->b2
    end
    subgraph three
    c1-->c2
    end
```

## 流程图
```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```

## 符号

符号内部不能出现 **·**、**：**、**【】**、**{}**、**<>**、**[]**

```mermaid
    graph TB
        A[默认<br>矩形节点] 
        B(圆角矩形节点)
        C([圆边矩形<br>开始 结束])
        D[(圆柱形节点)]
        E((圆形节点))
        F>标签<br>旗帜]
        G{菱形<br>判定逻辑}
        H{{六边形<br>github不支持}}
        I[/平行四边形<br> 输出/]
        J[\平行四边形<br> 输入\]

        C --> B ---直线箭头长度可控---> A
        C -.-> D -.-虚线箭头-.-> E

        J ==加粗直线箭头===> H ===> I
```

## 类图
```mermaid
classDiagram
classA <|-- classB
classC *-- classD
classE o-- classF
classG <-- classH
classI -- classJ
classK <.. classL
classM <|.. classN
classO .. classP
```

## E-R图
```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    CUSTOMER }|..|{ DELIVERY-ADDRESS : uses
```

## 流程图

```mermaid
	graph TB
	A[Apple]-->B{Boy}
	A---C(Cat)
	B.->D((Dog))
	C==喵==>D
	style A fill:#2ff,fill-opacity:0.1,stroke:#faa,stroke-width:4px
	style D stroke:#000,stroke-width:8px;
```


## 时序图

```mermaid
    sequenceDiagram
    participant 张 as 张三
    participant 李 as 李四
    participant 王 as  王五   
    张 ->> +李: 你好！李四, 最近怎么样?
    李-->> 王: 你最近怎么样，王五？
    李--x -张: 我很好，谢谢!
    activate 王
    李-x 王: 我很好，谢谢!   
    Note over 李,王: 李四想了很长时间, 文字太长了<br/>不适合放在一行.
    deactivate 王
    loop 李四再想想
    李-->>王: 我还要想想
    王-->>李: 想想吧
    end
    李-->>张: 打量着王五...
    张->>王: 很好... 王五, 你怎么样?
```


## 消息流

```mermaid
    sequenceDiagram
    participant 张 as 张三
    participant 李 as 李四
    张 ->> 李: 你好！李四, 最近怎么样?
    alt 如果感冒了
    李->> 张: 不太好，生病了。
    else 挺好的
    李->> 张: 我很好，谢谢。
    end
        opt 另外补充
        李->> 张: 谢谢问候。
    end
```

## 甘特图

```mermaid
gantt  
    dateFormat  YYYY-MM-DD
    title 甘特图的标题
    excludes weekdays 2014-01-10

    section 任务A
    已完成的任务xxxA    :done,    des1, 2014-01-06,2014-01-08
    进行中yyyA1         :active,  des2, 2014-01-09, 2d
    进行中yyyA2         :         des3, after des2, 3d
    未启动zzzA           :         des4, after des3, 4d

    section 任务B
    已完成的任务xxxB      :done,    des1, 2014-01-07,2014-01-08
    进行中yyyB1           :active,  des2, 2014-01-09, 3d
    进行中yyyB2           :         des3, after des2, 5d
    未启动zzzB            :         des4, after des3, 5d
```