# Python3 与 PHP 语法特性对比

## 一、数据类型对比

### 1.1 基本数据类型

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **整数** | `int`，无大小限制 | `int`，受平台限制（通常 64 位） | Python 整数自动扩展，PHP 整数溢出转为浮点数 |
| **浮点数** | `float`，双精度 | `float`，双精度 | 基本相同，都遵循 IEEE 754 标准 |
| **字符串** | `str`，Unicode 字符串 | `string`，字节序列 | Python 3 默认 Unicode，PHP 7+ 也支持 Unicode |
| **布尔值** | `bool`，True/False | `bool`，true/false | Python 首字母大写，PHP 全小写 |
| **空值** | `None` | `null` | Python 首字母大写，PHP 全小写 |
| **数组** | `list`（有序列表） | `array`（关联数组） | Python list 只能数字索引，PHP array 支持关联键 |
| **字典** | `dict`（键值对） | `array`（关联数组） | PHP 用 array 同时实现列表和字典功能 |

**代码示例：**

```python
# Python3
# 整数
num = 123456789012345678901234567890  # 大整数自动处理

# 浮点数
price = 19.99

# 字符串
text = "Hello, 世界"  # Unicode 支持

# 布尔值
is_active = True

# 空值
value = None

# 列表
fruits = ["apple", "banana", "orange"]

# 字典
person = {"name": "张三", "age": 25}
```

```php
<?php
// PHP
// 整数
$num = 12345678901234567890; // 超出范围转为浮点数

// 浮点数
$price = 19.99;

// 字符串
$text = "Hello, 世界"; // PHP 7+ 支持 Unicode

// 布尔值
$is_active = true;

// 空值
$value = null;

// 数组（索引数组）
$fruits = ["apple", "banana", "orange"];

// 数组（关联数组）
$person = ["name" => "张三", "age" => 25];
?>
```

### 1.2 类型转换

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **转整数** | `int("123")` 或 `int(3.14)` | `(int)"123"` 或 `intval(3.14)` | Python 使用函数，PHP 使用强制转换或函数 |
| **转浮点数** | `float("3.14")` | `(float)"3.14"` 或 `floatval("3.14")` | Python 使用函数，PHP 使用强制转换或函数 |
| **转字符串** | `str(123)` | `(string)123` 或 `strval(123)` | Python 使用函数，PHP 使用强制转换或函数 |
| **转布尔值** | `bool(1)` | `(bool)1` 或 `boolval(1)` | Python 使用函数，PHP 使用强制转换或函数 |
| **转数组** | `list((1, 2, 3))` | `(array)$obj` | PHP 可以将对象转为数组，Python 只能转可迭代对象 |
| **类型检测** | `isinstance(x, int)` | `is_int($x)` | Python 检查类型，PHP 使用特定函数 |

**代码示例：**

```python
# Python3
# 类型转换
num_str = "123"
num_int = int(num_str)        # 123
num_float = float("3.14")     # 3.14
str_num = str(456)            # "456"
bool_val = bool(1)            # True

# 类型检测
print(isinstance(123, int))    # True
print(isinstance("hello", str)) # True
print(type(123))              # <class 'int'>
```

```php
<?php
// PHP
// 类型转换
$num_str = "123";
$num_int = (int)$num_str;     // 123
$num_float = (float)"3.14";   // 3.14
$str_num = (string)456;       // "456"
$bool_val = (bool)1;          // true

// 类型检测
var_dump(is_int(123));        // bool(true)
var_dump(is_string("hello")); // bool(true)
var_dump(gettype(123));       // string(3) "int"
?>
```

## 二、变量与常量

### 2.1 变量定义

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **变量声明** | 直接赋值 `name = "张三"` | 使用 `$` 符号 `$name = "张三"` | PHP 必须使用 `$` 符号 |
| **变量命名** | `snake_case` 推荐 | `$snake_case` 或 `$camelCase` | Python 推荐下划线，PHP 两种都常用 |
| **变量作用域** | 函数内需要 `global` 声明 | 函数内需要 `global` 声明 | 基本相同 |
| **动态变量** | 不支持 | `$$name` 动态变量名 | PHP 支持动态变量名 |
| **可变变量** | 不支持 | `$a = "hello"; $$a = "world"` | PHP 支持可变变量 |

**代码示例：**

```python
# Python3
# 变量定义
name = "张三"
age = 25

# 多变量赋值
a, b, c = 1, 2, 3

# 交换变量
x, y = 10, 20
x, y = y, x

# 全局变量
count = 0

def increment():
    global count
    count += 1
```

```php
<?php
// PHP
// 变量定义
$name = "张三";
$age = 25;

// 多变量赋值
list($a, $b, $c) = [1, 2, 3];

// 交换变量
$x = 10;
$y = 20;
$temp = $x;
$x = $y;
$y = $temp;

// 全局变量
$count = 0;

function increment() {
    global $count;
    $count++;
}
?>
```

### 2.2 常量定义

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **常量定义** | 使用模块或类 `PI = 3.14` | `define("PI", 3.14)` 或 `const PI = 3.14` | PHP 有专门的常量定义方式 |
| **类常量** | `class Math: PI = 3.14` | `class Math { const PI = 3.14; }` | Python 3.8+ 支持类常量 |
| **常量访问** | `Math.PI` | `Math::PI` | PHP 使用 `::` 操作符 |
| **常量大小写** | 通常大写 `PI` | 通常大写 `PI` | 约定相同 |
| **常量类型** | 任意类型 | 标量类型（int, float, string, bool） | PHP 常量只能是标量类型 |

**代码示例：**

```python
# Python3
# 模块常量
PI = 3.14
MAX_SIZE = 100

# 类常量（Python 3.8+）
class Math:
    PI = 3.14
    E = 2.718

# 访问常量
print(Math.PI)  # 3.14
```

```php
<?php
// PHP
// 使用 define 定义常量
define("PI", 3.14);
define("MAX_SIZE", 100);

// 使用 const 定义常量
class Math {
    const PI = 3.14;
    const E = 2.718;
}

// 访问常量
echo Math::PI;  // 3.14
?>
```

## 三、控制流

### 3.1 条件语句

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **if 语句** | `if condition:` | `if (condition) { }` | Python 使用缩进，PHP 使用大括号 |
| **elif/else if** | `elif condition:` | `elseif (condition) { }` | Python 用 `elif`，PHP 用 `elseif` |
| **三元运算符** | `x if condition else y` | `condition ? x : y` | 语法不同 |
| **switch 语句** | 使用 `match`（Python 3.10+） | `switch ($var) { case: }` | Python 3.10+ 才有 match |
| **条件表达式** | `result = a if a > b else b` | `$result = $a > $b ? $a : $b;` | Python 更简洁 |

**代码示例：**

```python
# Python3
# if-elif-else
score = 85
if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 60:
    grade = "C"
else:
    grade = "D"

# 三元运算符
status = "成年人" if age >= 18 else "未成年人"

# match 语句（Python 3.10+）
match day:
    case 1 | 2 | 3 | 4 | 5:
        print("工作日")
    case 6 | 7:
        print("周末")
```

```php
<?php
// PHP
// if-elseif-else
$score = 85;
if ($score >= 90) {
    $grade = "A";
} elseif ($score >= 80) {
    $grade = "B";
} elseif ($score >= 60) {
    $grade = "C";
} else {
    $grade = "D";
}

// 三元运算符
$status = $age >= 18 ? "成年人" : "未成年人";

// switch 语句
switch ($day) {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
        echo "工作日";
        break;
    case 6:
    case 7:
        echo "周末";
        break;
}
?>
```

### 3.2 循环语句

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **for 循环** | `for item in sequence:` | `for ($i = 0; $i < 10; $i++) { }` | Python 遍历序列，PHP 计数循环 |
| **while 循环** | `while condition:` | `while (condition) { }` | 基本相同，只是语法差异 |
| **foreach 循环** | `for item in list:` | `foreach ($array as $item) { }` | PHP 有专门的 foreach |
| **遍历字典** | `for key, value in dict.items():` | `foreach ($array as $key => $value) { }` | PHP 语法更简洁 |
| **break/continue** | `break` / `continue` | `break;` / `continue;` | PHP 需要分号 |

**代码示例：**

```python
# Python3
# for 循环
for i in range(5):
    print(i)

# 遍历列表
fruits = ["apple", "banana", "orange"]
for fruit in fruits:
    print(fruit)

# 遍历字典
person = {"name": "张三", "age": 25}
for key, value in person.items():
    print(f"{key}: {value}")

# while 循环
count = 0
while count < 5:
    print(count)
    count += 1
```

```php
<?php
// PHP
// for 循环
for ($i = 0; $i < 5; $i++) {
    echo $i;
}

// foreach 循环
$fruits = ["apple", "banana", "orange"];
foreach ($fruits as $fruit) {
    echo $fruit;
}

// 遍历关联数组
$person = ["name" => "张三", "age" => 25];
foreach ($person as $key => $value) {
    echo "$key: $value";
}

// while 循环
$count = 0;
while ($count < 5) {
    echo $count;
    $count++;
}
?>
```

## 四、函数定义

### 4.1 函数声明

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **函数定义** | `def func_name():` | `function func_name() { }` | Python 使用 `def`，PHP 使用 `function` |
| **参数定义** | `def func(a, b):` | `function func($a, $b) { }` | PHP 参数需要 `$` 符号 |
| **返回值** | `return value` | `return $value;` | PHP 需要分号 |
| **返回类型** | `def func() -> int:` | `function func(): int { }` | Python 3.5+ 支持类型提示 |
| **可变参数** | `def func(*args):` | `function func(...$args) { }` | Python 用 `*`，PHP 用 `...` |
| **关键字参数** | `def func(**kwargs):` | 不支持 | Python 支持关键字参数 |

**代码示例：**

```python
# Python3
# 基本函数
def greet(name):
    return f"Hello, {name}!"

# 带类型提示
def add(a: int, b: int) -> int:
    return a + b

# 可变参数
def sum_all(*args):
    return sum(args)

# 关键字参数
def print_info(**kwargs):
    for key, value in kwargs.items():
        print(f"{key}: {value}")

# 默认参数
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"
```

```php
<?php
// PHP
// 基本函数
function greet($name) {
    return "Hello, " . $name . "!";
}

// 带类型提示
function add(int $a, int $b): int {
    return $a + $b;
}

// 可变参数
function sum_all(...$args) {
    return array_sum($args);
}

// 关联数组参数
function print_info(array $info) {
    foreach ($info as $key => $value) {
        echo "$key: $value";
    }
}

// 默认参数
function greet($name, $greeting = "Hello") {
    return "$greeting, $name!";
}
?>
```

### 4.2 匿名函数

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **匿名函数** | `lambda x: x * 2` | `function($x) { return $x * 2; }` | Python 用 `lambda`，PHP 用 `function` |
| **多行匿名函数** | 不支持 | 支持 | PHP 支持多行匿名函数 |
| **箭头函数** | 不支持 | `fn($x) => $x * 2`（PHP 7.4+） | PHP 7.4+ 支持箭头函数 |
| **闭包** | 支持 | 支持 | 两者都支持闭包 |
| **use 关键字** | 不需要 | `use ($var)` | PHP 闭包需要 `use` 导入外部变量 |

**代码示例：**

```python
# Python3
# lambda 函数
square = lambda x: x * 2
print(square(5))  # 10

# 与内置函数结合
numbers = [1, 2, 3, 4, 5]
squared = list(map(lambda x: x ** 2, numbers))
print(squared)  # [1, 4, 9, 16, 25]

# 过滤
even_numbers = list(filter(lambda x: x % 2 == 0, numbers))
print(even_numbers)  # [2, 4]
```

```php
<?php
// PHP
// 匿名函数
$square = function($x) {
    return $x * 2;
};
echo $square(5);  // 10

// 箭头函数（PHP 7.4+）
$square = fn($x) => $x * 2;
echo $square(5);  // 10

// 闭包
$multiplier = 2;
$times = function($x) use ($multiplier) {
    return $x * $multiplier;
};
echo $times(5);  // 10
?>
```

## 五、面向对象编程

### 5.1 类定义

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **类定义** | `class MyClass:` | `class MyClass { }` | Python 使用冒号，PHP 使用大括号 |
| **构造方法** | `def __init__(self):` | `public function __construct() { }` | Python 用 `__init__`，PHP 用 `__construct` |
| **析构方法** | `def __del__(self):` | `public function __destruct() { }` | 名称不同 |
| **实例方法** | `def method(self):` | `public function method() { }` | Python 需要 `self`，PHP 不需要 |
| **类方法** | `@classmethod`<br>`def method(cls):` | `public static function method() { }` | Python 用装饰器，PHP 用 `static` |
| **属性访问** | `self.property` | `$this->property` | PHP 使用 `$this->` |
| **类常量** | `class MyClass:`<br>`    CONST = 100` | `class MyClass {`<br>`    const CONST = 100;`<br>`}` | Python 3.8+ 支持 |

**代码示例：**

```python
# Python3
class Person:
    # 类属性
    species = "人类"

    # 构造方法
    def __init__(self, name, age):
        self.name = name
        self.age = age

    # 实例方法
    def greet(self):
        return f"Hello, I'm {self.name}"

    # 类方法
    @classmethod
    def get_species(cls):
        return cls.species

    # 静态方法
    @staticmethod
    def is_adult(age):
        return age >= 18

# 使用类
person = Person("张三", 25)
print(person.greet())  # Hello, I'm 张三
print(Person.get_species())  # 人类
print(Person.is_adult(20))  # True
```

```php
<?php
// PHP
class Person {
    // 类属性
    const SPECIES = "人类";

    // 属性
    public $name;
    public $age;

    // 构造方法
    public function __construct($name, $age) {
        $this->name = $name;
        $this->age = $age;
    }

    // 实例方法
    public function greet() {
        return "Hello, I'm " . $this->name;
    }

    // 静态方法
    public static function getSpecies() {
        return self::SPECIES;
    }

    public static function isAdult($age) {
        return $age >= 18;
    }
}

// 使用类
$person = new Person("张三", 25);
echo $person->greet();  // Hello, I'm 张三
echo Person::getSpecies();  // 人类
echo Person::isAdult(20);  // 1 (true)
?>
```

### 5.2 继承

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **继承语法** | `class Child(Parent):` | `class Child extends Parent { }` | Python 用括号，PHP 用 `extends` |
| **调用父类** | `super().method()` | `parent::method()` | 语法不同 |
| **重写方法** | 直接定义同名方法 | 直接定义同名方法 | 基本相同 |
| **多重继承** | 支持 | 不支持（使用接口） | Python 支持多重继承 |
| **接口** | 使用抽象基类 | `interface` 关键字 | PHP 有专门的接口语法 |
| **抽象类** | `from abc import ABC` | `abstract class` | PHP 有专门的抽象类语法 |

**代码示例：**

```python
# Python3
class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        pass

class Dog(Animal):
    def speak(self):
        return f"{self.name} 汪汪叫"

    def fetch(self):
        return f"{self.name} 去捡球"

class Cat(Animal):
    def speak(self):
        return f"{self.name} 喵喵叫"

# 多重继承
class Flyable:
    def fly(self):
        return "可以飞行"

class Bird(Animal, Flyable):
    def speak(self):
        return f"{self.name} 叽叽叫"

# 使用
dog = Dog("旺财")
print(dog.speak())  # 旺财 汪汪叫
print(dog.fetch())   # 旺财 去捡球

bird = Bird("小鸟")
print(bird.speak())  # 小鸟 叽叽叫
print(bird.fly())    # 可以飞行
```

```php
<?php
// PHP
class Animal {
    protected $name;

    public function __construct($name) {
        $this->name = $name;
    }

    public function speak() {
        // 抽象方法
    }
}

class Dog extends Animal {
    public function speak() {
        return $this->name . " 汪汪叫";
    }

    public function fetch() {
        return $this->name . " 去捡球";
    }
}

class Cat extends Animal {
    public function speak() {
        return $this->name . " 喵喵叫";
    }
}

// 接口
interface Flyable {
    public function fly();
}

class Bird extends Animal implements Flyable {
    public function speak() {
        return $this->name . " 叽叽叫";
    }

    public function fly() {
        return "可以飞行";
    }
}

// 使用
$dog = new Dog("旺财");
echo $dog->speak();  // 旺财 汪汪叫
echo $dog->fetch();   // 旺财 去捡球

$bird = new Bird("小鸟");
echo $bird->speak();  // 小鸟 叽叽叫
echo $bird->fly();     // 可以飞行
?>
```

## 六、异常处理

### 6.1 异常捕获

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **try-catch** | `try: ... except Exception as e:` | `try { ... } catch (Exception $e) { }` | 语法不同 |
| **多个异常** | `except (TypeError, ValueError):` | `catch (TypeError | ValueError $e)` | PHP 8.0+ 支持多异常捕获 |
| **finally** | `finally:` | `finally { }` | 基本相同 |
| **抛出异常** | `raise Exception("message")` | `throw new Exception("message");` | Python 用 `raise`，PHP 用 `throw` |
| **自定义异常** | `class MyError(Exception):` | `class MyError extends Exception { }` | 继承方式相同 |
| **异常信息** | `e.message`, `e.args` | `$e->getMessage()` | 访问方式不同 |

**代码示例：**

```python
# Python3
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"除零错误：{e}")
except (TypeError, ValueError) as e:
    print(f"类型或值错误：{e}")
except Exception as e:
    print(f"其他错误：{e}")
finally:
    print("清理资源")

# 自定义异常
class CustomError(Exception):
    pass

try:
    raise CustomError("自定义错误")
except CustomError as e:
    print(f"捕获自定义异常：{e}")
```

```php
<?php
// PHP
try {
    $result = 10 / 0;
} catch (DivisionByZeroError $e) {
    echo "除零错误：" . $e->getMessage();
} catch (TypeError | ValueError $e) {
    echo "类型或值错误：" . $e->getMessage();
} catch (Exception $e) {
    echo "其他错误：" . $e->getMessage();
} finally {
    echo "清理资源";
}

// 自定义异常
class CustomError extends Exception {
}

try {
    throw new CustomError("自定义错误");
} catch (CustomError $e) {
    echo "捕获自定义异常：" . $e->getMessage();
}
?>
```

## 七、文件操作

### 7.1 文件读写

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **打开文件** | `open('file.txt', 'r')` | `fopen('file.txt', 'r')` | 函数名不同 |
| **读取文件** | `f.read()` 或 `f.readlines()` | `fread($fp, $size)` 或 `file($filename)` | Python 更简洁 |
| **写入文件** | `f.write('content')` | `fwrite($fp, 'content')` | 函数名不同 |
| **关闭文件** | `f.close()` 或 `with` 语句 | `fclose($fp)` | Python 支持 `with` 自动关闭 |
| **逐行读取** | `for line in f:` | `while (!feof($fp)) { $line = fgets($fp); }` | Python 更简洁 |
| **文件存在** | `os.path.exists('file')` | `file_exists('file')` | 函数名不同 |

**代码示例：**

```python
# Python3
# 读取文件
with open('file.txt', 'r', encoding='utf-8') as f:
    content = f.read()
    # 或逐行读取
    for line in f:
        print(line.strip())

# 写入文件
with open('file.txt', 'w', encoding='utf-8') as f:
    f.write("Hello, World!")

# 追加文件
with open('file.txt', 'a', encoding='utf-8') as f:
    f.write("追加内容")

# 检查文件是否存在
import os
if os.path.exists('file.txt'):
    print("文件存在")
```

```php
<?php
// PHP
// 读取文件
$fp = fopen('file.txt', 'r');
$content = fread($fp, filesize('file.txt'));
fclose($fp);

// 或使用 file() 函数
$lines = file('file.txt');
foreach ($lines as $line) {
    echo trim($line);
}

// 写入文件
$fp = fopen('file.txt', 'w');
fwrite($fp, "Hello, World!");
fclose($fp);

// 追加文件
$fp = fopen('file.txt', 'a');
fwrite($fp, "追加内容");
fclose($fp);

// 检查文件是否存在
if (file_exists('file.txt')) {
    echo "文件存在";
}
?>
```

## 八、字符串操作

### 8.1 常用字符串函数

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **字符串长度** | `len("hello")` | `strlen("hello")` | Python 用内置函数，PHP 用函数 |
| **字符串连接** | `"hello" + "world"` | `"hello" . "world"` | Python 用 `+`，PHP 用 `.` |
| **字符串重复** | `"hello" * 3` | `str_repeat("hello", 3)` | Python 用 `*`，PHP 用函数 |
| **字符串分割** | `"a,b,c".split(",")` | `explode(",", "a,b,c")` | 函数名不同 |
| **字符串连接** | `",".join(["a", "b", "c"])` | `implode(",", ["a", "b", "c"])` | 函数名不同 |
| **字符串查找** | `"hello".find("e")` | `strpos("hello", "e")` | 函数名不同 |
| **字符串替换** | `"hello".replace("e", "a")` | `str_replace("e", "a", "hello")` | 参数顺序不同 |
| **大小写转换** | `"hello".upper()` | `strtoupper("hello")` | Python 用方法，PHP 用函数 |
| **去除空格** | `" hello ".strip()` | `trim(" hello ")` | Python 用方法，PHP 用函数 |
| **子字符串** | `"hello"[0:3]` | `substr("hello", 0, 3)` | Python 用切片，PHP 用函数 |

**代码示例：**

```python
# Python3
text = "Hello, World!"

# 字符串长度
print(len(text))  # 13

# 字符串连接
greeting = "Hello" + " " + "World"
print(greeting)  # Hello World

# 字符串分割
words = "apple,banana,orange".split(",")
print(words)  # ['apple', 'banana', 'orange']

# 字符串连接
result = ",".join(["apple", "banana", "orange"])
print(result)  # apple,banana,orange

# 字符串查找
position = text.find("World")
print(position)  # 7

# 字符串替换
new_text = text.replace("World", "Python")
print(new_text)  # Hello, Python!

# 大小写转换
print(text.upper())  # HELLO, WORLD!
print(text.lower())  # hello, world!

# 去除空格
print("  hello  ".strip())  # hello

# 子字符串
print(text[0:5])  # Hello
```

```php
<?php
// PHP
$text = "Hello, World!";

// 字符串长度
echo strlen($text);  // 13

// 字符串连接
$greeting = "Hello" . " " . "World";
echo $greeting;  // Hello World

// 字符串分割
$words = explode(",", "apple,banana,orange");
print_r($words);  // Array ( [0] => apple [1] => banana [2] => orange )

// 字符串连接
$result = implode(",", ["apple", "banana", "orange"]);
echo $result;  // apple,banana,orange

// 字符串查找
$position = strpos($text, "World");
echo $position;  // 7

// 字符串替换
$new_text = str_replace("World", "Python", $text);
echo $new_text;  // Hello, Python!

// 大小写转换
echo strtoupper($text);  // HELLO, WORLD!
echo strtolower($text);  // hello, world!

// 去除空格
echo trim("  hello  ");  // hello

// 子字符串
echo substr($text, 0, 5);  // Hello
?>
```

## 九、数组操作

### 9.1 常用数组函数

| 对比项类别 | Python3 实现方式 | PHP 实现方式 | 关键差异说明 |
|-----------|-----------------|-------------|-------------|
| **数组长度** | `len([1, 2, 3])` | `count([1, 2, 3])` | 函数名不同 |
| **添加元素** | `list.append(4)` | `array_push($arr, 4)` 或 `$arr[] = 4` | PHP 更灵活 |
| **删除元素** | `del list[0]` 或 `list.remove(4)` | `unset($arr[0])` 或 `array_pop($arr)` | PHP 用 `unset` |
| **数组排序** | `list.sort()` | `sort($arr)` | Python 用方法，PHP 用函数 |
| **数组反转** | `list.reverse()` 或 `list[::-1]` | `array_reverse($arr)` | Python 支持切片 |
| **数组切片** | `list[1:4]` | `array_slice($arr, 1, 3)` | Python 用切片，PHP 用函数 |
| **数组合并** | `list1 + list2` | `array_merge($arr1, $arr2)` | Python 用 `+`，PHP 用函数 |
| **数组查找** | `4 in list` | `in_array(4, $arr)` | Python 用运算符，PHP 用函数 |
| **数组键** | `dict.keys()` | `array_keys($arr)` | Python 用方法，PHP 用函数 |
| **数组值** | `dict.values()` | `array_values($arr)` | Python 用方法，PHP 用函数 |

**代码示例：**

```python
# Python3
# 列表操作
numbers = [1, 2, 3, 4, 5]

# 长度
print(len(numbers))  # 5

# 添加元素
numbers.append(6)
print(numbers)  # [1, 2, 3, 4, 5, 6]

# 删除元素
numbers.remove(3)
print(numbers)  # [1, 2, 4, 5, 6]

# 排序
numbers.sort()
print(numbers)  # [1, 2, 4, 5, 6]

# 反转
numbers.reverse()
print(numbers)  # [6, 5, 4, 2, 1]

# 切片
print(numbers[1:4])  # [5, 4, 2]

# 合并
list1 = [1, 2, 3]
list2 = [4, 5, 6]
combined = list1 + list2
print(combined)  # [1, 2, 3, 4, 5, 6]

# 查找
print(3 in list1)  # True

# 字典操作
person = {"name": "张三", "age": 25}
print(person.keys())   # dict_keys(['name', 'age'])
print(person.values()) # dict_values(['张三', 25])
```

```php
<?php
// PHP
// 数组操作
$numbers = [1, 2, 3, 4, 5];

// 长度
echo count($numbers);  // 5

// 添加元素
array_push($numbers, 6);
// 或 $numbers[] = 6;
print_r($numbers);  // Array ( [0] => 1 [1] => 2 ... [5] => 6 )

// 删除元素
unset($numbers[2]);  // 删除索引为 2 的元素
print_r($numbers);

// 排序
sort($numbers);
print_r($numbers);

// 反转
$reversed = array_reverse($numbers);
print_r($reversed);

// 切片
$sliced = array_slice($numbers, 1, 3);
print_r($sliced);

// 合并
$arr1 = [1, 2, 3];
$arr2 = [4, 5, 6];
$combined = array_merge($arr1, $arr2);
print_r($combined);

// 查找
echo in_array(3, $arr1);  // 1 (true)

// 关联数组操作
$person = ["name" => "张三", "age" => 25];
print_r(array_keys($person));   // Array ( [0] => name [1] => age )
print_r(array_values($person)); // Array ( [0] => 张三 [1] => 25 )
?>
```

## 十、总结

### 10.1 主要差异总结

| 特性 | Python3 | PHP | 说明 |
|------|---------|-----|------|
| **语法风格** | 简洁优雅，强调可读性 | 灵活多样，强调实用性 | Python 更注重代码规范 |
| **变量声明** | 直接赋值 | 需要 `$` 符号 | PHP 必须使用 `$` |
| **缩进** | 强制缩进（语法要求） | 可选缩进（代码风格） | Python 用缩进区分代码块 |
| **类型系统** | 动态类型 + 类型提示 | 动态类型 + 类型声明 | Python 3.5+ 支持类型提示 |
| **面向对象** | 完全面向对象 | 支持面向对象和过程式 | Python 更强调 OOP |
| **多重继承** | 支持 | 不支持（用接口） | Python 更灵活 |
| **标准库** | 丰富（batteries included） | 丰富（PECL 扩展） | 两者都有丰富的库 |
| **性能** | 解释执行，较慢 | 解释执行，较快 | PHP 通常更快 |
| **应用领域** | 数据科学、AI、Web 开发 | Web 开发、服务器脚本 | Python 应用更广泛 |

### 10.2 选择建议

| 场景 | 推荐语言 | 原因 |
|------|---------|------|
| **Web 开发** | PHP | 成熟框架，部署简单 |
| **数据科学** | Python | 丰富的数据科学库 |
| **机器学习** | Python | TensorFlow, PyTorch 等库 |
| **快速原型** | Python | 语法简洁，开发快速 |
| **服务器脚本** | PHP | 部署简单，性能好 |
| **自动化脚本** | Python | 跨平台，库丰富 |
| **API 开发** | 两者皆可 | 根据团队技术栈选择 |

### 10.3 学习建议

1. **理解核心差异**：掌握两种语言的基本语法差异
2. **实践对比**：用两种语言实现相同功能
3. **关注最佳实践**：学习各自的最佳实践和设计模式
4. **利用优势**：根据项目需求选择合适的语言
5. **持续学习**：两种语言都在不断发展，保持学习
6. **阅读文档**：官方文档是最好的学习资源
7. **参与社区**：加入社区，分享经验和问题
