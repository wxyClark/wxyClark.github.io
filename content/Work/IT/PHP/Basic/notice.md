# 注意细节

## 语法
?? 判定变量是否定义

```php
$a ?? 0; <=> isset($a) ? $a : 0; 

//  当需要对$a 做运算时
$array[$key] = 0;
if (isset($array[$key])) {
    $array[$key] = $array[$key] * $rate;
}
```

## 转义

## Array key 会有如下的强制转换

```tip
key 可以是 integer 或者 string。value 可以是任意类型
Array 和 object 不能 被用为键名。坚持这么做会导致警告：Illegal offset type。
```

* String 中包含有效的十进制 int，除非数字前面有一个 + 号，否则将被转换为 int 类型。例如键名 "8" 实际会被储存为 8。另外， "08" 不会被强制转换，因为它不是一个有效的十进制整数。
* Float 也会被转换为 int ，意味着其小数部分会被舍去。例如键名 8.7 实际会被储存为 8。
* Bool 也会被转换成 int。即键名 true 实际会被储存为 1 而键名 false 会被储存为 0。
* Null 会被转换为空字符串，即键名 null 实际会被储存为 ""。

```php
//  如果在数组定义时多个元素都使用相同键名，那么只有最后一个会被使用，其它的元素都会被覆盖。
$array = array(
    1    => 'a',
    '1'  => 'b', // 值 "a" 会被 "b" 覆盖
    1.5  => 'c', // 值 "b" 会被 "c" 覆盖
    true => 'g', // 值 "c" 会被 "g" 覆盖
    '01'  => 'e', // 由于这不是整数字符串，因此不会覆盖键名 1
    '1.5' => 'f', // 由于这不是整数字符串，因此不会覆盖键名 1

    false => 'h',
    -1 => 'd',

    '' => 'i',
    null => 'j', // 值 "i" 会被 "j" 覆盖

    'k', // 值 “k” 的键名被分配为 2。这是因为之前最大的整数键是 1
    2 => 'l', // 值 "k" 会被 "l" 覆盖
);
print_r($array);
//  输出：
(
    [1] => g
    [01] => e
    [1.5] => f

    [0] => h
    [-1] => d

    [] => j
    
    [2] => l
)
```

## 数据类型

* 数据库读取出来的小数是字符串格式 '0.000'； 
> empty('0.000') => false ; 
> 
> '0.000' > 0 => false;
> 
> '0' => true;


* null 是一个空值，直接json_encode 会变成字符串 'null'
```php
$model['json_column'] = empty($column) ? null : json_encode($column, JSON_UNESCAPED_UNICODE);
```
