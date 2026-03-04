# 如何设计高性能的API接口？

## 概要回答

设计高性能的API接口需要从多个维度进行优化，主要方法包括：

1. **接口设计优化**：合理的RESTful设计、版本控制、错误处理
2. **数据传输优化**：数据压缩、分页、字段筛选、缓存策略
3. **性能优化**：数据库查询优化、并发处理、连接池管理
4. **安全性考虑**：身份验证、限流、输入验证、防止攻击
5. **监控和测试**：性能监控、压力测试、日志记录、指标收集

## 深度解析

### 接口设计优化

良好的API设计是高性能的基础，需要遵循RESTful原则并考虑可扩展性。

```php
<?php
/**
 * 高性能API设计示例
 */
class HighPerformanceAPI {
    
    /**
     * RESTful API设计示例
     */
    public static function restfulDesignExample() {
        // 良好的RESTful设计应该：
        // 1. 使用名词而非动词
        // 2. 合理使用HTTP方法
        // 3. 正确使用HTTP状态码
        // 4. 提供版本控制
        
        $routes = [
            // 好的设计
            'GET /api/v1/users' => '获取用户列表',
            'POST /api/v1/users' => '创建用户',
            'GET /api/v1/users/{id}' => '获取特定用户',
            'PUT /api/v1/users/{id}' => '更新用户',
            'DELETE /api/v1/users/{id}' => '删除用户',
            
            // 不好的设计
            'GET /api/v1/getUsers' => '避免使用动词',
            'GET /api/v1/deleteUser?id=123' => '避免在GET中执行删除操作'
        ];
        
        return $routes;
    }
    
    /**
     * API版本控制示例
     */
    public static function versionControlExample() {
        class APIVersionManager {
            private $versions = [
                'v1' => '2023-01-01',
                'v2' => '2023-06-01',
                'v3' => '2023-12-01'
            ];
            
            public function getCurrentVersion() {
                return 'v3';
            }
            
            public function getVersionDate($version) {
                return $this->versions[$version] ?? null;
            }
            
            public function isDeprecated($version) {
                $current = $this->getCurrentVersion();
                return version_compare($version, $current, '<');
            }
        }
        
        $manager = new APIVersionManager();
        echo "当前API版本: " . $manager->getCurrentVersion() . "\n";
        echo "v2是否已废弃: " . ($manager->isDeprecated('v2') ? '是' : '否') . "\n";
    }
    
    /**
     * 统一响应格式
     */
    public static function unifiedResponseFormat() {
        class APIResponse {
            public static function success($data = null, $message = 'Success', $code = 200) {
                return [
                    'success' => true,
                    'code' => $code,
                    'message' => $message,
                    'data' => $data,
                    'timestamp' => time()
                ];
            }
            
            public static function error($message = 'Error', $code = 400, $errors = []) {
                return [
                    'success' => false,
                    'code' => $code,
                    'message' => $message,
                    'errors' => $errors,
                    'timestamp' => time()
                ];
            }
            
            public static function paginated($data, $total, $page, $limit) {
                return [
                    'success' => true,
                    'code' => 200,
                    'message' => 'Success',
                    'data' => $data,
                    'pagination' => [
                        'total' => $total,
                        'page' => $page,
                        'limit' => $limit,
                        'pages' => ceil($total / $limit)
                    ],
                    'timestamp' => time()
                ];
            }
        }
        
        // 使用示例
        // header('Content-Type: application/json');
        // echo json_encode(APIResponse::success(['user' => 'John']), JSON_PRETTY_PRINT);
        
        return APIResponse::success(['user' => 'John']);
    }
}

// 运行示例
// HighPerformanceAPI::versionControlExample();
// print_r(HighPerformanceAPI::unifiedResponseFormat());
?>
```

### 数据传输优化

优化数据传输可以显著减少网络开销和提高响应速度。

```php
<?php
/**
 * 数据传输优化示例
 */
class DataTransferOptimizer {
    
    /**
     * 数据压缩实现
     */
    public static function compressionExample() {
        class CompressionHandler {
            public static function compressData($data, $algorithm = 'gzip') {
                switch ($algorithm) {
                    case 'gzip':
                        return gzencode($data, 6);
                    case 'deflate':
                        return gzdeflate($data, 6);
                    default:
                        return $data;
                }
            }
            
            public static function decompressData($data, $algorithm = 'gzip') {
                switch ($algorithm) {
                    case 'gzip':
                        return gzdecode($data);
                    case 'deflate':
                        return gzinflate($data);
                    default:
                        return $data;
                }
            }
            
            public static function enableHttpCompression() {
                if (isset($_SERVER['HTTP_ACCEPT_ENCODING'])) {
                    $encoding = $_SERVER['HTTP_ACCEPT_ENCODING'];
                    
                    if (strpos($encoding, 'gzip') !== false) {
                        header('Content-Encoding: gzip');
                        return 'gzip';
                    } elseif (strpos($encoding, 'deflate') !== false) {
                        header('Content-Encoding: deflate');
                        return 'deflate';
                    }
                }
                
                return null;
            }
        }
        
        // 测试数据压缩
        $originalData = str_repeat('{"name":"John","email":"john@example.com","role":"user"}', 1000);
        $compressed = CompressionHandler::compressData($originalData);
        
        echo "原始数据大小: " . strlen($originalData) . " 字节\n";
        echo "压缩后大小: " . strlen($compressed) . " 字节\n";
        echo "压缩率: " . number_format((1 - strlen($compressed) / strlen($originalData)) * 100, 2) . "%\n";
    }
    
    /**
     * 字段筛选优化
     */
    public static function fieldSelectionExample() {
        class FieldSelector {
            public static function selectFields($data, $fields) {
                if (empty($fields)) {
                    return $data;
                }
                
                // 将字段字符串转换为数组
                $fieldList = is_array($fields) ? $fields : explode(',', $fields);
                
                if (isset($data[0]) && is_array($data[0])) {
                    // 处理数组数据
                    return array_map(function($item) use ($fieldList) {
                        return self::filterFields($item, $fieldList);
                    }, $data);
                } else {
                    // 处理单个对象
                    return self::filterFields($data, $fieldList);
                }
            }
            
            private static function filterFields($item, $fields) {
                $filtered = [];
                foreach ($fields as $field) {
                    $field = trim($field);
                    if (isset($item[$field])) {
                        $filtered[$field] = $item[$field];
                    }
                }
                return $filtered;
            }
            
            public static function parseFieldParameter($param) {
                // 支持嵌套字段选择，如 user.name,user.email
                return explode(',', $param);
            }
        }
        
        // 测试数据
        $userData = [
            [
                'id' => 1,
                'name' => 'John Doe',
                'email' => 'john@example.com',
                'password' => 'hashed_password',
                'created_at' => '2023-01-01',
                'updated_at' => '2023-01-02'
            ],
            [
                'id' => 2,
                'name' => 'Jane Smith',
                'email' => 'jane@example.com',
                'password' => 'hashed_password',
                'created_at' => '2023-01-03',
                'updated_at' => '2023-01-04'
            ]
        ];
        
        // 只选择需要的字段
        $selectedFields = 'id,name,email';
        $filteredData = FieldSelector::selectFields($userData, $selectedFields);
        
        echo "原始数据字段数: " . count($userData[0]) . "\n";
        echo "筛选后字段数: " . count($filteredData[0]) . "\n";
        echo "减少的数据量: " . (count($userData[0]) - count($filteredData[0])) . " 字段\n";
    }
    
    /**
     * 分页优化
     */
    public static function paginationOptimization() {
        class OptimizedPagination {
            private $pdo;
            
            public function __construct($pdo) {
                $this->pdo = $pdo;
            }
            
            /**
             * 基于偏移量的传统分页（适合小数据集）
             */
            public function offsetBasedPagination($page, $limit, $conditions = []) {
                $offset = ($page - 1) * $limit;
                
                $sql = "SELECT * FROM users";
                $params = [];
                
                if (!empty($conditions)) {
                    $whereClause = [];
                    foreach ($conditions as $field => $value) {
                        $whereClause[] = "$field = :$field";
                        $params[$field] = $value;
                    }
                    $sql .= " WHERE " . implode(' AND ', $whereClause);
                }
                
                $sql .= " LIMIT :limit OFFSET :offset";
                $params['limit'] = $limit;
                $params['offset'] = $offset;
                
                $stmt = $this->pdo->prepare($sql);
                foreach ($params as $key => $value) {
                    $stmt->bindValue(":$key", $value, is_int($value) ? PDO::PARAM_INT : PDO::PARAM_STR);
                }
                $stmt->execute();
                
                $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
                
                // 获取总数
                $countSql = "SELECT COUNT(*) FROM users";
                if (!empty($conditions)) {
                    $whereClause = [];
                    foreach ($conditions as $field => $value) {
                        $whereClause[] = "$field = :$field";
                    }
                    $countSql .= " WHERE " . implode(' AND ', $whereClause);
                }
                
                $countStmt = $this->pdo->prepare($countSql);
                foreach ($conditions as $field => $value) {
                    $countStmt->bindValue(":$field", $value);
                }
                $countStmt->execute();
                $total = $countStmt->fetchColumn();
                
                return [
                    'data' => $data,
                    'pagination' => [
                        'total' => $total,
                        'page' => $page,
                        'limit' => $limit,
                        'pages' => ceil($total / $limit)
                    ]
                ];
            }
            
            /**
             * 基于游标的高效分页（适合大数据集）
             */
            public function cursorBasedPagination($cursor = null, $limit, $sortField = 'id', $sortOrder = 'ASC') {
                $sql = "SELECT * FROM users";
                $params = [];
                
                if ($cursor) {
                    $operator = $sortOrder === 'ASC' ? '>' : '<';
                    $sql .= " WHERE $sortField $operator :cursor";
                    $params['cursor'] = $cursor;
                }
                
                $sql .= " ORDER BY $sortField $sortOrder LIMIT :limit";
                $params['limit'] = $limit;
                
                $stmt = $this->pdo->prepare($sql);
                foreach ($params as $key => $value) {
                    $stmt->bindValue(":$key", $value, is_int($value) ? PDO::PARAM_INT : PDO::PARAM_STR);
                }
                $stmt->execute();
                
                $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
                
                // 获取下一个游标
                $nextCursor = null;
                if (!empty($data)) {
                    $lastItem = end($data);
                    $nextCursor = $lastItem[$sortField];
                }
                
                return [
                    'data' => $data,
                    'pagination' => [
                        'cursor' => $nextCursor,
                        'limit' => $limit,
                        'has_more' => count($data) == $limit
                    ]
                ];
            }
        }
        
        echo "分页优化示例完成\n";
    }
}

// 运行示例
// DataTransferOptimizer::compressionExample();
// DataTransferOptimizer::fieldSelectionExample();
?>
```

### 性能优化实现

API性能优化需要从数据库、缓存、并发等多个方面入手。

```php
<?php
/**
 * API性能优化示例
 */
class APIPerformanceOptimizer {
    
    /**
     * 数据库查询优化
     */
    public static function databaseOptimization() {
        class OptimizedDatabaseQueries {
            private $pdo;
            
            public function __construct($pdo) {
                $this->pdo = $pdo;
            }
            
            /**
             * 使用预处理语句和连接池
             */
            public function optimizedQuery($userId) {
                static $stmt = null;
                
                // 复用预处理语句
                if ($stmt === null) {
                    $stmt = $this->pdo->prepare("
                        SELECT u.id, u.name, u.email, p.title as profile_title
                        FROM users u
                        LEFT JOIN profiles p ON u.id = p.user_id
                        WHERE u.id = :user_id
                    ");
                }
                
                $stmt->execute(['user_id' => $userId]);
                return $stmt->fetch(PDO::FETCH_ASSOC);
            }
            
            /**
             * 批量查询优化
             */
            public function batchQuery($userIds) {
                if (empty($userIds)) {
                    return [];
                }
                
                // 使用IN查询优化批量获取
                $placeholders = str_repeat('?,', count($userIds) - 1) . '?';
                $sql = "SELECT * FROM users WHERE id IN ($placeholders)";
                
                $stmt = $this->pdo->prepare($sql);
                $stmt->execute($userIds);
                
                return $stmt->fetchAll(PDO::FETCH_ASSOC);
            }
            
            /**
             * 查询结果缓存
             */
            public function cachedQuery($query, $params = [], $ttl = 300) {
                static $cache = [];
                
                $cacheKey = md5($query . serialize($params));
                $now = time();
                
                // 检查缓存
                if (isset($cache[$cacheKey]) && ($now - $cache[$cacheKey]['timestamp']) < $ttl) {
                    return $cache[$cacheKey]['data'];
                }
                
                // 执行查询
                $stmt = $this->pdo->prepare($query);
                $stmt->execute($params);
                $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
                
                // 存储到缓存
                $cache[$cacheKey] = [
                    'data' => $result,
                    'timestamp' => $now
                ];
                
                return $result;
            }
        }
        
        echo "数据库查询优化示例完成\n";
    }
    
    /**
     * 连接池管理
     */
    public static function connectionPooling() {
        class SimpleConnectionPool {
            private $pool = [];
            private $config;
            private $maxConnections = 10;
            private $createdConnections = 0;
            
            public function __construct($config) {
                $this->config = $config;
            }
            
            public function getConnection() {
                // 如果池中有可用连接，直接返回
                if (!empty($this->pool)) {
                    return array_pop($this->pool);
                }
                
                // 如果未达到最大连接数，创建新连接
                if ($this->createdConnections < $this->maxConnections) {
                    $pdo = new PDO(
                        $this->config['dsn'],
                        $this->config['username'],
                        $this->config['password'],
                        $this->config['options'] ?? []
                    );
                    
                    $this->createdConnections++;
                    return $pdo;
                }
                
                // 如果达到最大连接数，等待或抛出异常
                throw new Exception("连接池已满");
            }
            
            public function releaseConnection($pdo) {
                // 如果池未满，将连接放回池中
                if (count($this->pool) < $this->maxConnections) {
                    // 重置连接状态
                    $pdo->setAttribute(PDO::ATTR_AUTOCOMMIT, true);
                    $this->pool[] = $pdo;
                } else {
                    // 池已满，关闭连接
                    $pdo = null;
                    $this->createdConnections--;
                }
            }
        }
        
        // 使用示例
        $config = [
            'dsn' => 'sqlite::memory:',
            'username' => '',
            'password' => '',
            'options' => [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
            ]
        ];
        
        $pool = new SimpleConnectionPool($config);
        echo "连接池示例完成\n";
    }
    
    /**
     * 异步处理
     */
    public static function asyncProcessing() {
        class AsyncAPIHandler {
            /**
             * 非阻塞响应
             */
            public static function immediateResponse($taskId) {
                // 立即返回任务ID，而不是等待任务完成
                header('Content-Type: application/json');
                http_response_code(202); // Accepted
                
                return [
                    'success' => true,
                    'task_id' => $taskId,
                    'message' => 'Task accepted for processing',
                    'status_url' => "/api/v1/tasks/$taskId/status"
                ];
            }
            
            /**
             * 任务状态查询
             */
            public static function getTaskStatus($taskId) {
                // 模拟任务状态查询
                $statuses = ['pending', 'processing', 'completed', 'failed'];
                $status = $statuses[array_rand($statuses)];
                
                return [
                    'task_id' => $taskId,
                    'status' => $status,
                    'progress' => $status === 'completed' ? 100 : rand(0, 99),
                    'result_url' => $status === 'completed' ? "/api/v1/tasks/$taskId/result" : null
                ];
            }
            
            /**
             * SSE实时推送示例
             */
            public static function serverSentEvents() {
                header('Content-Type: text/event-stream');
                header('Cache-Control: no-cache');
                
                // 发送数据
                echo "data: " . json_encode(['status' => 'connected', 'time' => date('Y-m-d H:i:s')]) . "\n\n";
                
                // 模拟实时更新
                for ($i = 1; $i <= 10; $i++) {
                    sleep(1);
                    echo "data: " . json_encode(['progress' => $i * 10, 'message' => "Step $i completed"]) . "\n\n";
                    flush();
                }
                
                echo "data: " . json_encode(['status' => 'completed']) . "\n\n";
                flush();
            }
        }
        
        echo "异步处理示例完成\n";
    }
}

// 运行示例
// APIPerformanceOptimizer::databaseOptimization();
// APIPerformanceOptimizer::connectionPooling();
// APIPerformanceOptimizer::asyncProcessing();
?>
```

### 安全性优化

API安全性是高性能API设计中不可忽视的重要方面。

```php
<?php
/**
 * API安全性优化示例
 */
class APISecurityOptimizer {
    
    /**
     * 身份验证和授权
     */
    public static function authenticationAuthorization() {
        class JWTAuth {
            private $secretKey;
            
            public function __construct($secretKey) {
                $this->secretKey = $secretKey;
            }
            
            public function generateToken($payload, $expiresIn = 3600) {
                $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);
                $payload['exp'] = time() + $expiresIn;
                $payload['iat'] = time();
                
                $base64Header = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($header));
                $base64Payload = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode(json_encode($payload)));
                
                $signature = hash_hmac('sha256', $base64Header . "." . $base64Payload, $this->secretKey, true);
                $base64Signature = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($signature));
                
                return $base64Header . "." . $base64Payload . "." . $base64Signature;
            }
            
            public function validateToken($token) {
                $tokenParts = explode('.', $token);
                if (count($tokenParts) != 3) {
                    return false;
                }
                
                list($header, $payload, $signature) = $tokenParts;
                
                $expectedSignature = hash_hmac('sha256', $header . "." . $payload, $this->secretKey, true);
                $base64ExpectedSignature = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($expectedSignature));
                
                if ($signature !== $base64ExpectedSignature) {
                    return false;
                }
                
                $decodedPayload = json_decode(base64_decode(str_replace(['-', '_'], ['+', '/'], $payload)), true);
                if (!$decodedPayload || !isset($decodedPayload['exp']) || $decodedPayload['exp'] < time()) {
                    return false;
                }
                
                return $decodedPayload;
            }
        }
        
        class RBAC {
            private $permissions = [
                'admin' => ['read', 'write', 'delete', 'manage_users'],
                'editor' => ['read', 'write'],
                'viewer' => ['read']
            ];
            
            public function hasPermission($role, $permission) {
                return isset($this->permissions[$role]) && in_array($permission, $this->permissions[$role]);
            }
            
            public function getPermissions($role) {
                return $this->permissions[$role] ?? [];
            }
        }
        
        // 使用示例
        $jwt = new JWTAuth('my_secret_key');
        $rbac = new RBAC();
        
        $token = $jwt->generateToken(['user_id' => 123, 'role' => 'admin']);
        echo "生成的JWT Token: $token\n";
        
        $payload = $jwt->validateToken($token);
        echo "验证结果: " . ($payload ? '有效' : '无效') . "\n";
        
        echo "管理员权限: " . implode(', ', $rbac->getPermissions('admin')) . "\n";
        echo "是否有删除权限: " . ($rbac->hasPermission('admin', 'delete') ? '是' : '否') . "\n";
    }
    
    /**
     * 限流实现
     */
    public static function rateLimiting() {
        class TokenBucketRateLimiter {
            private $capacity;
            private $ refillRate;
            private $tokens;
            private $lastRefill;
            
            public function __construct($capacity, $refillRate) {
                $this->capacity = $capacity;
                $this->refillRate = $refillRate;
                $this->tokens = $capacity;
                $this->lastRefill = microtime(true);
            }
            
            private function refill() {
                $now = microtime(true);
                $delta = $now - $this->lastRefill;
                $tokensToAdd = $delta * $this->refillRate;
                
                if ($tokensToAdd > 0) {
                    $this->tokens = min($this->capacity, $this->tokens + $tokensToAdd);
                    $this->lastRefill = $now;
                }
            }
            
            public function consume($tokens = 1) {
                $this->refill();
                
                if ($this->tokens >= $tokens) {
                    $this->tokens -= $tokens;
                    return true;
                }
                
                return false;
            }
            
            public function getAvailableTokens() {
                $this->refill();
                return $this->tokens;
            }
        }
        
        class SlidingWindowRateLimiter {
            private $redis;
            private $keyPrefix;
            private $limit;
            private $window;
            
            public function __construct($redis, $keyPrefix, $limit, $window) {
                $this->redis = $redis;
                $this->keyPrefix = $keyPrefix;
                $this->limit = $limit;
                $this->window = $window;
            }
            
            public function isAllowed($key) {
                $fullKey = $this->keyPrefix . ':' . $key;
                $now = time();
                
                // 移除窗口外的记录
                $this->redis->zremrangebyscore($fullKey, 0, $now - $this->window);
                
                // 检查当前请求数
                $current = $this->redis->zcard($fullKey);
                
                if ($current < $this->limit) {
                    // 添加当前请求
                    $this->redis->zadd($fullKey, $now, $now);
                    $this->redis->expire($fullKey, $this->window);
                    return true;
                }
                
                return false;
            }
        }
        
        // 使用令牌桶限流
        $limiter = new TokenBucketRateLimiter(10, 2); // 容量10，每秒补充2个令牌
        
        for ($i = 1; $i <= 15; $i++) {
            $allowed = $limiter->consume();
            echo "请求 $i: " . ($allowed ? '允许' : '拒绝') . " (可用令牌: " . $limiter->getAvailableTokens() . ")\n";
            usleep(100000); // 0.1秒间隔
        }
    }
    
    /**
     * 输入验证和过滤
     */
    public static function inputValidation() {
        class InputValidator {
            public static function validate($data, $rules) {
                $errors = [];
                
                foreach ($rules as $field => $rule) {
                    if (!isset($data[$field]) && !isset($rule['optional'])) {
                        $errors[$field] = "字段 $field 是必需的";
                        continue;
                    }
                    
                    if (!isset($data[$field])) {
                        continue; // 可选字段且未提供
                    }
                    
                    $value = $data[$field];
                    
                    // 类型验证
                    if (isset($rule['type'])) {
                        if (!self::validateType($value, $rule['type'])) {
                            $errors[$field] = "字段 $field 类型不正确";
                            continue;
                        }
                    }
                    
                    // 长度验证
                    if (isset($rule['min_length']) && strlen($value) < $rule['min_length']) {
                        $errors[$field] = "字段 $field 长度不能少于 {$rule['min_length']} 个字符";
                    }
                    
                    if (isset($rule['max_length']) && strlen($value) > $rule['max_length']) {
                        $errors[$field] = "字段 $field 长度不能超过 {$rule['max_length']} 个字符";
                    }
                    
                    // 正则表达式验证
                    if (isset($rule['pattern']) && !preg_match($rule['pattern'], $value)) {
                        $errors[$field] = "字段 $field 格式不正确";
                    }
                    
                    // 范围验证
                    if (isset($rule['min']) && is_numeric($value) && $value < $rule['min']) {
                        $errors[$field] = "字段 $field 不能小于 {$rule['min']}";
                    }
                    
                    if (isset($rule['max']) && is_numeric($value) && $value > $rule['max']) {
                        $errors[$field] = "字段 $field 不能大于 {$rule['max']}";
                    }
                }
                
                return $errors;
            }
            
            private static function validateType($value, $type) {
                switch ($type) {
                    case 'string':
                        return is_string($value);
                    case 'integer':
                        return is_integer($value) || (is_string($value) && ctype_digit($value));
                    case 'float':
                        return is_float($value) || is_numeric($value);
                    case 'boolean':
                        return is_bool($value) || in_array(strtolower($value), ['true', 'false', '1', '0']);
                    case 'email':
                        return filter_var($value, FILTER_VALIDATE_EMAIL) !== false;
                    default:
                        return true;
                }
            }
            
            public static function sanitize($data, $rules) {
                $sanitized = [];
                
                foreach ($data as $field => $value) {
                    if (isset($rules[$field]['sanitize'])) {
                        switch ($rules[$field]['sanitize']) {
                            case 'trim':
                                $value = trim($value);
                                break;
                            case 'strip_tags':
                                $value = strip_tags($value);
                                break;
                            case 'htmlspecialchars':
                                $value = htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
                                break;
                        }
                    }
                    $sanitized[$field] = $value;
                }
                
                return $sanitized;
            }
        }
        
        // 使用示例
        $data = [
            'name' => ' John Doe ',
            'email' => 'john@example.com',
            'age' => '25',
            'bio' => '<script>alert("xss")</script>Hello World'
        ];
        
        $rules = [
            'name' => [
                'type' => 'string',
                'min_length' => 2,
                'max_length' => 50,
                'sanitize' => 'trim'
            ],
            'email' => [
                'type' => 'email',
                'max_length' => 100,
                'sanitize' => 'trim'
            ],
            'age' => [
                'type' => 'integer',
                'min' => 18,
                'max' => 120
            ],
            'bio' => [
                'type' => 'string',
                'max_length' => 500,
                'sanitize' => 'htmlspecialchars'
            ]
        ];
        
        $errors = InputValidator::validate($data, $rules);
        if (empty($errors)) {
            $sanitizedData = InputValidator::sanitize($data, $rules);
            echo "数据验证通过\n";
            print_r($sanitizedData);
        } else {
            echo "数据验证失败:\n";
            print_r($errors);
        }
    }
}

// 运行示例
// APISecurityOptimizer::authenticationAuthorization();
// APISecurityOptimizer::rateLimiting();
// APISecurityOptimizer::inputValidation();
?>
```

### 监控和测试

完善的监控和测试机制是保证API高性能的重要手段。

```php
<?php
/**
 * API监控和测试示例
 */
class APIMonitoringTesting {
    
    /**
     * 性能监控
     */
    public static function performanceMonitoring() {
        class PerformanceMonitor {
            private static $timers = [];
            private static $counters = [];
            private static $gauges = [];
            
            public static function startTimer($name) {
                self::$timers[$name] = [
                    'start' => microtime(true),
                    'memory_start' => memory_get_usage()
                ];
            }
            
            public static function stopTimer($name) {
                if (!isset(self::$timers[$name])) {
                    return null;
                }
                
                $end = microtime(true);
                $memoryEnd = memory_get_usage();
                
                $executionTime = $end - self::$timers[$name]['start'];
                $memoryUsed = $memoryEnd - self::$timers[$name]['memory_start'];
                
                return [
                    'execution_time' => $executionTime,
                    'memory_used' => $memoryUsed,
                    'peak_memory' => memory_get_peak_usage()
                ];
            }
            
            public static function incrementCounter($name, $value = 1) {
                if (!isset(self::$counters[$name])) {
                    self::$counters[$name] = 0;
                }
                self::$counters[$name] += $value;
            }
            
            public static function setGauge($name, $value) {
                self::$gauges[$name] = $value;
            }
            
            public static function getMetrics() {
                return [
                    'timers' => self::$timers,
                    'counters' => self::$counters,
                    'gauges' => self::$gauges
                ];
            }
            
            public static function logRequest($endpoint, $method, $statusCode, $responseTime) {
                $logEntry = [
                    'timestamp' => date('Y-m-d H:i:s'),
                    'endpoint' => $endpoint,
                    'method' => $method,
                    'status_code' => $statusCode,
                    'response_time' => $responseTime,
                    'memory_usage' => memory_get_usage(),
                    'peak_memory' => memory_get_peak_usage()
                ];
                
                // 写入日志文件
                file_put_contents('api_performance.log', json_encode($logEntry) . "\n", FILE_APPEND);
            }
        }
        
        // 使用示例
        PerformanceMonitor::startTimer('api_request');
        PerformanceMonitor::incrementCounter('requests_total');
        PerformanceMonitor::setGauge('active_connections', 5);
        
        // 模拟API处理
        usleep(500000); // 0.5秒
        
        $metrics = PerformanceMonitor::stopTimer('api_request');
        PerformanceMonitor::logRequest('/api/users', 'GET', 200, $metrics['execution_time']);
        
        echo "性能监控示例完成\n";
        print_r($metrics);
    }
    
    /**
     * 压力测试工具
     */
    public static function loadTesting() {
        class LoadTester {
            public static function concurrentRequests($url, $concurrent, $total) {
                $results = [];
                $startTime = microtime(true);
                
                // 模拟并发请求
                for ($i = 0; $i < $total; $i += $concurrent) {
                    $batchSize = min($concurrent, $total - $i);
                    $batchResults = [];
                    
                    for ($j = 0; $j < $batchSize; $j++) {
                        $start = microtime(true);
                        // 模拟HTTP请求
                        $response = self::simulateHttpRequest($url);
                        $end = microtime(true);
                        
                        $batchResults[] = [
                            'status' => $response['status'],
                            'response_time' => $end - $start,
                            'size' => strlen($response['body'])
                        ];
                    }
                    
                    $results = array_merge($results, $batchResults);
                }
                
                $totalTime = microtime(true) - $startTime;
                
                return self::analyzeResults($results, $totalTime);
            }
            
            private static function simulateHttpRequest($url) {
                // 模拟网络延迟
                usleep(rand(50000, 500000)); // 50ms - 500ms
                
                // 模拟响应
                $statuses = [200, 200, 200, 404, 500]; // 80%成功率
                $status = $statuses[array_rand($statuses)];
                
                return [
                    'status' => $status,
                    'body' => $status === 200 ? str_repeat('x', rand(100, 1000)) : 'Error'
                ];
            }
            
            private static function analyzeResults($results, $totalTime) {
                $successCount = 0;
                $totalResponseTime = 0;
                $totalSize = 0;
                $responseTimes = [];
                
                foreach ($results as $result) {
                    if ($result['status'] === 200) {
                        $successCount++;
                    }
                    $totalResponseTime += $result['response_time'];
                    $totalSize += $result['size'];
                    $responseTimes[] = $result['response_time'];
                }
                
                sort($responseTimes);
                $percentile95 = $responseTimes[(int)(count($responseTimes) * 0.95)];
                $percentile99 = $responseTimes[(int)(count($responseTimes) * 0.99)];
                
                return [
                    'total_requests' => count($results),
                    'successful_requests' => $successCount,
                    'success_rate' => ($successCount / count($results)) * 100,
                    'total_time' => $totalTime,
                    'requests_per_second' => count($results) / $totalTime,
                    'average_response_time' => $totalResponseTime / count($results),
                    '95th_percentile' => $percentile95,
                    '99th_percentile' => $percentile99,
                    'total_data_transferred' => $totalSize,
                    'average_response_size' => $totalSize / count($results)
                ];
            }
        }
        
        // 运行压力测试
        $results = LoadTester::concurrentRequests('http://api.example.com/users', 10, 100);
        echo "压力测试结果:\n";
        foreach ($results as $key => $value) {
            if (is_float($value)) {
                echo sprintf("%s: %.4f\n", $key, $value);
            } else {
                echo "$key: $value\n";
            }
        }
    }
    
    /**
     * 错误追踪和日志记录
     */
    public static function errorTracking() {
        class ErrorTracker {
            private static $errors = [];
            
            public static function logError($level, $message, $context = []) {
                $error = [
                    'timestamp' => date('Y-m-d H:i:s'),
                    'level' => $level,
                    'message' => $message,
                    'context' => $context,
                    'trace' => debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 10)
                ];
                
                self::$errors[] = $error;
                
                // 写入日志文件
                $logMessage = sprintf(
                    "[%s] %s: %s %s\n",
                    $error['timestamp'],
                    strtoupper($level),
                    $message,
                    !empty($context) ? json_encode($context) : ''
                );
                
                file_put_contents('api_errors.log', $logMessage, FILE_APPEND);
                
                // 如果是严重错误，发送告警
                if ($level === 'error' || $level === 'critical') {
                    self::sendAlert($error);
                }
            }
            
            private static function sendAlert($error) {
                // 模拟发送告警通知
                echo "发送告警: " . $error['message'] . "\n";
            }
            
            public static function getErrors($limit = 100) {
                return array_slice(array_reverse(self::$errors), 0, $limit);
            }
            
            public static function getErrorStats() {
                $stats = [
                    'total' => count(self::$errors),
                    'by_level' => [],
                    'by_hour' => []
                ];
                
                foreach (self::$errors as $error) {
                    $level = $error['level'];
                    if (!isset($stats['by_level'][$level])) {
                        $stats['by_level'][$level] = 0;
                    }
                    $stats['by_level'][$level]++;
                    
                    $hour = date('Y-m-d H', strtotime($error['timestamp']));
                    if (!isset($stats['by_hour'][$hour])) {
                        $stats['by_hour'][$hour] = 0;
                    }
                    $stats['by_hour'][$hour]++;
                }
                
                return $stats;
            }
        }
        
        // 使用示例
        ErrorTracker::logError('warning', 'Database connection slow', ['host' => 'db1.example.com']);
        ErrorTracker::logError('error', 'API endpoint failed', ['endpoint' => '/api/users', 'user_id' => 123]);
        ErrorTracker::logError('info', 'User login successful', ['user_id' => 456]);
        
        echo "错误追踪示例完成\n";
        print_r(ErrorTracker::getErrorStats());
    }
}

// 运行示例
// APIMonitoringTesting::performanceMonitoring();
// APIMonitoringTesting::loadTesting();
// APIMonitoringTesting::errorTracking();
?>
```

### 高性能API设计最佳实践

1. **接口设计**：
   - 遵循RESTful设计原则
   - 实施版本控制
   - 提供统一的响应格式
   - 合理设计资源层次结构

2. **数据传输优化**：
   - 实施数据压缩（Gzip/Brotli）
   - 支持字段筛选减少传输数据量
   - 使用高效的分页策略
   - 合理使用缓存

3. **性能优化**：
   - 优化数据库查询和连接管理
   - 实施连接池和对象池
   - 使用异步处理和非阻塞I/O
   - 合理使用索引和查询优化

4. **安全性**：
   - 实施强身份验证和授权机制
   - 使用限流防止滥用
   - 严格验证和过滤输入数据
   - 防止常见安全攻击

5. **监控和测试**：
   - 实施全面的性能监控
   - 定期进行压力测试
   - 建立完善的错误追踪机制
   - 收集和分析API使用指标

### 总结

设计高性能的API接口需要从架构设计、数据传输、性能优化、安全性和监控测试等多个维度进行综合考虑。通过合理的RESTful设计、数据压缩、缓存策略、数据库优化、安全防护和监控机制，可以构建出既高性能又安全可靠的API接口。关键是要建立完善的性能监控体系，持续优化和改进API性能，同时确保安全性和可维护性。