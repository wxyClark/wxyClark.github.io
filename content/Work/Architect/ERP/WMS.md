# 仓库系统 WMS

## 表

| 表 | 表注释 | 主键 | 外键 | 关键字段 | 关键字段 | 关键字段 | 关键字段 |
| ----| ---- | ---- | ---- | ---- | ---- |---- | ---- |
| warehouse | 仓库表 | warehouse_id |  | name | type | status | address_* | 
|  |  |  |  |  |  |  |  | 
| warehouse_area | 仓库区域表 | warehouse_area_id | warehouse_id <br> tenant_id | name | status | *_time | *_by | 
| warehouse_area_category | 仓库区域-商品分类 <br> 关系表 | warehouse_area_category_id | warehouse_area_id <br> product_category | *_code |  |  |  | 
| warehouse_container | 仓库货位表 | warehouse_container_id | warehouse_area_id <br> warehouse_id | max_capacity <br> sku_qty | status <br> type | is_* | *_by <br> *_at | 
|  |  |  |  |  |  |  |  | 
| warehouse_container_allocation | 货位分配表 | warehouse_container_allocation_id | warehouse_id <br> warehouse_area_id <br> warehouse_container_id <br> goods_sn | confirm_* | status | md5_* | *_by <br> *_at | 
| warehouse_container_stock | 货位库存明细表 | warehouse_container_stock_id | warehouse_id <br> warehouse_area_id <br> warehouse_container_id <br> goods_sn <br> product_category | *_stock | stock_version <br> 乐观锁 | *_by <br> *_at | 
| warehouse_container_stock_track | 货位库存变动轨迹表 | warehouse_container_stock_track_id | warehouse_container_stock_id | warehouse_id <br> warehouse_area_id <br> warehouse_container_id <br> goods_sn | type | *_stock | *_by <br> *_at | 
|  |  |  |  |  |  |  |  | 
| warehouse_outbound | 出库单 | warehouse_outbound_id | **OMS.order_distribution_id** | logistics_* <br> 物流关键信息 | type <br> status | *_time | operator_* | 
| warehouse_outbound_detail | 出库单明细 | warehouse_outbound_detail_id | warehouse_outbound_id <br> warehouse_container_id <br> goods_sn | *_num | status |  |  | 
| warehouse_outbound_batch_print | 出库单打印批次 | warehouse_outbound_batch_print_id | warehouse_outbound_id | batch_no | *_time | *_by <br> *_at |  | 
| warehouse_outbound_package | 出库包装记录 | warehouse_outbound_package_id | warehouse_outbound_id | weight | logistics_* <br> 物流信息 | *_time | *_by <br> *_at | 
| warehouse_outbound_face | 面单 | warehouse_outbound_face_id | warehouse_outbound_id <br> virtual_outbound_id | status <br> is_* | label <br> logistics_* | *_time | *_by <br> *_at | 
|  |  |  |  |  |  |  |  | 
| warehouse_goods_stock | 产品库存明细表 | warehouse_goods_stock_id | goods_sn | *_stock | stock_version <br> 乐观锁 | *_by <br> *_at | 
| warehouse_goods_stock_track | 产品库存变动轨迹表 | warehouse_goods_stock_track_id | goods_sn | type | *_stock | *_by <br> *_at | 
|  |  |  |  |  |  |  |  | 
| warehouse_receipt | 入库单 | warehouse_receipt_id | **PMS.purchase_order__id** | supplier_* <br> 供应商信息 | type <br> status | *_time | operator_* | 
| warehouse_receipt_detail | 入库单明细 | warehouse_receipt_detail_id | warehouse_receipt_id <br> goods_sn | *_num | status | *_by  | *_time | operator_* | 
|  |  |  |  |  |  |  |  | 
| warehouse_qc | 入库单 | warehouse_qc_id | warehouse_receipt_id | type <br> status | *_time | operator_* | 
| warehouse_qc_detail | 入库单明细 | warehouse_qc_detail_id | warehouse_qc_id <br> goods_sn | *_num | status | *_by  | *_time | operator_* | 
|  |  |  |  |  |  |  |  | 
| A | B | C | D | A | B | C | D | 
| warehouse_inventory | 仓库盘点主表 | warehouse_inventory_id | warehouse_id | status | *_by <br> *_at |  |  | 
| warehouse_inventory_detail | 仓库盘点表 | warehouse_inventory_detail_id | warehouse_inventory_id <br> goods_sn <br> product_sn | status | *_stock | operator_* | D*_by <br> *_at | 
| warehouse_inventory_move | 库存移动表 | warehouse_inventory_move_id | warehouse_inventory_id <br> goods_sn <br> product_sn | *_num <br> status | *_stock | operator_* | D*_by <br> *_at | 
| warehouse_inventory_move_detail | 库存移动明细表 | warehouse_inventory_move_detail_id | warehouse_inventory_id <br> goods_sn <br> product_sn |*_num <br> status | *_stock | operator_* | D*_by <br> *_at | 
|  |  |  |  |  |  |  |  | 
| warehouse_shelf | 上架管理 | warehouse_shelf_id | warehouse_id | status | *_by <br> *_at |  |  | 
| warehouse_shelf_detail | 上架明细 | warehouse_shelf_detail_id | warehouse_shelf_id <br> goods_sn <br> product_sn | status | *_stock | operator_* | D*_by <br> *_at | 
| warehouse_shelf_detail_track | 上架明细日志轨迹 | warehouse_shelf_detail_track_id | warehouse_shelf_id <br> goods_sn <br> product_sn | status | *_stock | operator_* | D*_by <br> *_at | 

## 业务逻辑