# Excel

## 技巧

### vlookup

### 图标

### 联动筛选

### 统计颜色


## 导出

* 导出数据，单元格内需要换行的，在字符串后追加 "\r\n" 【注意】必须是双引号，单引号无效

### bigint问题

【问题】bigint类型数据，直接导出回被转换成科学计数法，丢失尾部精度
```
方案：在指定数值末尾追加空格转为字符串即可，PHP下 使用 (string)$value; 无效
```