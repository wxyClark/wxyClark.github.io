---
title: "系统安全设计"
description: "安全设计的 20% 核心：输入不可信、权限看资源归属、凭证有有效期、密码只存哈希，覆盖注入/XSS/CSRF/JWT 与部署基线"
---

# 系统安全设计 — 默认不信任任何输入

> 一句话：绝大多数漏洞来自同一个假设——「这个输入是可信的」；把「不信任」变成默认动作，安全就从专项变成本能。

## 🎯 这 20% 能解决哪些问题

| 你遇到的困惑 | 本质原因 | 马上能改的动作 |
|---|---|---|
| 参数拼接处怕 SQL 注入 | 把数据当代码执行 | 统一用参数绑定/ORM，禁止字符串拼 SQL |
| 用户评论区能弹 `alert()` | 输出未转义，富文本未净化 | 输出统一转义；富文本走白名单净化 + CSP |
| 登录后能访问别人的订单 | 只校验了登录，没校验资源归属 | 每个资源操作都过 Policy/权限层，防水平越权 |
| JWT 无法主动失效 | 令牌自包含，服务端没状态 | 短有效期 + 刷新机制，必要时引入黑名单或版本号 |
| 密码库泄露就能登录 | 用可逆加密或弱哈希 | 只存 bcrypt/argon2 哈希，永不明文与可逆加密 |
| 密钥进了 Git 历史记录 | 凭证写在代码/配置文件 | 密钥集到环境变量或密钥服务，仓库只留 example |

---

## 一、安全威胁全景

```mermaid
flowchart LR
    subgraph 注入攻击["💉 注入攻击"]
        I1["SQL注入"]
        I2["XSS跨站脚本"]
        I3["命令注入"]
    end
    
    subgraph 身份认证["🔐 身份认证"]
        A1["CSRF跨站请求伪造"]
        A2["会话固定"]
        A3["暴力破解"]
    end
    
    subgraph 数据传输["📡 数据传输"]
        D1["中间人攻击"]
        D2["数据泄露"]
        D3["DDoS攻击"]
    end
    
    subgraph 业务安全["⚠️ 业务安全"]
        B1["越权访问"]
        B2["文件上传漏洞"]
        B3["API滥用"]
    end
    
    style I1 fill:#ffebee
    style I2 fill:#fff3e0
    style A1 fill:#e3f2fd
    style B1 fill:#e8f5e9
```

---

## 二、注入攻击防护

### 2.1 SQL注入

```
❌ 危险代码（拼接SQL）：
$sql = "SELECT * FROM users WHERE id = " . $_GET['id'];

✅ 正确代码（参数绑定）：
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$userId]);

✅ Laravel方式（自动转义）：
User::where('id', $userId)->first();
```

### 2.2 XSS防护

```mermaid
flowchart LR
    A["攻击者"] -->|"注入<script>"| B["漏洞网站"]
    B --> C["受害者浏览器"]
    C --> D["Cookie被窃取"]
    
    style D fill:#ffebee
```

| 类型 | 说明 | 防护 |
|------|------|------|
| **存储型** | 恶意脚本存入数据库 | 输出时HTML编码 |
| **反射型** | 恶意脚本在URL中 | 输入验证+输出编码 |
| **DOM型** | 前端JS直接操作DOM | 禁用innerHTML，用textContent |

```php
// Laravel自动转义
{{ $user->bio }}        // Blade自动 htmlspecialchars
{!! $htmlContent !!}    // 不过滤，需谨慎使用
```

### 2.3 命令注入

```php
// ❌ 危险
system('ping ' . $userInput);

// ✅ 安全：白名单验证
$allowedHosts = ['example.com', 'google.com'];
if (in_array($userInput, $allowedHosts)) {
    system('ping -c 4 ' . escapeshellarg($userInput));
}
```

---

## 三、CSRF防护

```mermaid
flowchart LR
    A["受害者已登录"] -->|"访问恶意站点"| B["恶意站点发起请求"]
    B -->|"携带Cookie"| C["服务器误以为是合法请求"]
    
    style C fill:#ffebee
```

| 防护方式 | 实现 |
|----------|------|
| **CSRF Token** | 每个表单嵌入随机token |
| **SameSite Cookie** | `Set-Cookie: Secure; SameSite=Lax` |
| **Origin检查** | 验证请求来源 |
| **双重提交** | Cookie+Header都带token |

```php
// Laravel自动防护
<form method="POST">
    @csrf  // 自动生成token
</form>
```

---

## 四、JWT与OAuth2

### 4.1 JWT结构

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.        // Header
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ikp...      // Payload
SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV         // Signature
```

| 部分 | 内容 | 安全性 |
|------|------|--------|
| Header | 算法+类型 | 明文 |
| Payload | 用户声明（sub/name/email） | 明文（可解码） |
| Signature | HMACSHA256(encodeHeader.encodePayload+secret) | 签名验证 |

### 4.2 JWT安全注意事项

```
✅ 正确做法：
- 使用强密钥（至少256位）
- 设置合理的exp过期时间
- 存储敏感信息到服务端（不放入JWT）
- 使用HTTPS传输
- 实现token黑名单（注销场景）

❌ 错误做法：
- 将密码放入JWT payload
- 不设过期时间
- 使用HS256+弱密钥
- 在URL中传递JWT（进入日志）
```

### 4.3 OAuth2授权流程

```mermaid
sequenceDiagram
    participant U as 用户
    participant C as 客户端
    participant S as 授权服务器
    participant R as 资源服务器
    
    U->>C: 点击"第三方登录"
    C->>S: 跳转授权页面
    U->>S: 登录并授权
    S->>C: 返回authorization_code
    C->>S: 用code换取access_token
    S->>C: 返回token
    C->>R: 用token获取用户信息
    R->>C: 返回用户数据
    C->>U: 展示登录成功
```

---

## 五、密码安全

```php
// ❌ 绝对禁止
$password = md5($input);           // MD5已破解
$password = sha1($input);          // SHA1不安全
$password = base64_encode($input); // base64不是加密

// ✅ 正确使用
$passwordHash = password_hash($input, PASSWORD_BCRYPT, [
    'cost' => 12,  // 增加计算成本
]);

// 验证
if (password_verify($input, $storedHash)) {
    // 密码正确
    if (password_needs_rehash($storedHash, PASSWORD_BCRYPT, ['cost' => 12])) {
        // 更新哈希
    }
}
```

---

## 六、HTTPS配置

```nginx
server {
    listen 443 ssl http2;
    server_name example.com;
    
    ssl_certificate /path/to/fullchain.pem;
    ssl_certificate_key /path/to/privkey.pem;
    
    # 安全头
    add_header Strict-Transport-Security "max-age=63072000" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # 禁用旧协议
    ssl_protocols TLSv1.2 TLSv1.3;
}
```

---

## 七、安全 checklist

### 开发阶段
```
□ 所有用户输入都做验证和过滤
□ 使用参数化查询防止SQL注入
□ 输出时HTML实体编码防XSS
□ 表单添加CSRF Token
□ 敏感操作需要二次确认
□ 文件上传校验MIME类型和扩展名
□ API接口添加速率限制
□ 错误信息不泄露堆栈细节
```

### 部署阶段
```
□ 启用HTTPS（TLS 1.2+）
□ 配置安全响应头
□ 禁用危险HTTP方法
□ 配置CDN WAF防护
□ 定期安全扫描（OWASP ZAP）
□ 依赖包漏洞扫描（composer audit）
□ 配置文件不提交到版本库
```

---

## 八、本章总结

> **核心规律：安全不是功能，而是属性。安全漏洞往往源于「假设输入是可信的」。永远不要信任用户输入，永远验证、过滤、转义。**

### 关键记忆点
- ✅ SQL注入→参数化查询，XSS→输出编码，CSRF→Token验证
- ✅ JWT不存敏感信息，设过期时间，用强密钥
- ✅ 密码用bcrypt/argon2哈希，永不明文存储
- ✅ HTTPS是基础，安全头是保障

---

## 🎓 实战场景（TIL）

- **场景**：图片下载功能被用来探测内网。**本质**：服务端按用户给的 URL 发起请求，未校验目的地（SSRF）。**要点**：白名单域名 + 解析后拦截内网/链路本地地址，禁止跟随重定向，关闭多余协议（`file://`、`gopher://`）。
- **场景**：安全测试报「水平越权」，代码里明明有登录中间件。**本质**：只认证了身份，未校验资源归属；`order_id` 是可遍历的自增整数。**要点**：权限判断下沉到 Policy/仓储层（带 `user_id` 条件），ID 改用不可遍历的雪花/UUID。
- **场景**：改密码后旧 token 仍能用一周。**本质**：JWT 自包含、无状态，服务端无从作废。**要点**：访问令牌短有效期（分钟级）+ 刷新令牌可控失效；用版本号/黑名单字段让改密即刻失效。
- **场景**：接入第三方回调被伪造请求刷单。**本质**：只校了签名格式，未校时间戳与 nonce，可重放。**要点**：签名 + 时间窗 + nonce 去重三件齐备，并区分验签失败与业务失败分别告警。

---

## 📋 一页速查

| 我要做 | 照着做 |
|---|---|
| 处理任何外部输入 | 校验类型/长度/范围，失败直接 422，不进入业务 |
| 写 SQL | 只用参数绑定；动态表名列名走白名单映射 |
| 渲染用户内容 | 默认转义；富文本用白名单净化 + CSP |
| 写接口鉴权 | 登录校验 + 资源归属校验两道，缺一即越权 |
| 写操作防护 | CSRF Token 或 `SameSite=Lax/Strict` Cookie |
| 存密码 | bcrypt/argon2；禁止自定义加密算法 |
| 管密钥 | 环境变量/密钥服务；定期轮换，泄露立即废弃 |
| 上生产前 | HTTPS + HSTS + 安全头 + 依赖漏洞扫描 + 日志不记敏感字段 |

---

## 🔗 相关链接
- [网络协议栈与 DNS](01-network-protocol-stack.md) — TLS 之下的传输层与解析链
- [HTTP 与 Web 通信](02-http-basics.md) — Cookie/JWT 与状态码语义
- [容器化与 CI/CD](../fundamentals/software/14-containerization-cicd.md) — 部署安全
- [技术团队管理](../fundamentals/software/15-technical-team-management.md) — 安全文化建设
