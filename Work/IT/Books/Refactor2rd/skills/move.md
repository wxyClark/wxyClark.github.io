# 搬移特性


```tip
模块化是优秀软件设计的核心所在，好的模块化能够让我在修改程序时只需理解程序的一小部分。
```

## 搬移函数（Move Function）

| title | content |
| ---- | ---- |
| 场景 | 为了设计出高度模块化的程序，我得保证互相关联的软件要素都能集中到一块，并确保块与块之间的联系易于查找、直观易懂。<br>同时，我对模块设计的理解并不是一成不变的，随着我对代码的理解加深，我会知道那些软件要素如何组织最为恰当。<br>要将这种理解反映到代码上，就得不断地搬移这些元素。 |
| 定义 | 在该函数最常引用的类中建立一个有着类似行为的新函数。<br>将旧函数变成一个单纯的委托函数，或是将旧函数完全移除 |
| 意义 | 模块化是优秀软件设计的核心所在，好的模块化能够让我在修改程序时只需理解程序的一小部分。 |
| 做法 | 检查函数在当前上下文里引用的所有程序元素（包括变量和函数），考虑是否需要将它们一并搬移<br>如果发现有些被调用的函数也需要搬移，我通常会先搬移它们。这样可以保证移动一组函数时，总是从依赖最少的那个函数入手。<br>如果该函数拥有一些子函数，并且它是这些子函数的唯一调用者，那么你可以先将子函数内联进来，一并搬移到新家后再重新提炼出子函数。
<br><br>检查待搬移函数是否具备多态性。<br>在面向对象的语言里，还需要考虑该函数是否覆写了超类的函数，或者为子类所覆写。 |
| 注意 |  |


## 搬移字段（Move Field）

| title | content |
| ---- | ---- |
| 场景 | 程序中，某个字段被其所驻类之外的另一个类更多地用到。 |
| 定义 | 在目标类新建一个字段，修改源字段的所有用户，令它们改用新字段。 |
| 意义 | 内聚 |
| 做法 |  |
| 注意 |  |


## 搬移语句到函数（Move Statements into Function）

| title | content |
| ---- | ---- |
| 场景 |  |
| 意义 |  |
| 定义 |  |
| 做法 | 如果重复的代码段离调用目标函数的地方还有些距离，则先用【移动语句】将这些语句挪动到紧邻目标函数的位置。<br>  如果目标函数仅被唯一一个源函数调用，那么只需将源函数中的重复代码段剪切并粘贴到目标函数中即可，然后运行测试。本做法的后续步骤至此可以忽略。<br>  如果函数不止一个调用点，那么先选择其中一个调用点应用【提炼函数】，将待搬移的语句与目标函数一起提炼成一个新函数。给新函数取个临时的名字，只要易于搜索即可。<br>调整函数的其他调用点，令它们调用新提炼的函数。每次调整之后运行测试。<br>完成所有引用点的替换后，应用【内联函数】将目标函数内联到新函数里，并移除原目标函数。<br>对新函数应用【函数改名】，将其改名为原目标函数的名字。<br>如果你能想到更好的名字，那就用更好的那个。 |
| 注意 |  |


## 搬移语句到调用者（Move Statements to Callers）

```warning
作为程序员，我们的职责就是设计出结构一致、抽象合宜的程序，而程序抽象能力的源泉正是来自函数

我得思考这个问题：如果我把代码移动过去，执行次序的不同会不会使代码之间产生干扰，甚至于改变程序的可观测行为？
```

| title | content |
| ---- | ---- |
| 场景 | 如果有几行代码取用了同一个数据结构，那么最好是让它们在一起出现，而不是夹杂在取用其他数据结构的代码中间。<br>最简单的情况下，我只需使用移动语句就可以让它们聚集起来。<br>此外还有一种常见的“关联”，就是关于变量的声明和使用。 |
| 意义 |  |
| 定义 |  |
| 做法 |  |
| 注意 | 如果原函数是一个超类方法，并且有子类进行了覆写，那么还需要对所有子类的覆写方法进行同样的提炼操作，保证继承体系上每个类都有一份与超类相同的提炼函数。<br>接着将子类的提炼函数删除，让它们引用超类提炼出来的函数。 |


## 移动语句（Slide Statements）

| title | content |
| ---- | ---- |
| 场景 |  |
| 意义 | 让存在关联的东西一起出现，可以使代码更容易理解。 |
| 定义 |  |
| 做法 |  |
| 注意 |  |

## 移除死代码（Remove Dead Code）

| title | content |
| ---- | ---- |
| 场景 |  |
| 意义 |  |
| 定义 |  |
| 做法 | 如果死代码可以从外部直接引用，比如它是一个独立的函数时，先查找一下还有无调用点。
<br>将死代码移除。<br>测试 |
| 注意 |  |
