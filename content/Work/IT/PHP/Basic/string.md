# 字符串

## json

```php
//  JSON_UNESCAPED_UNICODE（中文不转为unicode ，对应的数字 256）
//  JSON_UNESCAPED_SLASHES （不转义反斜杠，对应的数字 64）)
json_encode($array, JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE);
```

## 截取
* 根据字符数执行一个【**多字节安全**】的 substr() 操作
```php
//mb_substr — 获取部分字符串
mb_substr(
    string $str,
    int $start,
    int $length = NULL,
    string $encoding = mb_internal_encoding()
): string

//  去掉首个字符
mb_substr($str, 1);
mb_substr($str, 1, null);
```

```danger
//  去掉【首、尾】各一个字符
mb_substr($str, 1, -1);
```