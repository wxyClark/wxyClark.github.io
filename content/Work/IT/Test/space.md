# 空格

## MySql的空格

varchar 字段值末尾有空格
查询会过滤掉字符串末尾的空格，不会去掉开头的空格
select * from table_name where column = 'xxx' 可以搜到 column 值为 'xxx '的数据
select * from table_name where column = 'xxx ' 可以搜到 column 值为 'xxx'的数据


## php的空格

带有空格的数值做数组的key？