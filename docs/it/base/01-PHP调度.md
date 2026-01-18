# PHP调度

## 概要回答

PHP调度是指PHP解释器如何管理和执行PHP脚本的过程。在Web环境中，PHP通过FastCGI或mod_php等方式与Web服务器协作，处理HTTP请求。PHP的调度机制包括进程管理、请求分发、资源分配等环节，其中PHP-FPM（FastCGI Process Manager）是目前最常用的PHP进程管理器，它通过主进程和子进程的协作来高效处理并发请求。

## 深度解析

### 1. PHP执行模型

#### 1.1 CGI模式
传统的CGI模式下，每个HTTP请求都会启动一个新的PHP进程来处理，处理完成后进程即终止。这种方式简单但效率低下，因为每次请求都需要重新初始化PHP环境。

```php
// CGI模式下的简单处理流程
// 1. Web服务器接收请求
// 2. 启动PHP-CGI进程
// 3. 传递请求数据给PHP-CGI
// 4. PHP-CGI解析并执行脚本
// 5. 返回结果给Web服务器
// 6. 终止PHP-CGI进程
```

#### 1.2 FastCGI模式
FastCGI是对CGI的改进，通过持久化进程来处理多个请求，避免了频繁的进程创建和销毁开销。

```php
// FastCGI模式下的处理流程
// 1. FastCGI进程管理器启动多个PHP进程
// 2. Web服务器接收请求
// 3. 将请求转发给空闲的PHP进程
// 4. PHP进程处理请求并返回结果
// 5. PHP进程回到空闲状态，等待下一个请求
```

#### 1.3 mod_php模式
在Apache服务器中，可以通过mod_php模块将PHP解释器直接嵌入到Apache进程中，每个Apache子进程都包含一个PHP解释器实例。

```php
// mod_php模式下的处理流程
// 1. Apache接收请求
// 2. 直接在Apache进程中调用PHP解释器
// 3. PHP解释器处理脚本
// 4. 返回结果给客户端
```

### 2. PHP-FPM架构

PHP-FPM（FastCGI Process Manager）是PHP的FastCGI实现，提供了更好的进程管理功能。

#### 2.1 进程池管理
PHP-FPM通过进程池来管理PHP进程，每个进程池可以配置不同的参数：

```ini
; www.conf 配置示例
[www]
; 进程管理模式
pm = dynamic

; 静态模式下启动的子进程数
pm.max_children = 50

; 动态模式下初始子进程数
pm.start_servers = 5

; 动态模式下最小空闲进程数
pm.min_spare_servers = 5

; 动态模式下最大空闲进程数
pm.max_spare_servers = 35

; 最大请求数，超过后重启进程
pm.max_requests = 500
```

#### 2.2 进程状态监控
PHP-FPM提供了状态监控功能，可以查看进程池的状态信息：

```php
// 状态监控输出示例
/*
pool:                 www
process manager:      dynamic
start time:           01/Jan/2023:00:00:00 +0800
start since:          3600
accepted conn:        12345
listen queue:         0
max listen queue:     10
listen queue len:     128
idle processes:       5
active processes:     3
total processes:      8
max active processes: 10
max children reached: 0
slow requests:        0
*/
```

### 3. 请求处理流程

#### 3.1 请求接收
PHP-FPM通过Unix Domain Socket或TCP Socket接收来自Web服务器的请求：

```php
// 模拟PHP-FPM请求接收流程
class PHPPMProcess {
    private $socket;
    private $workers = [];
    
    public function __construct($socketPath) {
        // 创建监听socket
        $this->socket = socket_create(AF_UNIX, SOCK_STREAM, 0);
        socket_bind($this->socket, $socketPath);
        socket_listen($this->socket);
    }
    
    public function start() {
        // 启动工作进程
        for ($i = 0; $i < 5; $i++) {
            $this->spawnWorker();
        }
        
        // 主循环接收请求
        while (true) {
            $client = socket_accept($this->socket);
            if ($client) {
                $this->dispatchRequest($client);
            }
        }
    }
    
    private function spawnWorker() {
        $pid = pcntl_fork();
        if ($pid == 0) {
            // 子进程处理请求
            $this->workerLoop();
            exit(0);
        } else {
            // 父进程记录子进程PID
            $this->workers[] = $pid;
        }
    }
    
    private function workerLoop() {
        while (true) {
            // 等待任务分配
            $task = $this->waitForTask();
            if ($task) {
                $this->processTask($task);
            }
        }
    }
    
    private function dispatchRequest($client) {
        // 将请求分配给空闲的工作进程
        $worker = $this->getFreeWorker();
        if ($worker) {
            $this->sendTaskToWorker($worker, $client);
        } else {
            // 没有空闲进程，排队等待
            $this->queueRequest($client);
        }
    }
}
```

#### 3.2 请求解析
PHP解释器解析HTTP请求数据，包括GET/POST参数、HTTP头、Cookie等：

```php
// 请求解析示例
class RequestParser {
    public function parse($rawRequest) {
        // 解析请求行
        $lines = explode("\r\n", $rawRequest);
        $requestLine = $lines[0];
        list($method, $uri, $protocol) = explode(' ', $requestLine);
        
        // 解析HTTP头
        $headers = [];
        $bodyStart = 0;
        for ($i = 1; $i < count($lines); $i++) {
            if (empty($lines[$i])) {
                $bodyStart = $i + 1;
                break;
            }
            list($key, $value) = explode(':', $lines[$i], 2);
            $headers[trim($key)] = trim($value);
        }
        
        // 解析请求体
        $body = implode("\r\n", array_slice($lines, $bodyStart));
        
        return [
            'method' => $method,
            'uri' => $uri,
            'protocol' => $protocol,
            'headers' => $headers,
            'body' => $body
        ];
    }
}
```

#### 3.3 脚本执行
PHP Zend引擎编译并执行PHP脚本：

```php
// PHP脚本执行流程
class PHPEngine {
    public function execute($script) {
        // 1. 词法分析
        $tokens = $this->tokenize($script);
        
        // 2. 语法分析
        $ast = $this->parse($tokens);
        
        // 3. 编译为操作码
        $opcodes = $this->compile($ast);
        
        // 4. 执行操作码
        $result = $this->executeOpcodes($opcodes);
        
        return $result;
    }
    
    private function tokenize($script) {
        // 词法分析实现
        return token_get_all($script);
    }
    
    private function parse($tokens) {
        // 语法分析实现
        // 构建抽象语法树(AST)
        return $this->buildAST($tokens);
    }
    
    private function compile($ast) {
        // 编译为操作码
        return $this->generateOpcodes($ast);
    }
    
    private function executeOpcodes($opcodes) {
        // 执行操作码
        $executor = new OpcodeExecutor();
        return $executor->run($opcodes);
    }
}
```

### 4. 性能优化

#### 4.1 OPcache优化
PHP 5.5+内置了OPcache扩展，可以缓存编译后的操作码：

```php
// OPcache配置示例
/*
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
*/
```

#### 4.2 进程调优
合理配置PHP-FPM进程参数可以提升性能：

```ini
; 性能优化配置示例
[www]
; 使用静态进程管理模式
pm = static
pm.max_children = 100

; 启用慢日志
slowlog = /var/log/php-fpm-slow.log
request_slowlog_timeout = 5s

; 限制请求时间
request_terminate_timeout = 30s

; 优化TCP连接
listen.backlog = 65536
```

#### 4.3 内存管理
PHP的内存管理机制对性能有重要影响：

```php
// 内存管理示例
class MemoryManager {
    private $heap;
    private $usedMemory = 0;
    
    public function allocate($size) {
        // 检查内存限制
        if ($this->usedMemory + $size > $this->getMemoryLimit()) {
            throw new Exception("Memory limit exceeded");
        }
        
        // 分配内存
        $ptr = $this->heap->malloc($size);
        $this->usedMemory += $size;
        
        return $ptr;
    }
    
    public function deallocate($ptr, $size) {
        // 释放内存
        $this->heap->free($ptr);
        $this->usedMemory -= $size;
    }
    
    private function getMemoryLimit() {
        return ini_get('memory_limit');
    }
}
```

## 总结

PHP调度机制是PHP Web应用性能的关键因素。理解PHP的执行模型、进程管理、请求处理流程有助于优化应用性能。通过合理配置PHP-FPM、启用OPcache、优化内存管理等方式，可以显著提升PHP应用的处理能力和响应速度。