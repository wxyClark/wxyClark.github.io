---
title: 网络基础
description: 计算机网络核心：协议栈与 DNS、HTTP 语义、安全设计，按分层认知顺序组织
---

# 网络基础

> 按「先能通、再懂语义、最后谈安全」的顺序学习：协议栈 → HTTP → 安全设计。

---

## 📚 内容导航

| 名称 | 说明 | 链接 |
|------|------|------|
| 网络协议栈与 DNS | 四层模型、TCP 可靠传输、IP/NAT/路由、解析链与排查工具 | [进入](01-network-protocol-stack.md) |
| HTTP 与 Web 通信 | 方法幂等、状态码语义、Header 契约、缓存与登录态 | [进入](02-http-basics.md) |
| 系统安全设计 | 注入/XSS/CSRF/越权、密码与密钥、部署安全基线 | [进入](03-system-security-design.md) |

---

## 🎯 按问题找答案

| 你想解决的问题 | 先看 |
|----------------|------|
| 网站打不开，不知从哪查起 | [网络协议栈与 DNS](01-network-protocol-stack.md) 第七节排查工具链 |
| TIME_WAIT / CLOSE_WAIT 堆积 | [网络协议栈与 DNS](01-network-protocol-stack.md) |
| 改了 DNS 记录不生效 | [网络协议栈与 DNS](01-network-protocol-stack.md) DNS 一节 |
| 401/403/422 该返回哪个 | [HTTP 与 Web 通信](02-http-basics.md) |
| 静态资源缓存不更新 | [HTTP 与 Web 通信](02-http-basics.md) 缓存一节 |
| 登录态该用 Session 还是 JWT | [HTTP 与 Web 通信](02-http-basics.md) 状态管理一节 |
| 接口被刷、越权访问 | [系统安全设计](03-system-security-design.md) |

---

## 🔗 相关链接

| 主题 | 链接 |
|------|------|
| 上一级 | [AI-IT 知识体系](../index.md) |
| 操作系统 | [进程与网络 IO](../fundamentals/software/01-operating-systems.md) |
| 后端工程 | [后端开发](../fundamentals/software/06-backend-engineering.md) |
| 组成原理 | [计算机体系结构](../hardware/computer-architecture/01-essentials.md) |
