# CSRF攻击的防范方法？

## 概要回答

CSRF（跨站请求伪造）攻击是指攻击者诱导用户在已登录的Web应用中执行非预期的操作。主要防范方法包括：

1. **CSRF令牌**：为每个用户会话生成唯一的令牌，并在表单和请求中验证
2. **SameSite Cookie属性**：设置Cookie的SameSite属性为Strict或Lax
3. **验证HTTP Referer头部**：检查请求来源是否合法
4. **双重Cookie模式**：使用额外的Cookie验证请求合法性
5. **自定义请求头验证**：要求特定的自定义头部字段

## 深度解析

### CSRF攻击原理

CSRF（Cross-Site Request Forgery）攻击利用用户已登录的身份，在用户不知情的情况下执行恶意操作。攻击者通过诱导用户访问恶意网站或点击恶意链接，使用户的浏览器向目标网站发送请求，由于浏览器会自动携带Cookie等认证信息，目标网站会认为这是用户的合法请求。

```php
<?php
// CSRF攻击示例场景
// 假设用户已登录银行网站bank.com
// 攻击者在恶意网站evil.com放置以下代码：

$html = '
<!-- 恶意网站 evil.com 上的CSRF攻击代码 -->
<h1>免费游戏</h1>
<p>点击下方按钮开始游戏</p>

<!-- 隐藏的表单，会向银行网站发起转账请求 -->
<form id="maliciousForm" action="https://bank.com/transfer" method="POST" style="display:none;">
    <input type="hidden" name="to_account" value="attacker_account">
    <input type="hidden" name="amount" value="1000">
    <input type="submit" value="Play Game">
</form>

<script>
// 页面加载后自动提交表单
window.onload = function() {
    document.getElementById("maliciousForm").submit();
};
</script>';

// 当用户访问恶意网站时，浏览器会自动携带bank.com的Cookie
// 银行网站收到请求后，以为是用户主动发起的转账操作
// 实际上用户并未授权此操作，资金被盗
?>
```

### CSRF令牌防护机制

CSRF令牌是最常用且有效的防护方法，通过在表单中加入随机生成的令牌来验证请求的合法性。

```php
<?php
/**
 * CSRF防护工具类
 */
class CSRFGuard {
    private static $tokenName = 'csrf_token';
    private static $tokenLength = 32;
    
    /**
     * 生成CSRF令牌
     */
    public static function generateToken() {
        if (!isset($_SESSION)) {
            session_start();
        }
        
        $token = bin2hex(random_bytes(self::$tokenLength));
        $_SESSION[self::$tokenName] = $token;
        return $token;
    }
    
    /**
     * 验证CSRF令牌
     */
    public static function validateToken($token) {
        if (!isset($_SESSION)) {
            session_start();
        }
        
        if (!isset($_SESSION[self::$tokenName])) {
            return false;
        }
        
        // 使用hash_equals防止时序攻击
        return hash_equals($_SESSION[self::$tokenName], $token);
    }
    
    /**
     * 生成隐藏的令牌输入字段
     */
    public static function getTokenField() {
        $token = self::generateToken();
        return '<input type="hidden" name="' . self::$tokenName . '" value="' . $token . '">';
    }
    
    /**
     * 验证请求中的令牌
     */
    public static function validateRequest() {
        $token = $_POST[self::$tokenName] ?? $_GET[self::$tokenName] ?? '';
        return self::validateToken($token);
    }
    
    /**
     * 清除令牌（使用后立即清除）
     */
    public static function clearToken() {
        if (isset($_SESSION[self::$tokenName])) {
            unset($_SESSION[self::$tokenName]);
        }
    }
    
    /**
     * 为AJAX请求生成令牌
     */
    public static function getAjaxToken() {
        return self::generateToken();
    }
    
    /**
     * 验证AJAX请求令牌
     */
    public static function validateAjaxRequest() {
        $token = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
        return self::validateToken($token);
    }
}

// 使用示例
// session_start();
// 
// // 在表单中使用CSRF令牌
// echo '<form method="POST" action="/transfer">';
// echo CSRFGuard::getTokenField();
// echo '<input type="text" name="amount" placeholder="金额">';
// echo '<input type="text" name="to_account" placeholder="收款账户">';
// echo '<input type="submit" value="转账">';
// echo '</form>';
// 
// // 在处理请求时验证令牌
// if ($_POST && !CSRFGuard::validateRequest()) {
//     die('CSRF攻击 detected!');
// }
?>
```

### 安全的表单实现

```php
<?php
/**
 * 安全表单构建器
 */
class SecureForm {
    private $action;
    private $method;
    private $fields = [];
    private $attributes = [];
    
    public function __construct($action = '', $method = 'POST') {
        $this->action = $action;
        $this->method = strtoupper($method);
    }
    
    /**
     * 添加输入字段
     */
    public function addInput($type, $name, $value = '', $attributes = []) {
        $this->fields[] = [
            'type' => $type,
            'name' => $name,
            'value' => $value,
            'attributes' => $attributes
        ];
        return $this;
    }
    
    /**
     * 添加CSRF令牌字段
     */
    public function addCSRFToken() {
        $token = CSRFGuard::generateToken();
        $this->fields[] = [
            'type' => 'hidden',
            'name' => 'csrf_token',
            'value' => $token,
            'attributes' => []
        ];
        return $this;
    }
    
    /**
     * 设置表单属性
     */
    public function setAttribute($name, $value) {
        $this->attributes[$name] = $value;
        return $this;
    }
    
    /**
     * 生成表单HTML
     */
    public function render() {
        $attributes = '';
        foreach ($this->attributes as $name => $value) {
            $attributes .= ' ' . $name . '="' . htmlspecialchars($value, ENT_QUOTES, 'UTF-8') . '"';
        }
        
        $html = '<form action="' . htmlspecialchars($this->action, ENT_QUOTES, 'UTF-8') . '" method="' . $this->method . '"' . $attributes . '>';
        
        foreach ($this->fields as $field) {
            $fieldAttrs = '';
            foreach ($field['attributes'] as $attrName => $attrValue) {
                $fieldAttrs .= ' ' . $attrName . '="' . htmlspecialchars($attrValue, ENT_QUOTES, 'UTF-8') . '"';
            }
            
            switch ($field['type']) {
                case 'textarea':
                    $html .= '<textarea name="' . htmlspecialchars($field['name'], ENT_QUOTES, 'UTF-8') . '"' . $fieldAttrs . '>';
                    $html .= htmlspecialchars($field['value'], ENT_QUOTES, 'UTF-8');
                    $html .= '</textarea>';
                    break;
                    
                case 'select':
                    $html .= '<select name="' . htmlspecialchars($field['name'], ENT_QUOTES, 'UTF-8') . '"' . $fieldAttrs . '>';
                    // 选项处理
                    $html .= '</select>';
                    break;
                    
                default:
                    $html .= '<input type="' . htmlspecialchars($field['type'], ENT_QUOTES, 'UTF-8') . '" ';
                    $html .= 'name="' . htmlspecialchars($field['name'], ENT_QUOTES, 'UTF-8') . '" ';
                    $html .= 'value="' . htmlspecialchars($field['value'], ENT_QUOTES, 'UTF-8') . '" ';
                    $html .= $fieldAttrs . '>';
            }
        }
        
        $html .= '</form>';
        return $html;
    }
    
    /**
     * 生成安全的AJAX表单配置
     */
    public function getAjaxConfig() {
        return [
            'action' => $this->action,
            'method' => $this->method,
            'csrf_token' => CSRFGuard::getAjaxToken()
        ];
    }
}

// 使用示例
// $form = new SecureForm('/user/update', 'POST');
// $form->addInput('text', 'username', '', ['class' => 'form-control'])
//      ->addInput('email', 'email', '', ['class' => 'form-control'])
//      ->addInput('password', 'password', '', ['class' => 'form-control'])
//      ->addCSRFToken()
//      ->setAttribute('id', 'user-form')
//      ->setAttribute('class', 'needs-validation');
// 
// echo $form->render();
?>
```

### SameSite Cookie防护

SameSite属性是现代浏览器提供的CSRF防护机制，可以有效防止跨站请求。

```php
<?php
/**
 * SameSite Cookie管理器
 */
class SameSiteCookie {
    
    /**
     * 设置SameSite Cookie
     */
    public static function setSameSiteCookie($name, $value, $expire = 0, $path = '/', $domain = '', $secure = true, $httponly = true, $samesite = 'Strict') {
        // PHP 7.3+ 支持SameSite参数
        if (version_compare(PHP_VERSION, '7.3.0') >= 0) {
            setcookie($name, $value, [
                'expires' => $expire,
                'path' => $path,
                'domain' => $domain,
                'secure' => $secure,
                'httponly' => $httponly,
                'samesite' => $samesite
            ]);
        } else {
            // 兼容旧版本PHP
            // 注意：旧版本PHP不直接支持SameSite，需要手动设置
            $sameSiteValues = ['Strict', 'Lax', 'None'];
            if (in_array($samesite, $sameSiteValues)) {
                // 设置Cookie后手动添加SameSite属性
                header('Set-Cookie: ' . $name . '=' . rawurlencode($value) . 
                       '; expires=' . gmdate('D, d-M-Y H:i:s T', $expire) . 
                       '; path=' . $path . 
                       ($domain ? '; domain=' . $domain : '') . 
                       ($secure ? '; secure' : '') . 
                       ($httponly ? '; httponly' : '') . 
                       '; SameSite=' . $samesite, false);
            } else {
                setcookie($name, $value, $expire, $path, $domain, $secure, $httponly);
            }
        }
    }
    
    /**
     * 配置会话Cookie的SameSite属性
     */
    public static function configureSessionSameSite($samesite = 'Strict') {
        session_set_cookie_params([
            'lifetime' => 0,
            'path' => '/',
            'domain' => '',
            'secure' => true,
            'httponly' => true,
            'samesite' => $samesite
        ]);
        
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
    }
    
    /**
     * 获取SameSite策略说明
     */
    public static function getSameSitePolicies() {
        return [
            'Strict' => [
                'description' => '严格模式，完全禁止跨站请求携带Cookie',
                'use_case' => '高安全性要求的网站',
                'compatibility' => '现代浏览器支持良好'
            ],
            'Lax' => [
                'description' => '宽松模式，允许部分安全的跨站请求携带Cookie',
                'use_case' => '大多数网站的推荐选择',
                'compatibility' => '广泛支持'
            ],
            'None' => [
                'description' => '无限制，跨站请求总是携带Cookie（需要Secure标志）',
                'use_case' => '需要跨站嵌入的第三方服务',
                'compatibility' => '需要Secure标志，现代浏览器支持'
            ]
        ];
    }
    
    /**
     * 检查浏览器SameSite支持
     */
    public static function checkBrowserSupport() {
        $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        
        // 简单的浏览器版本检测
        $support = [
            'Chrome' => version_compare(self::getBrowserVersion($userAgent, 'Chrome'), '51.0', '>='),
            'Firefox' => version_compare(self::getBrowserVersion($userAgent, 'Firefox'), '60.0', '>='),
            'Safari' => version_compare(self::getBrowserVersion($userAgent, 'Safari'), '12.0', '>='),
            'Edge' => version_compare(self::getBrowserVersion($userAgent, 'Edge'), '16.0', '>=')
        ];
        
        return $support;
    }
    
    private static function getBrowserVersion($userAgent, $browser) {
        if (preg_match('/' . $browser . '\/([\d.]+)/', $userAgent, $matches)) {
            return $matches[1] ?? '0.0';
        }
        return '0.0';
    }
}

// 使用示例
// SameSiteCookie::configureSessionSameSite('Lax');
// SameSiteCookie::setSameSiteCookie('user_pref', 'theme_dark', time() + 86400, '/', '', true, true, 'Lax');
?>
```

### Referer头部验证

通过验证HTTP Referer头部可以辅助防护CSRF攻击。

```php
<?php
/**
 * Referer验证工具类
 */
class RefererValidator {
    
    private $allowedDomains = [];
    private $requireReferer = false;
    
    public function __construct($allowedDomains = [], $requireReferer = false) {
        $this->allowedDomains = $allowedDomains;
        $this->requireReferer = $requireReferer;
    }
    
    /**
     * 验证Referer头部
     */
    public function validateReferer() {
        $referer = $_SERVER['HTTP_REFERER'] ?? '';
        
        // 如果要求必须有Referer但没有，则验证失败
        if ($this->requireReferer && empty($referer)) {
            return false;
        }
        
        // 如果没有Referer且不要求必须有，则验证通过
        if (empty($referer) && !$this->requireReferer) {
            return true;
        }
        
        // 解析Referer URL
        $refererHost = parse_url($referer, PHP_URL_HOST);
        if (!$refererHost) {
            return false;
        }
        
        // 如果没有设置允许的域名，则只验证是否为本站
        if (empty($this->allowedDomains)) {
            $currentHost = $_SERVER['HTTP_HOST'] ?? '';
            return $refererHost === $currentHost;
        }
        
        // 验证Referer是否在允许的域名列表中
        foreach ($this->allowedDomains as $domain) {
            if ($this->matchDomain($refererHost, $domain)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * 域名匹配
     */
    private function matchDomain($refererHost, $allowedDomain) {
        // 完全匹配
        if ($refererHost === $allowedDomain) {
            return true;
        }
        
        // 子域名匹配
        if (strpos($refererHost, '.' . $allowedDomain) !== false) {
            return true;
        }
        
        return false;
    }
    
    /**
     * 获取Referer信息
     */
    public static function getRefererInfo() {
        return [
            'referer' => $_SERVER['HTTP_REFERER'] ?? '',
            'host' => $_SERVER['HTTP_HOST'] ?? '',
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? '',
            'ip' => $_SERVER['REMOTE_ADDR'] ?? ''
        ];
    }
    
    /**
     * 记录可疑的Referer
     */
    public static function logSuspiciousReferer($reason = '') {
        $info = self::getRefererInfo();
        $info['reason'] = $reason;
        $info['timestamp'] = date('Y-m-d H:i:s');
        
        error_log("Suspicious Referer: " . json_encode($info));
    }
    
    /**
     * 综合CSRF验证
     */
    public static function comprehensiveCSRFValidation($allowedDomains = []) {
        $validator = new self($allowedDomains);
        
        // 1. 首先验证CSRF令牌（如果存在）
        if (isset($_POST['csrf_token']) || isset($_GET['csrf_token']) || isset($_SERVER['HTTP_X_CSRF_TOKEN'])) {
            if (!CSRFGuard::validateRequest() && !CSRFGuard::validateAjaxRequest()) {
                self::logSuspiciousReferer('CSRF token validation failed');
                return false;
            }
            return true;
        }
        
        // 2. 如果没有令牌，则验证Referer
        if (!$validator->validateReferer()) {
            self::logSuspiciousReferer('Referer validation failed');
            return false;
        }
        
        return true;
    }
}

// 使用示例
// $allowedDomains = ['mysite.com', 'www.mysite.com'];
// $validator = new RefererValidator($allowedDomains, true);
// 
// if (!$validator->validateReferer()) {
//     http_response_code(403);
//     die('Forbidden: Invalid referer');
// }
?>
```

### 双重Cookie模式

双重Cookie模式是一种CSRF防护方法，通过在请求中同时验证两个Cookie来确认请求的合法性。

```php
<?php
/**
 * 双重Cookie模式防护
 */
class DoubleCookiePattern {
    private static $cookieName = 'csrf_double_submit';
    private static $tokenLength = 32;
    
    /**
     * 生成双重提交Cookie
     */
    public static function generateDoubleSubmitCookie() {
        $token = bin2hex(random_bytes(self::$tokenLength));
        
        // 设置双重提交Cookie
        setcookie(
            self::$cookieName, 
            $token, 
            time() + 3600, // 1小时过期
            '/', 
            '', 
            true,  // Secure
            true   // HttpOnly
        );
        
        return $token;
    }
    
    /**
     * 验证双重提交Cookie
     */
    public static function validateDoubleSubmit() {
        $cookieToken = $_COOKIE[self::$cookieName] ?? '';
        $requestToken = $_POST[self::$cookieName] ?? $_GET[self::$cookieName] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
        
        if (empty($cookieToken) || empty($requestToken)) {
            return false;
        }
        
        return hash_equals($cookieToken, $requestToken);
    }
    
    /**
     * 在表单中添加双重提交字段
     */
    public static function getDoubleSubmitField() {
        $token = self::generateDoubleSubmitCookie();
        return '<input type="hidden" name="' . self::$cookieName . '" value="' . $token . '">';
    }
    
    /**
     * AJAX请求的双重提交验证
     */
    public static function validateAjaxDoubleSubmit() {
        return self::validateDoubleSubmit();
    }
    
    /**
     * 清除双重提交Cookie
     */
    public static function clearDoubleSubmitCookie() {
        setcookie(self::$cookieName, '', time() - 3600, '/', '', true, true);
    }
}

// 使用示例
// // 在表单中使用双重提交Cookie
// echo '<form method="POST" action="/transfer">';
// echo DoubleCookiePattern::getDoubleSubmitField();
// echo '<input type="text" name="amount" placeholder="金额">';
// echo '<input type="submit" value="转账">';
// echo '</form>';
// 
// // 验证请求
// if (!DoubleCookiePattern::validateDoubleSubmit()) {
//     die('CSRF attack detected!');
// }
?>
```

### 自定义请求头验证

通过要求特定的自定义请求头来验证请求的合法性。

```php
<?php
/**
 * 自定义请求头验证
 */
class CustomHeaderValidator {
    private static $requiredHeaders = [
        'X-Requested-With' => 'XMLHttpRequest',
        'X-CSRF-Token' => null // 动态验证
    ];
    
    /**
     * 验证自定义请求头
     */
    public static function validateCustomHeaders() {
        foreach (self::$requiredHeaders as $header => $expectedValue) {
            $actualValue = $_SERVER['HTTP_' . str_replace('-', '_', strtoupper($header))] ?? '';
            
            if (empty($actualValue)) {
                return false;
            }
            
            if ($expectedValue !== null && $actualValue !== $expectedValue) {
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * 验证特定的CSRF头部
     */
    public static function validateCSRFHeader() {
        $csrfToken = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
        return CSRFGuard::validateToken($csrfToken);
    }
    
    /**
     * 验证AJAX请求
     */
    public static function validateAjaxRequest() {
        // 验证X-Requested-With头部
        $requestedWith = $_SERVER['HTTP_X_REQUESTED_WITH'] ?? '';
        if (strtolower($requestedWith) !== 'xmlhttprequest') {
            return false;
        }
        
        // 验证CSRF令牌
        return self::validateCSRFHeader();
    }
    
    /**
     * 生成AJAX请求的JavaScript代码
     */
    public static function getAjaxSetupCode() {
        $csrfToken = CSRFGuard::getAjaxToken();
        
        return "
<script>
// 设置AJAX请求默认头部
$.ajaxSetup({
    beforeSend: function(xhr) {
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        xhr.setRequestHeader('X-CSRF-Token', '$csrfToken');
    }
});

// 或者使用fetch API
function secureFetch(url, options = {}) {
    options.headers = options.headers || {};
    options.headers['X-Requested-With'] = 'XMLHttpRequest';
    options.headers['X-CSRF-Token'] = '$csrfToken';
    
    return fetch(url, options);
}
</script>";
    }
    
    /**
     * 中间件风格的验证
     */
    public static function middleware() {
        return function() {
            // 对于AJAX请求，验证自定义头部
            if (!empty($_SERVER['HTTP_X_REQUESTED_WITH'])) {
                if (!self::validateAjaxRequest()) {
                    http_response_code(403);
                    echo json_encode(['error' => 'Invalid CSRF token']);
                    exit;
                }
                return true;
            }
            
            // 对于普通表单请求，验证CSRF令牌
            if ($_POST && !CSRFGuard::validateRequest()) {
                http_response_code(403);
                echo 'CSRF attack detected!';
                exit;
            }
            
            return true;
        };
    }
}

// 使用示例
// // 在页面中包含AJAX设置代码
// echo CustomHeaderValidator::getAjaxSetupCode();
// 
// // 在API端点验证请求
// CustomHeaderValidator::middleware()();
?>
```

### CSRF防护综合实现

```php
<?php
/**
 * 综合CSRF防护系统
 */
class ComprehensiveCSRFProtection {
    private $config = [
        'use_csrf_tokens' => true,
        'use_samesite_cookies' => true,
        'validate_referer' => false,
        'use_double_submit' => false,
        'require_custom_headers' => false,
        'token_regeneration_interval' => 3600 // 1小时
    ];
    
    public function __construct($config = []) {
        $this->config = array_merge($this->config, $config);
    }
    
    /**
     * 初始化CSRF防护
     */
    public function initialize() {
        if (!isset($_SESSION)) {
            session_start();
        }
        
        // 配置SameSite Cookie
        if ($this->config['use_samesite_cookies']) {
            SameSiteCookie::configureSessionSameSite('Lax');
        }
        
        // 生成CSRF令牌
        if ($this->config['use_csrf_tokens']) {
            CSRFGuard::generateToken();
        }
    }
    
    /**
     * 验证请求
     */
    public function validateRequest() {
        // 记录验证开始时间
        $startTime = microtime(true);
        
        // 1. CSRF令牌验证
        if ($this->config['use_csrf_tokens']) {
            if (!CSRFGuard::validateRequest() && !CSRFGuard::validateAjaxRequest()) {
                $this->logValidationFailure('CSRF token validation failed', $startTime);
                return false;
            }
        }
        
        // 2. Referer验证
        if ($this->config['validate_referer']) {
            $refererValidator = new RefererValidator([], true);
            if (!$refererValidator->validateReferer()) {
                $this->logValidationFailure('Referer validation failed', $startTime);
                return false;
            }
        }
        
        // 3. 双重提交Cookie验证
        if ($this->config['use_double_submit']) {
            if (!DoubleCookiePattern::validateDoubleSubmit()) {
                $this->logValidationFailure('Double submit cookie validation failed', $startTime);
                return false;
            }
        }
        
        // 4. 自定义头部验证
        if ($this->config['require_custom_headers']) {
            if (!CustomHeaderValidator::validateCustomHeaders()) {
                $this->logValidationFailure('Custom header validation failed', $startTime);
                return false;
            }
        }
        
        // 记录验证成功
        $this->logValidationSuccess($startTime);
        return true;
    }
    
    /**
     * 记录验证失败
     */
    private function logValidationFailure($reason, $startTime) {
        $duration = (microtime(true) - $startTime) * 1000; // 转换为毫秒
        
        $logData = [
            'timestamp' => date('Y-m-d H:i:s'),
            'ip' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown',
            'method' => $_SERVER['REQUEST_METHOD'] ?? 'unknown',
            'uri' => $_SERVER['REQUEST_URI'] ?? 'unknown',
            'reason' => $reason,
            'duration_ms' => round($duration, 2)
        ];
        
        error_log("CSRF Validation Failed: " . json_encode($logData));
    }
    
    /**
     * 记录验证成功
     */
    private function logValidationSuccess($startTime) {
        $duration = (microtime(true) - $startTime) * 1000; // 转换为毫秒
        
        if ($duration > 100) { // 如果验证时间超过100ms，记录警告
            error_log("CSRF Validation Slow: " . round($duration, 2) . "ms");
        }
    }
    
    /**
     * 获取CSRF防护状态
     */
    public function getProtectionStatus() {
        return [
            'csrf_tokens_enabled' => $this->config['use_csrf_tokens'],
            'samesite_cookies_enabled' => $this->config['use_samesite_cookies'],
            'referer_validation_enabled' => $this->config['validate_referer'],
            'double_submit_enabled' => $this->config['use_double_submit'],
            'custom_headers_required' => $this->config['require_custom_headers'],
            'token_regenerated_at' => $_SESSION['csrf_token_generated'] ?? null,
            'current_token' => $_SESSION['csrf_token'] ?? null
        ];
    }
    
    /**
     * 清理过期的令牌
     */
    public function cleanupExpiredTokens() {
        if (isset($_SESSION['csrf_token_generated'])) {
            $generatedTime = $_SESSION['csrf_token_generated'];
            if (time() - $generatedTime > $this->config['token_regeneration_interval']) {
                CSRFGuard::generateToken();
                $_SESSION['csrf_token_generated'] = time();
            }
        } else {
            $_SESSION['csrf_token_generated'] = time();
        }
    }
    
    /**
     * 获取防护统计信息
     */
    public static function getStatistics() {
        // 这里可以从日志或数据库中获取统计数据
        return [
            'total_validations' => 1000,
            'failed_validations' => 5,
            'success_rate' => 99.5,
            'average_validation_time' => '2.3ms',
            'most_common_failure_reason' => 'Missing CSRF token'
        ];
    }
}

// 使用示例
// $csrfProtection = new ComprehensiveCSRFProtection([
//     'use_csrf_tokens' => true,
//     'use_samesite_cookies' => true,
//     'validate_referer' => true
// ]);
// 
// $csrfProtection->initialize();
// 
// // 在处理请求前验证
// if ($_POST && !$csrfProtection->validateRequest()) {
//     http_response_code(403);
//     die('Forbidden: CSRF validation failed');
// }
?>
```

### CSRF防护最佳实践

1. **使用CSRF令牌**：为每个用户会话生成唯一的令牌并在表单中包含
2. **设置SameSite Cookie**：使用SameSite=Strict或Lax属性
3. **验证Referer头部**：检查请求来源的合法性
4. **实施多重防护**：结合多种防护机制提高安全性
5. **定期更新令牌**：避免令牌长时间有效带来的风险
6. **安全的错误处理**：不要向攻击者透露验证失败的具体原因
7. **监控和日志**：记录可疑的CSRF尝试以便分析
8. **用户教育**：提醒用户不要随意点击不明链接

### 总结

CSRF攻击是一种严重的安全威胁，但通过实施CSRF令牌、SameSite Cookie、Referer验证等多种防护措施，可以有效降低风险。最重要的是要在应用的各个层面都考虑到CSRF防护，并建立完善的监控和响应机制。开发人员应该深入了解CSRF攻击的原理，并在实际开发中严格执行安全编码规范。