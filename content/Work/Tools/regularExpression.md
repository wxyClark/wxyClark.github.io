# 正则表达式

| 符号 | 意义 | 举例 |
| ---- | ---- |---- |
| ^ | 匹配行或者字符串的起始位置，有时还会匹配整个文档的起始位置 |C |
| $ | 匹配行或字符串的结尾 |C |
| . | 匹配除了换行符以外的任何字符 |  |
| ([\d\D]*) | 匹配包含换行符以的任何字符 |  |
| ([\s\S]*) | 匹配包含换行符以的任何字符 |  |
| ([\w\W]*) | 匹配包含换行符以的任何字符 |  |
| \d | 匹配数 |C |
| \w | 匹配字母，数字，下划线 |C |
| \s | 匹配空格 |C |
| A | B |C |
| A | B |C |
| A | B |C |

## 中文

* 文件路径有中文，修改文件路径
```php
$pattern = "/[\x{4E00}-\x{9FA5}]+/u";
preg_match($pattern, $relativePath, $match);
if (!empty($match)) {
    $pathinfo = pathinfo($relativePath);
    $relativePath = '/temp/'.microtime(true).rand(0,9999).'.'.$pathinfo['extension'];
    $url = formatFileUrl($relativePath);
}
```

* 特殊符号会导致oss地址无法访问,规范文件名
```php
function ossSafetyFileName(string $fileName)
{
    $pattern = "/[\x{4E00}-\x{9FA5}A-Za-z0-9-_.()]+$/u";
    $char_arr = mb_str_split($fileName);
    $matches = [];
    foreach ($char_arr as $char) {
        if (!preg_match($pattern, $char)) {
            $matches[] = $char;
        }
    }
    if ($matches) {
        $fileName = str_replace($matches, '', $fileName);
    }

    return $fileName;
}
```