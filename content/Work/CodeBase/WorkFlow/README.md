# 工作流

## 通用模式

* 状态列表 罗列流程版本支持的所有 start_status => end_status 路径
* 流转方式列表(增加版本号管理version) 每个 action_code 对应一种单据的 start_status => end_status 操作，及其他字段的固定值修改
* 每次流转(action_code) order_code + action_code 记录 分配时间、分配人、任务开始时间、任务结束时间、操作人、异常(标签、时间起止 等)
* 每次流转 同步记录 order_log、order_log_detail 