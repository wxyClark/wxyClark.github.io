# 防重复

## while

* 遍历数据表，注意按(顺序读取数据 或 按标记读取数据，处理后修改标记)

## 长脚本

* 注意判定当前是否在处理中，避免执行间隔太小导致重复执行
* 如 加锁：有锁退出；无锁加锁，执行完毕之后释放锁