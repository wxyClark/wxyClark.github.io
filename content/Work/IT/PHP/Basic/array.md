# 数组

## key

空格问题

数字、字符串混用问题

大小写问题

## 数组合并


```danger
    array_merge 整数下标 合并时会 从0开始重排，bigInt类型的数据会丢失，如果需要保留key，请使用 数组加法：$array1 + $array2
```
```php
//  合并一个或多个数组
array_merge(array ...$arrays): array

//  将一个或多个数组的单元合并起来，一个数组中的值附加在前一个数组的后面。返回作为结果的数组。
//  如果输入的数组中有相同的字符串键名，则该键名后面的值将覆盖前一个值。然而，如果数组包含数字键名，后面的值将 不会 覆盖原来的值，而是附加到后面。
//  如果输入的数组存在以数字作为索引的内容，则这项内容的键名会以连续方式重新索引。
```

## 数组交集

```php
array_intersect(array $array, array ...$arrays): array

//返回一个数组，该数组包含了所有在 array 和其它参数数组中同时存在的值。
//注意，键名保留不变。结果保留了第一个$array的键名，下标类型的键名，强烈建议使用array_values()处理一下结果

```

## 随机数-数组

```php
//  根据范围创建数组，包含指定的元素
range(string|int|float $start, string|int|float $end, int|float $step = 1): array
//  打乱数组
shuffle(array &$array): bool
//  从数组中随机取出一个或多个【随机键】
array_rand(array $array, int $num = 1): int|string|array

//  生成200个随机数
$rangeArray = range(100, 999);
$randKeys = array_rand($rangeArray, 200);     //  【这里取到的是键，不是随机数的值】
$value = $rangeArray[$randKeys[0]];
```