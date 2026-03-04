# 如何防范SQL注入攻击？

## 概要回答

SQL注入是Web应用中最常见的安全漏洞之一，防范措施主要包括：

1. **使用预处理语句（Prepared Statements）**：这是最有效的防护方法，通过参数化查询分离SQL代码和数据
2. **输入验证和过滤**：对用户输入进行严格的类型检查、长度限制和格式验证
3. **转义特殊字符**：使用数据库特定的转义函数处理用户输入
4. **最小权限原则**：为应用数据库账户分配最小必要权限
5. **定期安全审计**：使用自动化工具扫描代码中的潜在注入点

## 深度解析

### SQL注入攻击原理

SQL注入攻击是指攻击者通过在应用程序的输入字段中插入恶意的SQL代码，从而改变原有SQL查询的逻辑，执行非授权的数据库操作。这种攻击可能导致数据泄露、数据篡改甚至服务器被完全控制。

```php
<?php
// 危险的SQL查询示例（易受SQL注入攻击）
$username = $_POST['username'];
$password = $_POST['password'];

// 这种拼接方式非常危险
$sql = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
$result = mysqli_query($connection, $sql);

// 如果攻击者输入 username: admin'-- 
// 生成的SQL将是: SELECT * FROM users WHERE username = 'admin'--' AND password = ''
// -- 是SQL注释符，后面的密码验证被忽略，攻击者可以以admin身份登录
?>
```

### 预处理语句防护（推荐方法）

预处理语句是防范SQL注入最有效的方法，它通过将SQL代码和数据分离来防止恶意代码注入。

```php
<?php
/**
 * 使用PDO预处理语句防范SQL注入
 */
class SecureDatabaseAccess {
    private $pdo;
    
    public function __construct($dsn, $username, $password) {
        $this->pdo = new PDO($dsn, $username, $password);
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }
    
    /**
     * 安全的用户认证示例
     */
    public function authenticateUser($username, $password) {
        // 使用预处理语句
        $sql = "SELECT id, username, password_hash FROM users WHERE username = :username";
        $stmt = $this->pdo->prepare($sql);
        $stmt->bindParam(':username', $username, PDO::PARAM_STR);
        $stmt->execute();
        
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user && password_verify($password, $user['password_hash'])) {
            return $user;
        }
        
        return false;
    }
    
    /**
     * 安全的数据查询示例
     */
    public function getUserById($userId) {
        $sql = "SELECT * FROM users WHERE id = :user_id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);
        $stmt->execute();
        
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    
    /**
     * 安全的数据插入示例
     */
    public function createUser($username, $email, $password) {
        $passwordHash = password_hash($password, PASSWORD_DEFAULT);
        
        $sql = "INSERT INTO users (username, email, password_hash, created_at) 
                VALUES (:username, :email, :password_hash, NOW())";
        $stmt = $this->pdo->prepare($sql);
        $stmt->bindParam(':username', $username, PDO::PARAM_STR);
        $stmt->bindParam(':email', $email, PDO::PARAM_STR);
        $stmt->bindParam(':password_hash', $passwordHash, PDO::PARAM_STR);
        
        return $stmt->execute();
    }
    
    /**
     * 安全的批量操作示例
     */
    public function updateMultipleUsers($userUpdates) {
        $this->pdo->beginTransaction();
        try {
            $sql = "UPDATE users SET status = :status WHERE id = :user_id";
            $stmt = $this->pdo->prepare($sql);
            
            foreach ($userUpdates as $update) {
                $stmt->execute([
                    ':status' => $update['status'],
                    ':user_id' => $update['user_id']
                ]);
            }
            
            $this->pdo->commit();
            return true;
        } catch (Exception $e) {
            $this->pdo->rollback();
            throw $e;
        }
    }
}

// 使用示例
// $db = new SecureDatabaseAccess('mysql:host=localhost;dbname=test', 'user', 'pass');
// $user = $db->authenticateUser($_POST['username'], $_POST['password']);
?>
```

### MySQLi预处理语句示例

```php
<?php
/**
 * 使用MySQLi预处理语句
 */
class MySQLiSecureAccess {
    private $mysqli;
    
    public function __construct($host, $username, $password, $database) {
        $this->mysqli = new mysqli($host, $username, $password, $database);
        if ($this->mysqli->connect_error) {
            die('连接失败: ' . $this->mysqli->connect_error);
        }
    }
    
    /**
     * 使用MySQLi预处理语句查询
     */
    public function getUserByUsername($username) {
        $sql = "SELECT id, username, email FROM users WHERE username = ?";
        $stmt = $this->mysqli->prepare($sql);
        $stmt->bind_param("s", $username); // s表示字符串类型
        $stmt->execute();
        
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }
    
    /**
     * 使用MySQLi预处理语句插入
     */
    public function insertUser($username, $email) {
        $sql = "INSERT INTO users (username, email, created_at) VALUES (?, ?, NOW())";
        $stmt = $this->mysqli->prepare($sql);
        $stmt->bind_param("ss", $username, $email); // ss表示两个字符串参数
        return $stmt->execute();
    }
    
    /**
     * 使用MySQLi预处理语句更新
     */
    public function updateUserStatus($userId, $status) {
        $sql = "UPDATE users SET status = ? WHERE id = ?";
        $stmt = $this->mysqli->prepare($sql);
        $stmt->bind_param("si", $status, $userId); // si表示字符串和整数参数
        return $stmt->execute();
    }
}
?>
```

### 输入验证和过滤

除了使用预处理语句，还应对用户输入进行严格的验证和过滤。

```php
<?php
/**
 * 输入验证和过滤工具类
 */
class InputValidator {
    
    /**
     * 验证用户名（字母数字下划线，长度3-20）
     */
    public static function validateUsername($username) {
        if (!is_string($username)) {
            return false;
        }
        
        if (strlen($username) < 3 || strlen($username) > 20) {
            return false;
        }
        
        if (!preg_match('/^[a-zA-Z0-9_]+$/', $username)) {
            return false;
        }
        
        return true;
    }
    
    /**
     * 验证邮箱格式
     */
    public static function validateEmail($email) {
        return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
    }
    
    /**
     * 验证整数范围
     */
    public static function validateInteger($value, $min = null, $max = null) {
        if (!is_numeric($value) || !ctype_digit((string)$value)) {
            return false;
        }
        
        $intValue = (int)$value;
        
        if ($min !== null && $intValue < $min) {
            return false;
        }
        
        if ($max !== null && $intValue > $max) {
            return false;
        }
        
        return true;
    }
    
    /**
     * 安全的字符串处理
     */
    public static function sanitizeString($input) {
        // 去除首尾空白字符
        $input = trim($input);
        
        // 转换特殊HTML字符
        $input = htmlspecialchars($input, ENT_QUOTES, 'UTF-8');
        
        // 限制长度（根据实际需求调整）
        $input = substr($input, 0, 1000);
        
        return $input;
    }
    
    /**
     * 综合验证函数
     */
    public static function validateUserData($data) {
        $errors = [];
        
        // 验证用户名
        if (!isset($data['username']) || !self::validateUsername($data['username'])) {
            $errors[] = '用户名格式不正确（3-20位字母数字下划线）';
        }
        
        // 验证邮箱
        if (!isset($data['email']) || !self::validateEmail($data['email'])) {
            $errors[] = '邮箱格式不正确';
        }
        
        // 验证年龄（如果提供）
        if (isset($data['age']) && !self::validateInteger($data['age'], 1, 120)) {
            $errors[] = '年龄必须是1-120之间的整数';
        }
        
        return $errors;
    }
}

// 使用示例
$userData = [
    'username' => $_POST['username'] ?? '',
    'email' => $_POST['email'] ?? '',
    'age' => $_POST['age'] ?? ''
];

$errors = InputValidator::validateUserData($userData);
if (empty($errors)) {
    // 数据验证通过，可以安全使用
    $safeUsername = InputValidator::sanitizeString($userData['username']);
    $safeEmail = InputValidator::sanitizeString($userData['email']);
} else {
    // 处理验证错误
    foreach ($errors as $error) {
        echo "错误: $error\n";
    }
}
?>
```

### 特殊字符转义（备用方法）

当无法使用预处理语句时，可以使用数据库特定的转义函数，但这不是首选方法。

```php
<?php
/**
 * 特殊字符转义示例（仅在无法使用预处理语句时使用）
 */
class EscapeHelper {
    
    /**
     * MySQL特殊字符转义
     */
    public static function mysqlEscape($string, $connection) {
        if (function_exists('mysqli_real_escape_string')) {
            return mysqli_real_escape_string($connection, $string);
        }
        
        // 手动转义（不推荐，仅作示例）
        return addslashes($string);
    }
    
    /**
     * 使用转义的危险查询示例（仅作对比，不推荐实际使用）
     */
    public static function unsafeQueryWithEscape($connection, $username, $password) {
        // 转义用户输入
        $safeUsername = self::mysqlEscape($username, $connection);
        $safePassword = self::mysqlEscape($password, $connection);
        
        // 构造SQL查询（仍然不如预处理语句安全）
        $sql = "SELECT * FROM users WHERE username = '$safeUsername' AND password = '$safePassword'";
        $result = mysqli_query($connection, $sql);
        
        return $result ? mysqli_fetch_assoc($result) : false;
    }
}
?>
```

### 白名单验证

对于某些固定选项的输入，使用白名单验证是最安全的方法。

```php
<?php
/**
 * 白名单验证示例
 */
class WhitelistValidator {
    
    /**
     * 验证排序字段
     */
    public static function validateSortField($field) {
        $allowedFields = ['id', 'username', 'email', 'created_at'];
        return in_array($field, $allowedFields);
    }
    
    /**
     * 验证排序方向
     */
    public static function validateSortOrder($order) {
        $allowedOrders = ['ASC', 'DESC'];
        return in_array(strtoupper($order), $allowedOrders);
    }
    
    /**
     * 验证状态值
     */
    public static function validateStatus($status) {
        $allowedStatuses = ['active', 'inactive', 'pending', 'suspended'];
        return in_array($status, $allowedStatuses);
    }
    
    /**
     * 安全的动态查询构建
     */
    public static function buildSafeQuery($baseQuery, $params) {
        $query = $baseQuery;
        $bindings = [];
        
        // 验证排序字段
        if (isset($params['sort_field']) && self::validateSortField($params['sort_field'])) {
            $query .= " ORDER BY " . $params['sort_field'];
            
            // 验证排序方向
            if (isset($params['sort_order']) && self::validateSortOrder($params['sort_order'])) {
                $query .= " " . strtoupper($params['sort_order']);
            } else {
                $query .= " ASC"; // 默认排序
            }
        }
        
        // 验证限制数量
        if (isset($params['limit']) && is_numeric($params['limit']) && $params['limit'] <= 100) {
            $query .= " LIMIT " . (int)$params['limit'];
        } else {
            $query .= " LIMIT 10"; // 默认限制
        }
        
        return [$query, $bindings];
    }
}

// 使用示例
$params = [
    'sort_field' => $_GET['sort'] ?? 'id',
    'sort_order' => $_GET['order'] ?? 'ASC',
    'limit' => $_GET['limit'] ?? 10
];

list($safeQuery, $bindings) = WhitelistValidator::buildSafeQuery(
    "SELECT * FROM users WHERE status = 'active'", 
    $params
);

echo "安全查询: $safeQuery\n";
?>
```

### ORM框架防护

使用ORM框架也可以有效防止SQL注入。

```php
<?php
/**
 * 使用Eloquent ORM示例（Laravel框架）
 * 注意：这只是示例代码，实际使用需要安装Laravel框架
 */
class ORMExample {
    
    /**
     * Eloquent ORM查询示例
     */
    public static function eloquentExamples() {
        // Eloquent ORM自动防止SQL注入
        // $users = User::where('username', $username)->get();
        
        // 复杂查询也安全
        // $users = User::where('status', 'active')
        //              ->where('created_at', '>', $date)
        //              ->orderBy('username')
        //              ->limit(10)
        //              ->get();
        
        // 原生查询需要使用绑定参数
        // $users = DB::select('SELECT * FROM users WHERE status = ? AND created_at > ?', 
        //                     ['active', $date]);
        
        return "ORM示例代码（需要Laravel框架支持）";
    }
    
    /**
     * Doctrine ORM示例
     */
    public static function doctrineExamples() {
        // Doctrine DQL查询也是安全的
        // $query = $entityManager->createQuery(
        //     'SELECT u FROM User u WHERE u.status = :status'
        // );
        // $query->setParameter('status', 'active');
        // $users = $query->getResult();
        
        return "Doctrine ORM示例代码（需要Doctrine ORM支持）";
    }
}
?>
```

### 安全配置和最佳实践

```php
<?php
/**
 * 数据库安全配置
 */
class DatabaseSecurityConfig {
    
    /**
     * 获取安全的PDO配置
     */
    public static function getSecurePDOConfig() {
        return [
            // 强制使用预处理语句
            PDO::ATTR_EMULATE_PREPARES => false,
            
            // 错误模式设为异常
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            
            // 默认获取模式
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            
            // 连接字符集
            PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4"
        ];
    }
    
    /**
     * 数据库用户权限最小化示例
     */
    public static function getMinimalPrivilegesSQL() {
        return "
-- 为Web应用创建专用用户
CREATE USER 'webapp'@'localhost' IDENTIFIED BY 'strong_password';

-- 授予最小必要权限
GRANT SELECT, INSERT, UPDATE, DELETE ON myapp.* TO 'webapp'@'localhost';

-- 对于只读操作的用户
CREATE USER 'readonly'@'localhost' IDENTIFIED BY 'readonly_password';
GRANT SELECT ON myapp.* TO 'readonly'@'localhost';

-- 刷新权限
FLUSH PRIVILEGES;
        ";
    }
    
    /**
     * 错误处理配置
     */
    public static function configureErrorHandling() {
        // 生产环境中不应该显示详细数据库错误
        ini_set('display_errors', 0);
        ini_set('log_errors', 1);
        
        // 自定义错误处理器
        set_error_handler(function($errno, $errstr, $errfile, $errline) {
            // 记录错误日志但不暴露给用户
            error_log("Database Error: $errstr in $errfile on line $errline");
            
            // 向用户显示通用错误信息
            if ($errno === E_ERROR || $errno === E_USER_ERROR) {
                http_response_code(500);
                echo "系统暂时不可用，请稍后再试。";
                exit(1);
            }
        });
    }
}

// 安全配置示例
// DatabaseSecurityConfig::configureErrorHandling();
?>
```

### SQL注入检测工具

```php
<?php
/**
 * 简单的SQL注入检测工具
 */
class SQLInjectionDetector {
    
    /**
     * 检测常见的SQL注入模式
     */
    public static function detectInjectionPatterns($input) {
        $patterns = [
            '/\b(UNION|SELECT|INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|EXEC|EXECUTE)\b/i',
            '/(\'\s*(OR|AND)\s*\'\s*=)/i',
            '/(;|\bWAITFOR\b|\bDELAY\b|\bBENCHMARK\b)/i',
            '/(\b(SELECT|UNION)\s+[\s\S]*?\bFROM\b)/i'
        ];
        
        foreach ($patterns as $pattern) {
            if (preg_match($pattern, $input)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * 日志可疑活动
     */
    public static function logSuspiciousActivity($input, $context = '') {
        $logEntry = [
            'timestamp' => date('Y-m-d H:i:s'),
            'ip' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown',
            'input' => $input,
            'context' => $context
        ];
        
        error_log("Suspicious SQL injection attempt: " . json_encode($logEntry));
    }
    
    /**
     * 综合安全检查
     */
    public static function securityCheck($input, $context = '') {
        if (self::detectInjectionPatterns($input)) {
            self::logSuspiciousActivity($input, $context);
            
            // 可以选择阻止请求或采取其他措施
            // http_response_code(400);
            // die('Invalid input detected');
            
            return false;
        }
        
        return true;
    }
}

// 使用示例
// $username = $_POST['username'] ?? '';
// if (!SQLInjectionDetector::securityCheck($username, 'login_username')) {
//     die('Security violation detected');
// }
?>
```

### SQL注入防护最佳实践

1. **始终使用预处理语句**：这是最有效的防护方法
2. **输入验证**：对所有用户输入进行严格验证
3. **最小权限原则**：数据库用户只授予必要的权限
4. **错误处理**：不要向用户显示详细的数据库错误信息
5. **定期审计**：使用自动化工具扫描代码漏洞
6. **安全编码培训**：确保开发人员了解安全编码实践
7. **使用ORM框架**：现代ORM框架内置了防注入保护
8. **参数化查询**：永远不要拼接用户输入到SQL字符串中

### 总结

SQL注入是Web应用面临的主要安全威胁之一，但通过使用预处理语句、输入验证、最小权限原则等措施可以有效防范。最重要的是要在开发过程中始终将安全性放在首位，采用安全的编码实践，并定期进行安全审计和测试。