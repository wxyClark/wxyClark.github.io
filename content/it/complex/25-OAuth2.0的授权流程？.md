# OAuth2.0的授权流程？

## 概要回答

OAuth2.0是一个开放标准的授权框架，允许第三方应用在用户授权的情况下访问用户资源。主要授权流程包括：

1. **授权码模式（Authorization Code）**：最安全的模式，适用于有后端的服务
2. **隐式模式（Implicit）**：适用于纯前端应用，直接返回访问令牌
3. **密码模式（Resource Owner Password Credentials）**：用户直接提供凭证给客户端
4. **客户端凭证模式（Client Credentials）**：客户端以自己的名义访问资源

## 深度解析

### OAuth2.0基本概念

OAuth2.0是一个授权框架，不是认证协议。它允许第三方应用在获得用户授权后访问用户在资源服务器上的资源，而无需用户提供密码。

```php
<?php
/**
 * OAuth2.0基本概念演示
 */
class OAuth2Basics {
    
    /**
     * OAuth2.0角色说明
     */
    public static function oauthRoles() {
        return [
            'Resource Owner' => '资源所有者（用户）',
            'Client' => '第三方应用',
            'Authorization Server' => '授权服务器',
            'Resource Server' => '资源服务器'
        ];
    }
    
    /**
     * OAuth2.0令牌类型
     */
    public static function tokenTypes() {
        return [
            'access_token' => [
                'description' => '访问令牌，用于访问受保护资源',
                'lifetime' => '通常较短（1小时左右）',
                'scope' => '限定访问范围'
            ],
            'refresh_token' => [
                'description' => '刷新令牌，用于获取新的访问令牌',
                'lifetime' => '通常较长（几天到几个月）',
                'scope' => '可用于获取相同或更小权限的访问令牌'
            ],
            'authorization_code' => [
                'description' => '授权码，用于换取访问令牌',
                'lifetime' => '很短（几分钟）',
                'scope' => '一次性使用'
            ]
        ];
    }
    
    /**
     * OAuth2.0授权范围（Scope）
     */
    public static function commonScopes() {
        return [
            'read' => '只读权限',
            'write' => '写入权限',
            'profile' => '用户基本信息',
            'email' => '用户邮箱',
            'openid' => 'OpenID Connect身份认证'
        ];
    }
    
    /**
     * OAuth2.0错误响应
     */
    public static function errorResponses() {
        return [
            'invalid_request' => '请求缺少必要参数或参数无效',
            'unauthorized_client' => '客户端未被授权使用此方法',
            'access_denied' => '资源所有者或授权服务器拒绝请求',
            'unsupported_response_type' => '授权服务器不支持此响应类型',
            'invalid_scope' => '请求的scope无效、未知或格式错误',
            'server_error' => '授权服务器遇到意外情况',
            'temporarily_unavailable' => '授权服务器暂时无法处理请求'
        ];
    }
}

// OAuth2.0流程概述
// 1. 用户访问第三方应用
// 2. 第三方应用重定向用户到授权服务器
// 3. 用户在授权服务器上授权
// 4. 授权服务器重定向用户回到第三方应用（带授权码）
// 5. 第三方应用使用授权码向授权服务器请求访问令牌
// 6. 授权服务器返回访问令牌
// 7. 第三方应用使用访问令牌访问资源服务器
?>
```

### 授权码模式实现

授权码模式是最安全和最常用的OAuth2.0授权流程，特别适用于有后端的Web应用。

```php
<?php
/**
 * OAuth2.0授权码模式实现
 */
class AuthorizationCodeFlow {
    private $clientId;
    private $clientSecret;
    private $redirectUri;
    private $authorizationEndpoint;
    private $tokenEndpoint;
    
    public function __construct($config) {
        $this->clientId = $config['client_id'];
        $this->clientSecret = $config['client_secret'];
        $this->redirectUri = $config['redirect_uri'];
        $this->authorizationEndpoint = $config['authorization_endpoint'];
        $this->tokenEndpoint = $config['token_endpoint'];
    }
    
    /**
     * 生成授权URL
     */
    public function getAuthorizationUrl($scope = '', $state = null) {
        if ($state === null) {
            $state = bin2hex(random_bytes(16));
        }
        
        $params = [
            'response_type' => 'code',
            'client_id' => $this->clientId,
            'redirect_uri' => $this->redirectUri,
            'scope' => $scope,
            'state' => $state
        ];
        
        return $this->authorizationEndpoint . '?' . http_build_query($params);
    }
    
    /**
     * 处理授权回调
     */
    public function handleCallback($getCode = null, $getState = null) {
        $code = $getCode ?? $_GET['code'] ?? null;
        $state = $getState ?? $_GET['state'] ?? null;
        
        // 验证state参数（防止CSRF攻击）
        if (!$this->validateState($state)) {
            throw new Exception('Invalid state parameter');
        }
        
        if (!$code) {
            throw new Exception('Authorization code not provided');
        }
        
        // 使用授权码交换访问令牌
        return $this->exchangeCodeForToken($code);
    }
    
    /**
     * 使用授权码交换访问令牌
     */
    private function exchangeCodeForToken($code) {
        $params = [
            'grant_type' => 'authorization_code',
            'client_id' => $this->clientId,
            'client_secret' => $this->clientSecret,
            'redirect_uri' => $this->redirectUri,
            'code' => $code
        ];
        
        $response = $this->makeTokenRequest($params);
        
        if (isset($response['error'])) {
            throw new Exception('Token exchange failed: ' . $response['error_description'] ?? $response['error']);
        }
        
        return $response;
    }
    
    /**
     * 刷新访问令牌
     */
    public function refreshAccessToken($refreshToken) {
        $params = [
            'grant_type' => 'refresh_token',
            'client_id' => $this->clientId,
            'client_secret' => $this->clientSecret,
            'refresh_token' => $refreshToken
        ];
        
        $response = $this->makeTokenRequest($params);
        
        if (isset($response['error'])) {
            throw new Exception('Token refresh failed: ' . $response['error_description'] ?? $response['error']);
        }
        
        return $response;
    }
    
    /**
     * 发送令牌请求
     */
    private function makeTokenRequest($params) {
        $context = stream_context_create([
            'http' => [
                'method' => 'POST',
                'header' => [
                    'Content-Type: application/x-www-form-urlencoded',
                    'Accept: application/json'
                ],
                'content' => http_build_query($params),
                'timeout' => 30
            ]
        ]);
        
        $response = file_get_contents($this->tokenEndpoint, false, $context);
        
        if ($response === false) {
            throw new Exception('Failed to connect to token endpoint');
        }
        
        return json_decode($response, true);
    }
    
    /**
     * 验证state参数
     */
    private function validateState($state) {
        // 在实际应用中，应该将state存储在会话中进行验证
        if (!isset($_SESSION['oauth_state'])) {
            return false;
        }
        
        return hash_equals($_SESSION['oauth_state'], $state);
    }
    
    /**
     * 存储state参数
     */
    public function storeState($state) {
        $_SESSION['oauth_state'] = $state;
    }
    
    /**
     * 使用访问令牌访问受保护资源
     */
    public function makeApiRequest($url, $accessToken, $method = 'GET', $data = null) {
        $headers = [
            'Authorization: Bearer ' . $accessToken,
            'Accept: application/json'
        ];
        
        if ($method === 'POST' || $method === 'PUT') {
            $headers[] = 'Content-Type: application/json';
        }
        
        $contextOptions = [
            'http' => [
                'method' => $method,
                'header' => implode("\r\n", $headers),
                'timeout' => 30
            ]
        ];
        
        if ($data) {
            $contextOptions['http']['content'] = json_encode($data);
        }
        
        $context = stream_context_create($contextOptions);
        $response = file_get_contents($url, false, $context);
        
        if ($response === false) {
            throw new Exception('API request failed');
        }
        
        return json_decode($response, true);
    }
}

// 使用示例
// session_start();
// 
// $oauth = new AuthorizationCodeFlow([
//     'client_id' => 'your_client_id',
//     'client_secret' => 'your_client_secret',
//     'redirect_uri' => 'http://localhost/callback',
//     'authorization_endpoint' => 'https://provider.com/oauth/authorize',
//     'token_endpoint' => 'https://provider.com/oauth/token'
// ]);
// 
// // 1. 重定向用户到授权页面
// $authUrl = $oauth->getAuthorizationUrl('read write');
// $oauth->storeState($_GET['state'] ?? null);
// header('Location: ' . $authUrl);
// 
// // 2. 处理回调
// try {
//     $tokens = $oauth->handleCallback();
//     $accessToken = $tokens['access_token'];
//     
//     // 3. 使用访问令牌访问API
//     $userData = $oauth->makeApiRequest('https://api.provider.com/user', $accessToken);
// } catch (Exception $e) {
//     echo "Error: " . $e->getMessage();
// }
?>
```

### 隐式模式实现

隐式模式适用于纯前端应用，如单页应用(SPA)，不经过后端直接获取访问令牌。

```php
<?php
/**
 * OAuth2.0隐式模式实现
 */
class ImplicitFlow {
    private $clientId;
    private $redirectUri;
    private $authorizationEndpoint;
    
    public function __construct($config) {
        $this->clientId = $config['client_id'];
        $this->redirectUri = $config['redirect_uri'];
        $this->authorizationEndpoint = $config['authorization_endpoint'];
    }
    
    /**
     * 生成隐式授权URL
     */
    public function getImplicitAuthorizationUrl($scope = '', $state = null) {
        if ($state === null) {
            $state = bin2hex(random_bytes(16));
        }
        
        $params = [
            'response_type' => 'token',
            'client_id' => $this->clientId,
            'redirect_uri' => $this->redirectUri,
            'scope' => $scope,
            'state' => $state
        ];
        
        return $this->authorizationEndpoint . '?' . http_build_query($params);
    }
    
    /**
     * 处理隐式回调（前端JavaScript处理）
     */
    public static function getImplicitCallbackHandler() {
        return '
<script>
// 隐式模式回调处理
function handleImplicitCallback() {
    // 从URL片段中提取访问令牌
    var fragment = window.location.hash.substring(1);
    var params = new URLSearchParams(fragment);
    
    var accessToken = params.get("access_token");
    var tokenType = params.get("token_type");
    var expiresIn = params.get("expires_in");
    var state = params.get("state");
    
    if (accessToken) {
        // 验证state参数
        if (state !== sessionStorage.getItem("oauth_state")) {
            console.error("Invalid state parameter");
            return;
        }
        
        // 存储访问令牌
        localStorage.setItem("access_token", accessToken);
        localStorage.setItem("token_expiry", Date.now() + (expiresIn * 1000));
        
        // 清理URL中的令牌信息
        window.history.replaceState({}, document.title, window.location.pathname);
        
        console.log("Access token received and stored");
    } else {
        console.error("No access token found in callback");
    }
}

// 页面加载时处理回调
window.addEventListener("load", handleImplicitCallback);
</script>';
    }
    
    /**
     * 检查令牌是否有效
     */
    public static function isTokenValid() {
        $expiry = $_SESSION['token_expiry'] ?? 0;
        return time() < $expiry;
    }
    
    /**
     * 获取存储的访问令牌
     */
    public static function getStoredAccessToken() {
        return $_SESSION['access_token'] ?? null;
    }
}

// 前端使用示例
// $implicit = new ImplicitFlow([
//     'client_id' => 'your_client_id',
//     'redirect_uri' => 'http://localhost/callback',
//     'authorization_endpoint' => 'https://provider.com/oauth/authorize'
// ]);
// 
// // 生成授权URL
// $authUrl = $implicit->getImplicitAuthorizationUrl('read');
// echo '<a href="' . $authUrl . '">Login with Provider</a>';
// 
// // 在回调页面包含处理脚本
// echo ImplicitFlow::getImplicitCallbackHandler();
?>
```

### 密码模式实现

密码模式允许用户直接向客户端提供用户名和密码，客户端使用这些凭据获取访问令牌。

```php
<?php
/**
 * OAuth2.0密码模式实现
 */
class PasswordFlow {
    private $clientId;
    private $clientSecret;
    private $tokenEndpoint;
    
    public function __construct($config) {
        $this->clientId = $config['client_id'];
        $this->clientSecret = $config['client_secret'];
        $this->tokenEndpoint = $config['token_endpoint'];
    }
    
    /**
     * 使用用户名和密码获取访问令牌
     */
    public function getPasswordToken($username, $password, $scope = '') {
        $params = [
            'grant_type' => 'password',
            'client_id' => $this->clientId,
            'client_secret' => $this->clientSecret,
            'username' => $username,
            'password' => $password,
            'scope' => $scope
        ];
        
        return $this->makeTokenRequest($params);
    }
    
    /**
     * 发送令牌请求
     */
    private function makeTokenRequest($params) {
        // 注意：密码模式应该通过HTTPS传输，并且只在可信的客户端中使用
        
        $context = stream_context_create([
            'http' => [
                'method' => 'POST',
                'header' => [
                    'Content-Type: application/x-www-form-urlencoded',
                    'Accept: application/json'
                ],
                'content' => http_build_query($params),
                'timeout' => 30
            ]
        ]);
        
        $response = file_get_contents($this->tokenEndpoint, false, $context);
        
        if ($response === false) {
            throw new Exception('Failed to connect to token endpoint');
        }
        
        return json_decode($response, true);
    }
    
    /**
     * 安全的密码输入处理
     */
    public static function handlePasswordInput() {
        // 在实际应用中，应该通过HTTPS表单提交
        // 并且不应该在日志或错误信息中暴露密码
        
        $username = $_POST['username'] ?? '';
        $password = $_POST['password'] ?? '';
        
        // 清理输入
        $username = trim($username);
        
        // 验证输入
        if (empty($username) || empty($password)) {
            throw new Exception('Username and password are required');
        }
        
        return [$username, $password];
    }
}

// 使用示例（仅用于可信客户端）
// $passwordFlow = new PasswordFlow([
//     'client_id' => 'your_client_id',
//     'client_secret' => 'your_client_secret',
//     'token_endpoint' => 'https://provider.com/oauth/token'
// ]);
// 
// try {
//     list($username, $password) = PasswordFlow::handlePasswordInput();
//     $tokens = $passwordFlow->getPasswordToken($username, $password, 'read write');
//     
//     if (isset($tokens['access_token'])) {
//         echo "Access token: " . $tokens['access_token'];
//     } else {
//         echo "Error: " . $tokens['error_description'] ?? 'Unknown error';
//     }
// } catch (Exception $e) {
//     echo "Error: " . $e->getMessage();
// }
?>
```

### 客户端凭证模式实现

客户端凭证模式用于客户端以自己的名义（而不是以用户名义）访问受保护资源。

```php
<?php
/**
 * OAuth2.0客户端凭证模式实现
 */
class ClientCredentialsFlow {
    private $clientId;
    private $clientSecret;
    private $tokenEndpoint;
    
    public function __construct($config) {
        $this->clientId = $config['client_id'];
        $this->clientSecret = $config['client_secret'];
        $this->tokenEndpoint = $config['token_endpoint'];
    }
    
    /**
     * 获取客户端凭证令牌
     */
    public function getClientCredentialsToken($scope = '') {
        $params = [
            'grant_type' => 'client_credentials',
            'client_id' => $this->clientId,
            'client_secret' => $this->clientSecret,
            'scope' => $scope
        ];
        
        return $this->makeTokenRequest($params);
    }
    
    /**
     * 发送令牌请求
     */
    private function makeTokenRequest($params) {
        $context = stream_context_create([
            'http' => [
                'method' => 'POST',
                'header' => [
                    'Content-Type: application/x-www-form-urlencoded',
                    'Accept: application/json'
                ],
                'content' => http_build_query($params),
                'timeout' => 30
            ]
        ]);
        
        $response = file_get_contents($this->tokenEndpoint, false, $context);
        
        if ($response === false) {
            throw new Exception('Failed to connect to token endpoint');
        }
        
        return json_decode($response, true);
    }
    
    /**
     * 使用客户端凭证访问API
     */
    public function makeApiClientRequest($url, $method = 'GET', $data = null) {
        // 首先获取客户端凭证令牌
        $tokens = $this->getClientCredentialsToken();
        
        if (!isset($tokens['access_token'])) {
            throw new Exception('Failed to obtain client credentials token');
        }
        
        $accessToken = $tokens['access_token'];
        
        // 使用令牌访问API
        $headers = [
            'Authorization: Bearer ' . $accessToken,
            'Accept: application/json'
        ];
        
        if ($method === 'POST' || $method === 'PUT') {
            $headers[] = 'Content-Type: application/json';
        }
        
        $contextOptions = [
            'http' => [
                'method' => $method,
                'header' => implode("\r\n", $headers),
                'timeout' => 30
            ]
        ];
        
        if ($data) {
            $contextOptions['http']['content'] = json_encode($data);
        }
        
        $context = stream_context_create($contextOptions);
        $response = file_get_contents($url, false, $context);
        
        if ($response === false) {
            throw new Exception('API request failed');
        }
        
        return json_decode($response, true);
    }
}

// 使用示例
// $clientCredentials = new ClientCredentialsFlow([
//     'client_id' => 'your_client_id',
//     'client_secret' => 'your_client_secret',
//     'token_endpoint' => 'https://provider.com/oauth/token'
// ]);
// 
// try {
//     // 获取客户端凭证令牌
//     $tokens = $clientCredentials->getClientCredentialsToken('read');
//     
//     if (isset($tokens['access_token'])) {
//         echo "Client credentials token: " . $tokens['access_token'];
//         
//         // 使用令牌访问API
//         $data = $clientCredentials->makeApiClientRequest('https://api.provider.com/data');
//         print_r($data);
//     } else {
//         echo "Error: " . $tokens['error_description'] ?? 'Unknown error';
//     }
// } catch (Exception $e) {
//     echo "Error: " . $e->getMessage();
// }
?>
```

### OAuth2.0服务端实现

```php
<?php
/**
 * OAuth2.0服务端核心实现
 */
class OAuth2Server {
    private $clients = [];
    private $authCodes = [];
    private $accessTokens = [];
    private $refreshTokens = [];
    
    /**
     * 注册客户端
     */
    public function registerClient($clientId, $clientSecret, $redirectUris = [], $scopes = []) {
        $this->clients[$clientId] = [
            'secret' => $clientSecret,
            'redirect_uris' => $redirectUris,
            'scopes' => $scopes
        ];
    }
    
    /**
     * 验证客户端
     */
    public function validateClient($clientId, $clientSecret) {
        if (!isset($this->clients[$clientId])) {
            return false;
        }
        
        return hash_equals($this->clients[$clientId]['secret'], $clientSecret);
    }
    
    /**
     * 验证重定向URI
     */
    public function validateRedirectUri($clientId, $redirectUri) {
        if (!isset($this->clients[$clientId])) {
            return false;
        }
        
        return in_array($redirectUri, $this->clients[$clientId]['redirect_uris']);
    }
    
    /**
     * 生成授权码
     */
    public function generateAuthorizationCode($clientId, $userId, $redirectUri, $scope, $expiresIn = 600) {
        $code = bin2hex(random_bytes(32));
        
        $this->authCodes[$code] = [
            'client_id' => $clientId,
            'user_id' => $userId,
            'redirect_uri' => $redirectUri,
            'scope' => $scope,
            'expires_at' => time() + $expiresIn
        ];
        
        return $code;
    }
    
    /**
     * 验证授权码
     */
    public function validateAuthorizationCode($code, $clientId, $redirectUri) {
        if (!isset($this->authCodes[$code])) {
            return false;
        }
        
        $authCode = $this->authCodes[$code];
        
        // 检查是否过期
        if (time() > $authCode['expires_at']) {
            unset($this->authCodes[$code]);
            return false;
        }
        
        // 验证客户端ID和重定向URI
        if ($authCode['client_id'] !== $clientId || $authCode['redirect_uri'] !== $redirectUri) {
            return false;
        }
        
        return $authCode;
    }
    
    /**
     * 生成访问令牌
     */
    public function generateAccessToken($clientId, $userId, $scope, $expiresIn = 3600) {
        $accessToken = bin2hex(random_bytes(32));
        
        $this->accessTokens[$accessToken] = [
            'client_id' => $clientId,
            'user_id' => $userId,
            'scope' => $scope,
            'expires_at' => time() + $expiresIn
        ];
        
        return $accessToken;
    }
    
    /**
     * 生成刷新令牌
     */
    public function generateRefreshToken($clientId, $userId, $scope, $expiresIn = 86400) {
        $refreshToken = bin2hex(random_bytes(32));
        
        $this->refreshTokens[$refreshToken] = [
            'client_id' => $clientId,
            'user_id' => $userId,
            'scope' => $scope,
            'expires_at' => time() + $expiresIn
        ];
        
        return $refreshToken;
    }
    
    /**
     * 验证访问令牌
     */
    public function validateAccessToken($accessToken) {
        if (!isset($this->accessTokens[$accessToken])) {
            return false;
        }
        
        $token = $this->accessTokens[$accessToken];
        
        // 检查是否过期
        if (time() > $token['expires_at']) {
            unset($this->accessTokens[$accessToken]);
            return false;
        }
        
        return $token;
    }
    
    /**
     * 使用刷新令牌获取新访问令牌
     */
    public function refreshAccessToken($refreshToken) {
        if (!isset($this->refreshTokens[$refreshToken])) {
            return false;
        }
        
        $refreshTokenData = $this->refreshTokens[$refreshToken];
        
        // 检查刷新令牌是否过期
        if (time() > $refreshTokenData['expires_at']) {
            unset($this->refreshTokens[$refreshToken]);
            return false;
        }
        
        // 生成新的访问令牌
        $newAccessToken = $this->generateAccessToken(
            $refreshTokenData['client_id'],
            $refreshTokenData['user_id'],
            $refreshTokenData['scope']
        );
        
        // 生成新的刷新令牌（可选）
        $newRefreshToken = $this->generateRefreshToken(
            $refreshTokenData['client_id'],
            $refreshTokenData['user_id'],
            $refreshTokenData['scope']
        );
        
        return [
            'access_token' => $newAccessToken,
            'refresh_token' => $newRefreshToken,
            'expires_in' => 3600,
            'token_type' => 'Bearer'
        ];
    }
    
    /**
     * 撤销令牌
     */
    public function revokeToken($token) {
        unset($this->accessTokens[$token]);
        unset($this->refreshTokens[$token]);
        unset($this->authCodes[$token]);
    }
    
    /**
     * 获取客户端信息
     */
    public function getClientInfo($clientId) {
        return $this->clients[$clientId] ?? null;
    }
}

// 使用示例
// $oauthServer = new OAuth2Server();
// 
// // 注册客户端
// $oauthServer->registerClient(
//     'web_app',
//     'client_secret_123',
//     ['http://localhost/callback'],
//     ['read', 'write']
// );
// 
// // 验证客户端
// if ($oauthServer->validateClient('web_app', 'client_secret_123')) {
//     echo "Client validated successfully";
// }
?>
```

### OAuth2.0安全最佳实践

```php
<?php
/**
 * OAuth2.0安全最佳实践
 */
class OAuth2Security {
    
    /**
     * 安全配置建议
     */
    public static function getSecurityRecommendations() {
        return [
            'client_authentication' => [
                'description' => '客户端认证',
                'recommendations' => [
                    '使用PKCE扩展增强授权码模式安全性',
                    '对机密客户端使用客户端密钥认证',
                    '对公共客户端使用其他认证机制'
                ]
            ],
            'token_security' => [
                'description' => '令牌安全',
                'recommendations' => [
                    '设置适当的令牌过期时间',
                    '实现令牌刷新机制',
                    '使用HTTPS传输所有令牌',
                    '避免在URL中传递令牌'
                ]
            ],
            'redirect_uri_security' => [
                'description' => '重定向URI安全',
                'recommendations' => [
                    '精确匹配重定向URI',
                    '避免使用通配符',
                    '验证所有重定向URI'
                ]
            ],
            'scope_management' => [
                'description' => '范围管理',
                'recommendations' => [
                    '实施最小权限原则',
                    '明确界定每个范围的权限',
                    '定期审查和更新范围'
                ]
            ]
        ];
    }
    
    /**
     * PKCE（Proof Key for Code Exchange）实现
     */
    public static function pkceExample() {
        // 生成code_verifier
        $codeVerifier = bin2hex(random_bytes(32));
        
        // 生成code_challenge
        $codeChallenge = rtrim(strtr(base64_encode(hash('sha256', $codeVerifier, true)), '+/', '-_'), '=');
        
        return [
            'code_verifier' => $codeVerifier,
            'code_challenge' => $codeChallenge,
            'code_challenge_method' => 'S256'
        ];
    }
    
    /**
     * 令牌存储安全
     */
    public static function secureTokenStorage() {
        return '
// 安全的令牌存储示例
class SecureTokenStorage {
    private static function encryptToken($token) {
        // 使用AES加密令牌
        $key = hash('sha256', getenv('ENCRYPTION_KEY'), true);
        $iv = random_bytes(16);
        $encrypted = openssl_encrypt($token, 'AES-256-CBC', $key, 0, $iv);
        return base64_encode($iv . $encrypted);
    }
    
    private static function decryptToken($encryptedToken) {
        $key = hash('sha256', getenv('ENCRYPTION_KEY'), true);
        $data = base64_decode($encryptedToken);
        $iv = substr($data, 0, 16);
        $encrypted = substr($data, 16);
        return openssl_decrypt($encrypted, 'AES-256-CBC', $key, 0, $iv);
    }
    
    public static function storeToken($userId, $token) {
        $encryptedToken = self::encryptToken($token);
        // 存储到数据库，设置适当过期时间
        // ...
    }
    
    public static function retrieveToken($userId) {
        // 从数据库获取加密令牌
        $encryptedToken = // ... 
        return self::decryptToken($encryptedToken);
    }
}';
    }
    
    /**
     * 错误处理和日志记录
     */
    public static function errorHandling() {
        return '
// OAuth2.0错误处理最佳实践
class OAuthErrorHandler {
    public static function logAuthorizationError($error, $description, $clientId, $userId = null) {
        $logData = [
            'timestamp' => date('Y-m-d H:i:s'),
            'error' => $error,
            'description' => $description,
            'client_id' => $clientId,
            'user_id' => $userId,
            'ip' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown'
        ];
        
        error_log("OAuth Authorization Error: " . json_encode($logData));
    }
    
    public static function handleAuthorizationError($error, $description, $state = null) {
        $params = [
            'error' => $error,
            'error_description' => $description
        ];
        
        if ($state) {
            $params['state'] = $state;
        }
        
        // 记录错误
        self::logAuthorizationError($error, $description, $_GET['client_id'] ?? 'unknown');
        
        // 重定向回客户端
        $redirectUri = $_GET['redirect_uri'] ?? '';
        if ($redirectUri) {
            header('Location: ' . $redirectUri . '?' . http_build_query($params));
        } else {
            http_response_code(400);
            echo json_encode($params);
        }
        exit;
    }
}';
    }
    
    /**
     * 速率限制实现
     */
    public static function rateLimiting() {
        return '
// OAuth2.0速率限制
class OAuthRateLimiter {
    private static $limits = [
        \'token_requests\' => 10, // 每分钟最多10个令牌请求
        \'authorization_requests\' => 5 // 每分钟最多5个授权请求
    ];
    
    public static function checkRateLimit($clientId, $type) {
        $key = "oauth_rate_limit:{$clientId}:{$type}:" . date(\'YmdHi\');
        
        // 使用Redis或类似存储实现
        // $current = Redis::incr($key);
        // if ($current === 1) {
        //     Redis::expire($key, 60); // 1分钟过期
        // }
        // 
        // return $current <= self::$limits[$type];
        
        return true; // 简化示例
    }
    
    public static function isRateLimited($clientId, $type) {
        if (!self::checkRateLimit($clientId, $type)) {
            throw new Exception(\'Rate limit exceeded\');
        }
    }
}';
    }
}

// 安全实践示例
// $pkce = OAuth2Security::pkceExample();
// echo "Code Verifier: " . $pkce['code_verifier'] . "\n";
// echo "Code Challenge: " . $pkce['code_challenge'] . "\n";
?>
```

### OAuth2.0流程对比总结

1. **授权码模式**：
   - 最安全，适用于有后端的Web应用
   - 通过后端交换访问令牌，令牌不会暴露给用户代理
   - 支持刷新令牌

2. **隐式模式**：
   - 适用于纯前端应用
   - 访问令牌直接返回给用户代理
   - 不支持刷新令牌
   - 安全性较低

3. **密码模式**：
   - 用户直接向客户端提供凭据
   - 仅适用于高度信任的客户端
   - 不推荐一般使用

4. **客户端凭证模式**：
   - 客户端以自己的名义访问资源
   - 不涉及用户授权
   - 适用于机器到机器的通信

### 总结

OAuth2.0是一个强大的授权框架，通过四种主要的授权流程满足不同场景的需求。正确实现OAuth2.0需要深入理解其工作原理和安全考虑，并遵循最佳实践来保护用户数据和系统安全。开发人员应该根据具体应用场景选择合适的授权流程，并实施适当的安全措施。