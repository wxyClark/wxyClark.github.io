---
sort: 1
---


# 控制中心(Control Center System)

## 系统-模块

### sub_system子系统

| 字段 | 类型 | 约束 | 默认值 | 备注 |
| ---- | ---- | ---- | ---- | ---- |
| id | bigint | unsigned,自增 | 0 | 与业务无关 |
| sub_system_code | varchar(32) | unsigned<br>unique | 0 | 自增<br>与业务无关<br>所有表比备字段 |
| sub_system_name | varchar(32) | 唯一 | '' | 子系统名称 |
| module_name | varchar(32) |  |  | 模块名称 |
| status | tinyInt | unsigned | 0 | 状态(1:待规划;2:待评审;3:待开发;4:待测试;5:待验收;6:待一灰;7:待二灰;8:待全量) |
| brief | varchar(255) |  |  | 功能简介 |
| article_code | varchar(32) |  |  | 详细文档(help_article.article_code) |
|  |  |  |  |  |
| created_at | datetime | 不支持手动修改 | CURRENT_TIME ON INSERT | 创建时间 |
| created_by | bigInt | unsigned | 0 | 创建人<br>日志表记录名称，业务表记录ID |
| updated_at | datetime | 不支持手动修改 | CURRENT_TIME ON UPDATE | 修改时间 |
| updated_by | bigInt | unsigned | 0 | 修改人<br>日志表记录名称，业务表记录ID |

### module功能模块表

| 字段 | 类型 | 约束 | 默认值 | 备注 |
| ---- | ---- | ---- | ---- | ---- |
| id | bigint | unsigned,自增 | 0 | 与业务无关 |
| sub_system_code | varchar(32) | unsigned<br>unique | 0 | 自增<br>与业务无关<br>所有表比备字段 |
| module_code | varchar(32) | UK | '' | 模块编码 |
| module_name | varchar(32) | UK(module_code,module_name) | 模块下唯一 | 模块名称 |
| status | tinyInt | unsigned | 0 | 状态(1:待规划;2:待评审;3:待开发;4:待测试;5:待验收;6:待一灰;7:待二灰;8:待全量) |
| brief | varchar(255) |  |  | 功能简介 |
| article_code | varchar(32) |  |  | 详细文档(help_article.article_code) |
|  |  |  |  |  |
| created_at | datetime | 不支持手动修改 | CURRENT_TIME ON INSERT | 创建时间 |
| created_by | bigInt | unsigned | 0 | 创建人<br>日志表记录名称，业务表记录ID |
| updated_at | datetime | 不支持手动修改 | CURRENT_TIME ON UPDATE | 修改时间 |
| updated_by | bigInt | unsigned | 0 | 修改人<br>日志表记录名称，业务表记录ID |

### help_article帮助文档

* 无限级分类