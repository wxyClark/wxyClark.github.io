# 订单系统 OMS

## 表

| 表 | 表注释 | 主键 | 外键 | 关键字段 | 关键字段 | 关键字段 | 关键字段 |
| ----| ---- | ---- | ---- | ---- | ---- |---- | ---- |
| order| 订单主表 | order_id | user_id | *_code <br> 区分来源 | is_* | *_time | *_status |
|  |  |  |  |  |  |  |  |
| order_sku | 订单商品表 | order_sku_id | order_id | goods_sn <br> product_sn | quantity | is_* | *_time | *_status |
| order_cost | 订单费用 | order_cost_id | order_id | currency | *_amount | *_rate | is_invoice | 
| order_recipient | 订单收件人 | order_recipient_id | order_id | recipient_* <br> 收货人详情 | md5_* <nr> 优化查询 |  |  | 
|  |  |  |  |  |  |  |  |
| order_turn | 订单流转表 | order_turn_id | order_id | status | order_json | is_* | *_time |
| order_problem | 问题订单表 | order_problem_id | order_id | *_type | remark <br> description | *_status | *_time | 
| order_refund | 订单退款表 | order_refund_id | order_id | 退款详情 | *_status | *_amount | *_by |
| order_log | 订单日志表 | order_log_id | order_id | *_code | *_type | *_time | *_by |
|  |  |  |  |  |  |  |  | 
| order_rule | 订单规则主表 | order_rule_id | *_code | name <br> event | *_type | *_status | *_time | 
| order_rule_detail | 订单规则明细表 | order_rule_detail_id | order_rule_id | filter_col <br> 约束字段| filter_detail <br> json 规则详情 | C | D | 
| order_rule_match | 订单规则匹配表 | order_rule_match_id | order_id <br> order_rule_id | *_type | *_filter | *_time | *_event | 
|  |  |  |  |  |  |  |  | 
| order_distribution | 订单配货单 | order_distribution_id | **warehouse_id** <br> order_id | recipient_info <br> type <br> status | *_code | *_time | sync_message <br> **跨系统同步** | 

## 业务逻辑