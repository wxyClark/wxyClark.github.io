# 技术选型

## 指标

| 指标 | 说明  |
| ---- | ---- |
| 需求满足度 | 备选方案1）要满足主要需求。2）不要过重，杀鸡不用牛刀 |
| 是否开源 | 如果开源，开源协议是什么；如果收费，什么计费方式 |
| 成熟度 (Maturity) | 是否成熟，是否稳定等。没有硬指标，但可以在备选方案之间形成对比 |
| 学习成本 (Learning curve) | 没有硬指标，但可以在备选方案之间形成对比 |
| 开发速度 | 没有硬指标，但可以在备选方案之间形成对比 |
| 易调试性 |  |
| 流行度 | 在市场上是否容易招到开发者 |
| 可扩展性 | 备选方案是否有排他性，是否兼容相关平台，是否容易进行二次开发或其他扩展方式。 |
| 安全性 | 网络安全、数据库、数据安全等 |
| 技术栈的一致性 | 和本公司其他系统技术栈的一致性 |
| 代码易维护性 | 比如有些代码(如python)不适合进行大型、面向对象的开发 |
| 执行效率 | 比如渲染引擎选用C++比Java多，因为Java执行效率低下 |
| 稳定性 | 系统运行是否稳定，长时间运行有无内存泄露、宕机等情况(MTBF,Mean Time Between Failure) |
| 对高并发的支持 | 能支持多少量级的高并发。QPS：Queries PerSecond，TPS：Transactions Per Second，RT(Response-time) |
| 对大数据的支持 | 是否能支持较大数据量，能支持多少量级的数据。 |
| 政府政策导向 | 政府倾向于用国产 |
| 技术支持 | 是否能更好地得到技术支持 |
| 长远看对自己的优势 | B |

## 常用架构选型：工具集

| 类型 | 工具 | 推荐原因 |
| ---- | ---- | ---- |
| 网关| **Nginx**、Kong、Zuul | |
| 缓存 | **Redis**、MemCached、OsCache、EhCache |Redis 功能强于 Memcached,没必要引入两个(增加复杂度) |
| 搜索 | ElasticSearch、Solr |Java为主推荐ELK|
| 熔断 | Hystrix、resilience4j | |
| 负载均衡 | DNS、F5、LVS、**Nginx**、OpenResty、HAproxy | 减少组件，降低复杂度 |
| 注册中心 | Nacos,Eureka、Zookeeper、Redis、Etcd、Consul | C |
| 认证鉴权 | **OAuth2.0**(对外开放接口),**JWT**（内部）,自定义token（内部） | C |
| 消费队列 | **Kafka** 、RabbitMQ、ZeroMQ、Redis、ActiveMQ| redis负载低 |
| 系统监控 | **Prometheus**、**Nagios**、Grafana、Influxdb、Telegraf、Lepus | 普罗米修斯 |
| 文件系统 | **OSS**、七牛,又拍，fastdfs ，NFS、MogileFS | 对象存储，自定义尺寸 |
| RPC框架 | Dubbo、Motan、Thrift、grpc | C |
| 工作流 | activity,Oozie | C |
| 规则引擎 | drools | C |
| 构建工具 | Maven、Gradle | C |
| 集成部署 | Docker、Jenkins、Git、Maven | C |
| 分布式配置 | Disconf(百度)、Apollo（携程）、Spring Cloud Config、Diamond | C |
| 压测 | LoadRunner、JMeter、AB、webbench | C |
| 数据库 | MySql、**Redis**、MongoDB、PostgreSQL、Memcache、HBase | C |
| 网络 | 专用网络VPC、弹性公网IP、CDN | C |
| 数据库中间件 | Sharding-JDBC（强烈推荐 客户端），DRDS、Mycat（服务端）、360 Atlas、Cobar (不维护了) | C |
| 分布式框架 | Dubbo、Motan、Spring-Could | C |
| 分布式任务 | XXL-JOB、Elastic-Job、Saturn、Quartz | C |
| 分布式追踪 | Pinpoint、CAT、zipkin | C |
| 分布式日志 | **elasticsearch**、logstash、Kibana 、redis、kafka | C |
| 版本发布 | 蓝绿部署、A/B测试、灰度发布／金丝雀发布 | C |
| A | B | C |
| 前端监控 | IP、PV、运营商、系统、性能、状态码 | C |
| 业务监控 | 登录、注册、下单、支付 | C |
| 应用层监控 | service、sql、cache、响应时间 | C |
| 系统监控 | 物理机、虚拟机、容器，CPU、内存、IO、硬盘 | C |
| 基础监控 | 网络、交换机、路由器 | C |
| A | B | C |

## 监控

* 日志监控 beat+kafka+Logstash+es+Grafana
* 调用链监控 SkyWalking,zipkin
* 告警系统 Alertmanager
* Metrics监控 Prometheus
* 监控检查
```
Docker、Grafana、Prometheus、Telegraf、Influxdb、Lepus、Elasticsearch、Logstash、Kibana、kafka、node插件、dashboards仪表盘、钉钉、邮件、微信。
```

## 知识面

* 架构层面

```
负载均衡（负载均衡算法）
反向代理
服务隔离
服务限流
服务降级（自动优雅降级）
失效转移
超时重试（代理超时、容器超时、前端超时、中间件超时、数据库超时、NoSql超时）
回滚机制（上线回滚、数据库版本回滚、事务回滚）
```

* 高并发
  
```
应用缓存
HTTP缓存
多级缓存
分布式缓存
连接池
异步并发

事务，分布式事务
队列
```

* 扩容-拆分

```
单体垂直扩容
单体水平扩容
应用拆分
数据库拆分
数据库分库分表
数据异构
分布式任务
```

## 安全

```
网络安全
SQL注入
XSS攻击
CSRF攻击
拒绝服务（DoS，Denial　of　Service）攻击
Elk
```
