# 订单

## 抽象多种订单的共性
* order_info 数据版本，流程版本
* order_detail 先删后增，删除记录源数据的日志
* order_address 记录region_code,冗余地址明细
* order_payment 
* order_log 所有操作,每个操作(事务)一条日志，区分 用户操作、系统触发，
* order_log_detail 所有数据项变更，业务+表+字段+值(变更前、变更后、操作人)
* order_work_flow 单据流转路径
* order_statistics
