# 负载均衡

负载均衡（Load Balance）集群提供了一种廉价、有效、透明的方法，来扩展网络设备和服务器的负载、带宽和吞吐量，同时加强了网络数据处理能力，提高了网络的灵活性和可用性。

## Nginx负载均衡核心组件

* rr轮询（默认调度算法，静态调度算法）
* upstream模块调度算法

通过proxy_pass功能把用户的请求交由上面反向代理upstream 定义的www_server_pools服务器池处理

proxy_pass http:// www_server_pools；