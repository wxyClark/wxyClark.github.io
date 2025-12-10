# BaseTools基础工具集

## Helpers 数据处理帮助类

* 和数据库无交互的数据处理方法、算法按类型封装
> ArrayHelper 数组处理(比较、排序、计算、过滤、转换)
> CacheHelper 缓存处理(读取、更新)
> Captcha 验证码处理
> ColorHelper 颜色定义
> DatetimeHelper
> ExcelHelper 导入导出的通用方法
> FileHelper 文件处理
> ListHelper 数据集合补充公共数据的映射(如xx_code需要获取xx_name等，在系统内多个列表都需要处理，须封装)
> NumberHelper  数值处理
> StringHelper  字符串处理
> ValidateHelper 特殊的数据校验
> XxxBusinessHelper 业务相关的通用处理

## Excel导入

### 无模板的导入(不存在合并单元格，标准二维表)

### 有模板的导入(指定表格是指定数据)

## Excel导出

```danger
强烈建议对文件类型的数据导出链接 支持单独下载,不要在导出excel中处理文件(图片、压缩包、视频等)
```

### 无模板的导出(标准二维表，导出不合并单元格)

* 写通用导出类，入参：二维数据，二维行列配置[列名 => [key、title、列宽]]
> 列名可不配置，更灵活，通过 chr(index + 65) 得到列名，方便调整列顺序

### 有模板的导出(表头特殊处理||内容是标准二维表但是有单元格合并)

* 写【通用的模块数据处理方法】，入参：二维数据，二维行列配置[key => [列名start、列名end]]
* 导入模板 或 通过【通用的模块数据处理方法】处理表头
* 逐列写当前导出通用的列宽定义

### 特殊模板的导出(有单元格合并||有单元格内容过长需要特殊处理||有特殊格式的单元格)

* 写【通用的模块数据处理方法】
* 导入模板 或 通过【通用的模块数据处理方法】处理表头
* 遍历数据，针对特殊数据 做特殊处理

## 数据字典

### 常量数据字典
```tips
常量定义集中维护 方便查找，避免ES维护时因为字段注释太长导致报错

建立缓存更新机制，提升读取销量

【常量定义 务必集中，尽量简单，避免重复】
常量在代码中也应该按模块集中定义，避免重复：不同repository||model会使用相同的字段，对应相同的常量定义
同一个常量字段，集中定义，使用相同的前缀，避免误解
```

* 层级数据  缓存，可分成多套：铺平、组装成树状结构、组装成父子结构 (如：地址、无限级分类)
* 流程类数据 区分版本号缓存，兼容多版本数据并行  (如：流转路径、触发规则)
* 标识类数据 通过静态方法读取(指定参数)缓存得到map (如：状态、类型、标签)

参考：
标识类常量主表 tag_const_table字段：const_code(PK)、app、module、table、column、version
标识类常量明细 ag_const_detail字段：(const_code、value)UNIQUE、const_key、name、desc、remark

流程类数据主表 process_const_table字段：process_code(PK)、app、module、name、desc
流程类数据操作 process_const_action字段：process_code、action_code(PK)、name、desc、remark
流程类数据明细 process_const_detail字段：(process_code、action_code、version)UNIQUE、column、start、end、config(JSON配置触发的数据处理)

层级数据表 xx_category_table字段：xx_code、parent_code、depth、sort、name、desc、remark

## 日志

```danger
数据流转、金额变更 等一定要记录日志，记录变更前、变更后的数据
```

### 单据日志
```tips
order_detail 变更怎么记录,数据处理是先删后增的
```
* 单据日志表 order_code、action_type、remark、old_value(JOSN)、new_value(JOSN)、changed_at(与主表的updated_at取同一个值)、changed_by

### 明细日志

* 明细日志表 table_name、order_code、from_app、action_type、column、old_value(JOSN)、new_value(JOSN)、changed_at(与主表的updated_at取同一个值)、changed_by

### 时间触发日志

* event_name、params、result、event_at、handle_at


### 父子日志表

* 主日志 log_code、order_code、action_type、remark、changed_at(与主表的updated_at取同一个值)、changed_by
* 子日志 log_code、order_code、table、column、old_value(JOSN)、new_value(JOSN)