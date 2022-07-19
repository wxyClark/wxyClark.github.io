# Bug

```tip
* 修复 bug 最好的方式是能够重现 bug，
* 然后把你的修复替换进去 ——> 重新运行你的程序 ——> 观察 ——> 直到 bug 不再出现。
* 尽可能早的开始测试，尤其是感觉到到代码复杂的时候
```

    减少 bug 的第一步，是提升自己的程序员素养，努力不给自己和别人找麻烦。
    
- 认真分析需求
- 认真评审技术方案
- 设计简单的逻辑
- 风格统一的实现
- 多自测！及时测试！早发现早处理
- 不过度设计，支持扩展但不需要提前实现

## 正确认识Bug
    Q: 能不能写出没有bug的代码
    A: 很难

    Q: 怎样减少代码中的bug
    A: 先设计好方案，再开始写代码；及时测试(function维度)；及时review(接口维度)；提交前再次测试、review

    Q: 好的建议
    A: 做好封装，不要重复造轮子；
        遵循开闭原则，减少额外的测试任务；
        保持设计刚好满足需求，不过度设计
        提升代码可读性，降低bug排查难度

    Q：原则
    A：DRY不做重复的事(Don't Repeat Yourself);
        KISS保持简单直接(Keep it Simple Stupid);
        你不需要它(You Ain’t Gonna Need It)。

    Q: 多分支语句处理、多条件判定的分支语句怎么优化
    A: 提前return 较少缩进层级

## 常见bug
    变量：没有考虑到边界值：0，是否有负值，最大值，最小值
    函数：入参校验；是否有死循环，递归返回结果是否合理；执行耗时；分值条件是否完整
    缓存：缓存一致性(统一修改入口)；缓存击穿问题(加分布式锁修改)；缓存雪崩(过期时间+随机值)

## 工具推荐
[Travis CI](https://travis-ci.org/) 是一个广泛使用的CI工具，它简直是Github爱好者的福音，而且用户份额很大。

其支持绝大部分主流编程语言，包括但不限于：C、Java、Python、PHP等等。
<hr >
[Jenkins](https://jenkins.io/) 是一款开源的 CI&CD 工具，工具本身是Java写的，

却支持各种编程语言项目的自动化任务，包括构建、测试、部署等。

## 调试bug
    打日志
    二分定位
    测试用例
    