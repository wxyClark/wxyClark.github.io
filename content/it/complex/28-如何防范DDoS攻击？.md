# 如何防范DDoS攻击？

## 概要回答

DDoS（分布式拒绝服务）攻击是一种常见的网络安全威胁，攻击者通过控制大量僵尸网络向目标服务器发送海量请求，耗尽服务器资源导致正常用户无法访问。防范DDoS攻击需要从多个层面入手：

1. **网络层防护**：通过防火墙规则、ACL访问控制列表限制异常流量
2. **应用层防护**：使用WAF(Web应用防火墙)识别并阻断恶意请求
3. **CDN和负载均衡**：分散流量压力，隐藏真实服务器IP
4. **限流和速率控制**：对请求频率进行限制，防止突发流量冲击
5. **云防护服务**：利用云服务商提供的DDoS防护能力
6. **监控和预警**：实时监控流量变化，及时发现异常攻击行为

## 深度解析

### DDoS攻击原理

DDoS攻击的核心是利用分布式僵尸网络同时向目标发起大量请求，使服务器资源耗尽而无法响应正常用户的请求。主要攻击类型包括：

1. **体积型攻击**：如UDP Flood、ICMP Flood，通过占用大量带宽消耗目标资源
2. **协议型攻击**：如SYN Flood、ACK Flood，针对TCP/IP协议栈漏洞进行攻击
3. **应用层攻击**：如HTTP Flood、Slowloris，模拟正常用户行为但持续占用服务器资源

### 防护策略和技术实现

#### 1. 网络层防护

在网络设备上配置防火墙规则和访问控制列表，可以有效过滤掉部分恶意流量：

```php
<?php
/**
 * 网络层DDoS防护类
 */
class NetworkProtection {
    private $blockedIps = [];
    private $rateLimits = [];
    
    /**
     * 检查IP是否被阻止
     */
    public function isBlocked($ip) {
        return in_array($ip, $this->blockedIps);
    }
    
    /**
     * 添加IP到黑名单
     */
    public function blockIp($ip) {
        if (!in_array($ip, $this->blockedIps)) {
            $this->blockedIps[] = $ip;
        }
    }
    
    /**
     * 移除IP黑名单
     */
    public function unblockIp($ip) {
        $key = array_search($ip, $this->blockedIps);
        if ($key !== false) {
            unset($this->blockedIps[$key]);
        }
    }
    
    /**
     * 获取黑名单列表
     */
    public function getBlockedIps() {
        return $this->blockedIps;
    }
    
    /**
     * 记录IP请求频率
     */
    public function logRequest($ip) {
        $currentTime = time();
        if (!isset($this->rateLimits[$ip])) {
            $this->rateLimits[$ip] = [];
        }
        
        // 清理超过60秒的记录
        foreach ($this->rateLimits[$ip] as $key => $timestamp) {
            if ($currentTime - $timestamp > 60) {
                unset($this->rateLimits[$ip][$key]);
            }
        }
        
        $this->rateLimits[$ip][] = $currentTime;
    }
    
    /**
     * 检查IP是否超过请求频率限制
     */
    public function isRateLimited($ip, $limit = 100) {
        if (!isset($this->rateLimits[$ip])) {
            return false;
        }
        
        // 统计最近60秒内的请求数量
        $recentRequests = count($this->rateLimits[$ip]);
        return $recentRequests > $limit;
    }
}
```

#### 2. 应用层防护

通过在应用层实现更精细的防护机制，可以识别并阻止恶意请求：

```php
<?php
/**
 * 应用层DDoS防护类
 */
class ApplicationProtection {
    private $requestHistory = [];
    private $suspiciousPatterns = [
        '/(\b(SELECT|UNION|INSERT|UPDATE|DELETE|DROP)\b)/i',
        '/(\.\.\/){2,}/',
        '/(<script|javascript:)/i'
    ];
    
    /**
     * 检查请求是否可疑
     */
    public function isSuspiciousRequest($requestUri, $userAgent, $postData = []) {
        // 检查URI是否包含可疑模式
        foreach ($this->suspiciousPatterns as $pattern) {
            if (preg_match($pattern, $requestUri)) {
                return true;
            }
            
            if (preg_match($pattern, $userAgent)) {
                return true;
            }
            
            // 检查POST数据
            foreach ($postData as $value) {
                if (is_string($value) && preg_match($pattern, $value)) {
                    return true;
                }
            }
        }
        
        return false;
    }
    
    /**
     * 记录请求历史
     */
    public function logRequest($ip, $uri) {
        $currentTime = microtime(true);
        if (!isset($this->requestHistory[$ip])) {
            $this->requestHistory[$ip] = [];
        }
        
        // 只保留最近100条记录
        if (count($this->requestHistory[$ip]) >= 100) {
            array_shift($this->requestHistory[$ip]);
        }
        
        $this->requestHistory[$ip][] = [
            'uri' => $uri,
            'timestamp' => $currentTime
        ];
    }
    
    /**
     * 检测重复请求攻击
     */
    public function detectRepeatAttack($ip, $threshold = 5, $timeWindow = 1.0) {
        if (!isset($this->requestHistory[$ip])) {
            return false;
        }
        
        $recentRequests = array_slice($this->requestHistory[$ip], -10); // 检查最近10次请求
        
        if (count($recentRequests) < $threshold) {
            return false;
        }
        
        // 检查是否有大量相同URI的请求在短时间内发出
        $uriCount = [];
        $currentTime = microtime(true);
        
        foreach ($recentRequests as $request) {
            if ($currentTime - $request['timestamp'] <= $timeWindow) {
                $uri = $request['uri'];
                if (!isset($uriCount[$uri])) {
                    $uriCount[$uri] = 0;
                }
                $uriCount[$uri]++;
                
                if ($uriCount[$uri] >= $threshold) {
                    return true;
                }
            }
        }
        
        return false;
    }
    
    /**
     * 实施速率限制
     */
    public function rateLimit($ip, $maxRequests = 100, $timeWindow = 60) {
        if (!isset($this->requestHistory[$ip])) {
            return false;
        }
        
        $currentTime = microtime(true);
        $requestCount = 0;
        
        foreach ($this->requestHistory[$ip] as $request) {
            if ($currentTime - $request['timestamp'] <= $timeWindow) {
                $requestCount++;
            }
        }
        
        return $requestCount > $maxRequests;
    }
}
```

#### 3. 综合防护系统

结合多种防护机制构建完整的DDoS防护系统：

```php
<?php
/**
 * 综合DDoS防护系统
 */
class DDoSProtectionSystem {
    private $networkProtection;
    private $applicationProtection;
    private $config;
    
    public function __construct($config = []) {
        $this->networkProtection = new NetworkProtection();
        $this->applicationProtection = new ApplicationProtection();
        $this->config = array_merge([
            'enable_network_protection' => true,
            'enable_application_protection' => true,
            'rate_limit_threshold' => 100,
            'block_duration' => 3600, // 1小时
            'log_blocked_requests' => true
        ], $config);
    }
    
    /**
     * 处理请求并实施防护
     */
    public function protectRequest() {
        $clientIp = $this->getClientIp();
        $requestUri = $_SERVER['REQUEST_URI'] ?? '';
        $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        $postData = $_POST ?? [];
        
        // 1. 检查是否已被阻止
        if ($this->networkProtection->isBlocked($clientIp)) {
            $this->logBlockedRequest($clientIp, 'BLOCKED_IP');
            $this->respondWith403();
            return false;
        }
        
        // 2. 网络层防护
        if ($this->config['enable_network_protection']) {
            $this->networkProtection->logRequest($clientIp);
            
            // 检查速率限制
            if ($this->networkProtection->isRateLimited($clientIp, $this->config['rate_limit_threshold'])) {
                $this->networkProtection->blockIp($clientIp);
                $this->logBlockedRequest($clientIp, 'RATE_LIMIT_EXCEEDED');
                $this->respondWith403();
                return false;
            }
        }
        
        // 3. 应用层防护
        if ($this->config['enable_application_protection']) {
            $this->applicationProtection->logRequest($clientIp, $requestUri);
            
            // 检查可疑请求
            if ($this->applicationProtection->isSuspiciousRequest($requestUri, $userAgent, $postData)) {
                $this->networkProtection->blockIp($clientIp);
                $this->logBlockedRequest($clientIp, 'SUSPICIOUS_REQUEST');
                $this->respondWith403();
                return false;
            }
            
            // 检测重复请求攻击
            if ($this->applicationProtection->detectRepeatAttack($clientIp)) {
                $this->networkProtection->blockIp($clientIp);
                $this->logBlockedRequest($clientIp, 'REPEAT_ATTACK');
                $this->respondWith403();
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * 获取客户端真实IP
     */
    private function getClientIp() {
        $ipKeys = ['HTTP_X_FORWARDED_FOR', 'HTTP_X_REAL_IP', 'HTTP_CLIENT_IP', 'REMOTE_ADDR'];
        
        foreach ($ipKeys as $key) {
            if (!empty($_SERVER[$key])) {
                $ips = explode(',', $_SERVER[$key]);
                $ip = trim($ips[0]);
                if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE)) {
                    return $ip;
                }
            }
        }
        
        return $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
    }
    
    /**
     * 记录被阻止的请求
     */
    private function logBlockedRequest($ip, $reason) {
        if (!$this->config['log_blocked_requests']) {
            return;
        }
        
        $logEntry = sprintf(
            "[%s] BLOCKED REQUEST - IP: %s, Reason: %s, URI: %s, User-Agent: %s\n",
            date('Y-m-d H:i:s'),
            $ip,
            $reason,
            $_SERVER['REQUEST_URI'] ?? '',
            $_SERVER['HTTP_USER_AGENT'] ?? ''
        );
        
        file_put_contents('ddos_blocked.log', $logEntry, FILE_APPEND | LOCK_EX);
    }
    
    /**
     * 返回403响应
     */
    private function respondWith403() {
        http_response_code(403);
        header('Content-Type: text/html; charset=utf-8');
        echo '<html><body><h1>403 Forbidden</h1><p>Your request has been blocked due to security concerns.</p></body></html>';
        exit;
    }
    
    /**
     * 获取防护统计信息
     */
    public function getStats() {
        return [
            'blocked_ips' => $this->networkProtection->getBlockedIps(),
            'config' => $this->config
        ];
    }
    
    /**
     * 手动解除IP封锁
     */
    public function unblockIp($ip) {
        $this->networkProtection->unblockIp($ip);
    }
}

// 使用示例
$ddosProtection = new DDoSProtectionSystem([
    'rate_limit_threshold' => 50, // 降低阈值用于演示
    'log_blocked_requests' => true
]);

// 在应用入口处调用保护方法
if (!$ddosProtection->protectRequest()) {
    // 请求被阻止，protectRequest()已处理响应
    exit;
}

// 正常处理请求...
echo "Welcome to our secure application!";
```

### 最佳实践建议

1. **多层防护**：单一防护机制容易被绕过，应采用网络层、传输层、应用层的多层防护体系

2. **动态调整**：根据实际流量情况动态调整防护策略和阈值参数

3. **日志分析**：详细记录防护日志，定期分析攻击模式以优化防护策略

4. **第三方服务**：对于大规模攻击，可借助云服务商的专业DDoS防护服务

5. **应急预案**：制定详细的DDoS攻击应急预案，包括流量切换、服务降级等措施

6. **定期演练**：定期进行安全演练，检验防护体系的有效性

通过以上多层次的防护策略和PHP实现示例，可以有效提升系统抵御DDoS攻击的能力，保障服务的稳定运行。