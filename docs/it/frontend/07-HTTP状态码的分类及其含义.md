# HTTP状态码的分类及其含义

## 概要回答

HTTP状态码是服务器对客户端请求的响应状态的数字代码，分为5类：1xx(信息性状态码)、2xx(成功状态码)、3xx(重定向状态码)、4xx(客户端错误状态码)、5xx(服务器错误状态码)。每种状态码都有特定的含义，帮助客户端理解服务器的响应状态。

## 深度解析

### HTTP状态码的基本概念

HTTP状态码是服务器返回给客户端的三位数字代码，用于表示请求的处理结果。状态码的第一个数字定义了响应的类别，后两个数字没有分类作用。

### 状态码的分类

1. **1xx(信息性状态码)**：接收的请求正在处理
2. **2xx(成功状态码)**：请求正常处理完毕
3. **3xx(重定向状态码)**：需要后续操作才能完成这一请求
4. **4xx(客户端错误状态码)**：客户端原因导致服务器无法处理请求
5. **5xx(服务器错误状态码)**：服务器原因导致处理请求出错

### 状态码的工作原理

当客户端向服务器发送HTTP请求时，服务器会处理该请求并返回一个包含状态码的响应。客户端根据状态码判断请求是否成功，以及下一步应该采取什么行动。

## 示例代码

### 常见HTTP状态码详解

```javascript
// 常见HTTP状态码及含义
const httpStatusCodes = {
    // 1xx 信息性状态码
    100: 'Continue - 客户端应继续其请求',
    101: 'Switching Protocols - 服务器根据客户端的请求切换协议',
    
    // 2xx 成功状态码
    200: 'OK - 请求成功',
    201: 'Created - 资源创建成功',
    202: 'Accepted - 请求已被接受，但尚未处理完成',
    204: 'No Content - 请求成功但无返回内容',
    206: 'Partial Content - 服务器成功处理了部分GET请求',
    
    // 3xx 重定向状态码
    301: 'Moved Permanently - 永久重定向',
    302: 'Found - 临时重定向',
    304: 'Not Modified - 资源未修改，使用缓存',
    307: 'Temporary Redirect - 临时重定向，POST不会变成GET',
    308: 'Permanent Redirect - 永久重定向，POST不会变成GET',
    
    // 4xx 客户端错误状态码
    400: 'Bad Request - 请求语法错误',
    401: 'Unauthorized - 未授权',
    403: 'Forbidden - 禁止访问',
    404: 'Not Found - 资源不存在',
    405: 'Method Not Allowed - 请求方法不允许',
    409: 'Conflict - 请求冲突',
    410: 'Gone - 资源已不存在',
    413: 'Payload Too Large - 请求体过大',
    422: 'Unprocessable Entity - 请求格式正确但语义错误',
    429: 'Too Many Requests - 请求过于频繁',
    
    // 5xx 服务器错误状态码
    500: 'Internal Server Error - 服务器内部错误',
    501: 'Not Implemented - 服务器不支持请求的功能',
    502: 'Bad Gateway - 网关错误',
    503: 'Service Unavailable - 服务不可用',
    504: 'Gateway Timeout - 网关超时',
    505: 'HTTP Version Not Supported - HTTP版本不支持'
};

// 在实际项目中处理HTTP响应
async function handleApiResponse(url) {
    try {
        const response = await fetch(url);
        
        switch (response.status) {
            case 200:
                const data = await response.json();
                console.log('Success:', data);
                return data;
                
            case 304:
                console.log('Resource not modified, using cache');
                // 使用缓存数据
                break;
                
            case 404:
                throw new Error('Resource not found');
                
            case 500:
                throw new Error('Server error');
                
            default:
                throw new Error(`HTTP Error: ${response.status}`);
        }
    } catch (error) {
        console.error('API Error:', error.message);
        throw error;
    }
}
```

### 服务器端状态码设置(Node.js示例)

```javascript
// Node.js Express框架中设置HTTP状态码
const express = require('express');
const app = express();

// 200 OK - 成功响应
app.get('/users', (req, res) => {
    const users = [{ id: 1, name: 'Alice' }, { id: 2, name: 'Bob' }];
    res.status(200).json(users);
});

// 201 Created - 资源创建成功
app.post('/users', (req, res) => {
    const newUser = { id: 3, name: 'Charlie' };
    res.status(201).json(newUser);
});

// 400 Bad Request - 客户端请求错误
app.post('/users', (req, res) => {
    if (!req.body.name) {
        res.status(400).json({ error: 'Name is required' });
        return;
    }
    // 处理创建用户的逻辑
});

// 401 Unauthorized - 未授权
app.get('/protected', (req, res) => {
    const token = req.headers.authorization;
    if (!token) {
        res.status(401).json({ error: 'Authorization required' });
        return;
    }
    // 验证token逻辑
});

// 403 Forbidden - 禁止访问
app.delete('/admin/users/:id', (req, res) => {
    if (!req.user.isAdmin) {
        res.status(403).json({ error: 'Admin permission required' });
        return;
    }
    // 删除用户逻辑
});

// 404 Not Found - 资源不存在
app.get('/users/:id', (req, res) => {
    const user = findUserById(req.params.id);
    if (!user) {
        res.status(404).json({ error: 'User not found' });
        return;
    }
    res.json(user);
});

// 500 Internal Server Error - 服务器内部错误
app.get('/error', (req, res) => {
    try {
        // 可能出错的操作
        throw new Error('Something went wrong');
    } catch (error) {
        res.status(500).json({ error: 'Internal server error' });
    }
});
```

### 前端处理不同状态码

```javascript
// 前端JavaScript处理不同HTTP状态码
async function apiRequest(url, options = {}) {
    try {
        const response = await fetch(url, options);
        
        // 根据状态码分类处理
        if (response.status >= 200 && response.status < 300) {
            // 2xx 成功状态码
            return await response.json();
        } else if (response.status >= 300 && response.status < 400) {
            // 3xx 重定向状态码
            console.log('Redirecting to:', response.headers.get('Location'));
            // 浏览器通常会自动处理重定向
        } else if (response.status >= 400 && response.status < 500) {
            // 4xx 客户端错误状态码
            const errorData = await response.json();
            throw new ClientError(response.status, errorData.message || 'Client error');
        } else if (response.status >= 500) {
            // 5xx 服务器错误状态码
            throw new ServerError(response.status, 'Server error');
        }
    } catch (error) {
        if (error instanceof ClientError || error instanceof ServerError) {
            // 自定义错误类型处理
            handleError(error);
        } else {
            // 网络错误等其他异常
            throw new NetworkError('Network error occurred');
        }
    }
}

// 自定义错误类
class ClientError extends Error {
    constructor(status, message) {
        super(message);
        this.name = 'ClientError';
        this.status = status;
    }
}

class ServerError extends Error {
    constructor(status, message) {
        super(message);
        this.name = 'ServerError';
        this.status = status;
    }
}

class NetworkError extends Error {
    constructor(message) {
        super(message);
        this.name = 'NetworkError';
    }
}

// 错误处理函数
function handleError(error) {
    switch (error.status) {
        case 400:
            showErrorMessage('请求参数错误，请检查后重试');
            break;
        case 401:
            showErrorMessage('登录已过期，请重新登录');
            redirectToLogin();
            break;
        case 403:
            showErrorMessage('权限不足，无法访问该资源');
            break;
        case 404:
            showErrorMessage('请求的资源不存在');
            break;
        case 429:
            showErrorMessage('请求过于频繁，请稍后再试');
            break;
        case 500:
            showErrorMessage('服务器内部错误，请稍后再试');
            break;
        case 503:
            showErrorMessage('服务暂时不可用，请稍后再试');
            break;
        default:
            showErrorMessage('未知错误，请稍后再试');
    }
}

function showErrorMessage(message) {
    // 显示错误消息的UI逻辑
    console.error(message);
    // 可以显示toast提示、弹窗等
}

function redirectToLogin() {
    // 重定向到登录页面
    window.location.href = '/login';
}
```

### Axios拦截器处理状态码

```javascript
// 使用Axios拦截器统一处理HTTP状态码
import axios from 'axios';

// 创建axios实例
const apiClient = axios.create({
    baseURL: 'https://api.example.com',
    timeout: 10000
});

// 响应拦截器
apiClient.interceptors.response.use(
    // 成功响应处理
    response => {
        return response;
    },
    // 错误响应处理
    error => {
        const { response } = error;
        
        if (response) {
            // 服务器返回了错误状态码
            switch (response.status) {
                case 400:
                    console.error('Bad Request:', response.data.message);
                    break;
                case 401:
                    console.error('Unauthorized: Please log in');
                    // 可以触发登出逻辑
                    break;
                case 403:
                    console.error('Forbidden: Access denied');
                    break;
                case 404:
                    console.error('Not Found:', response.config.url);
                    break;
                case 429:
                    console.error('Too Many Requests: Rate limit exceeded');
                    break;
                case 500:
                    console.error('Internal Server Error');
                    break;
                case 502:
                    console.error('Bad Gateway');
                    break;
                case 503:
                    console.error('Service Unavailable');
                    break;
                default:
                    console.error(`HTTP Error ${response.status}: ${response.statusText}`);
            }
        } else if (error.request) {
            // 请求已发出但没有收到响应
            console.error('Network Error: No response received');
        } else {
            // 其他错误
            console.error('Error:', error.message);
        }
        
        return Promise.reject(error);
    }
);

// 使用示例
async function fetchUserData(userId) {
    try {
        const response = await apiClient.get(`/users/${userId}`);
        return response.data;
    } catch (error) {
        // 错误已经在拦截器中处理过了
        throw error;
    }
}
```

### 状态码在RESTful API中的应用

```javascript
// RESTful API中状态码的最佳实践
class UserController {
    // GET /users - 获取用户列表
    async getUsers(req, res) {
        try {
            const users = await User.findAll();
            res.status(200).json(users); // 200 OK
        } catch (error) {
            res.status(500).json({ error: 'Internal server error' }); // 500 服务器错误
        }
    }
    
    // GET /users/:id - 获取单个用户
    async getUser(req, res) {
        try {
            const user = await User.findById(req.params.id);
            if (user) {
                res.status(200).json(user); // 200 OK
            } else {
                res.status(404).json({ error: 'User not found' }); // 404 未找到
            }
        } catch (error) {
            res.status(500).json({ error: 'Internal server error' }); // 500 服务器错误
        }
    }
    
    // POST /users - 创建用户
    async createUser(req, res) {
        try {
            // 验证请求数据
            if (!req.body.name || !req.body.email) {
                return res.status(400).json({ error: 'Name and email are required' }); // 400 请求错误
            }
            
            const user = await User.create(req.body);
            res.status(201).json(user); // 201 创建成功
        } catch (error) {
            if (error.code === 'ER_DUP_ENTRY') {
                res.status(409).json({ error: 'User already exists' }); // 409 冲突
            } else {
                res.status(500).json({ error: 'Internal server error' }); // 500 服务器错误
            }
        }
    }
    
    // PUT /users/:id - 更新用户
    async updateUser(req, res) {
        try {
            const user = await User.findById(req.params.id);
            if (!user) {
                return res.status(404).json({ error: 'User not found' }); // 404 未找到
            }
            
            const updatedUser = await User.update(req.params.id, req.body);
            res.status(200).json(updatedUser); // 200 OK
        } catch (error) {
            res.status(500).json({ error: 'Internal server error' }); // 500 服务器错误
        }
    }
    
    // DELETE /users/:id - 删除用户
    async deleteUser(req, res) {
        try {
            const user = await User.findById(req.params.id);
            if (!user) {
                return res.status(404).json({ error: 'User not found' }); // 404 未找到
            }
            
            await User.delete(req.params.id);
            res.status(204).send(); // 204 无内容
        } catch (error) {
            res.status(500).json({ error: 'Internal server error' }); // 500 服务器错误
        }
    }
}
```

### 状态码在缓存策略中的应用

```javascript
// 利用HTTP状态码优化缓存策略
function setCacheHeaders(res, statusCode) {
    switch (statusCode) {
        case 200:
            // 成功响应可以缓存
            res.set('Cache-Control', 'public, max-age=3600'); // 缓存1小时
            break;
        case 304:
            // 304响应表示资源未修改，可以延长缓存时间
            res.set('Cache-Control', 'public, max-age=7200'); // 缓存2小时
            break;
        case 404:
            // 404错误可以短时间缓存，避免重复请求
            res.set('Cache-Control', 'public, max-age=60'); // 缓存1分钟
            break;
        case 500:
            // 服务器错误不应缓存
            res.set('Cache-Control', 'no-cache, no-store, must-revalidate');
            break;
        default:
            // 其他情况使用默认缓存策略
            res.set('Cache-Control', 'public, max-age=300'); // 缓存5分钟
    }
}

// 在Express中使用
app.get('/api/data', async (req, res) => {
    try {
        const data = await getData();
        res.status(200);
        setCacheHeaders(res, 200);
        res.json(data);
    } catch (error) {
        res.status(500);
        setCacheHeaders(res, 500);
        res.json({ error: 'Internal server error' });
    }
});
```

## HTTP状态码详细分类

### 1xx 信息性状态码

```javascript
// 1xx状态码较少使用，主要用于协议协商
const infoStatusCodes = {
    100: 'Continue - 客户端应继续其请求',
    101: 'Switching Protocols - 服务器根据客户端的请求切换协议',
    102: 'Processing - 服务器已接收并正在处理请求，但尚未完成',
    103: 'Early Hints - 用于提前发送响应头'
};
```

### 2xx 成功状态码

```javascript
// 2xx状态码表示请求成功处理
const successStatusCodes = {
    200: 'OK - 请求成功',
    201: 'Created - 资源创建成功',
    202: 'Accepted - 请求已被接受，但尚未处理完成',
    203: 'Non-Authoritative Information - 返回的信息可能来自另一来源',
    204: 'No Content - 请求成功但无返回内容',
    205: 'Reset Content - 服务器成功处理请求，但要求客户端重置文档视图',
    206: 'Partial Content - 服务器成功处理了部分GET请求',
    207: 'Multi-Status - 由WebDAV(RFC 2518)扩展的状态码',
    208: 'Already Reported - 在DAV中使用，表示资源已在之前的响应中报告',
    226: 'IM Used - 服务器满足了资源的GET请求，响应是对资源的一次或多次操作的结果'
};
```

### 3xx 重定向状态码

```javascript
// 3xx状态码表示需要客户端采取进一步的操作
const redirectStatusCodes = {
    300: 'Multiple Choices - 被请求的资源有一系列可供选择的回馈信息',
    301: 'Moved Permanently - 永久重定向',
    302: 'Found - 临时重定向',
    303: 'See Other - 查看其它地址',
    304: 'Not Modified - 资源未修改，使用缓存',
    305: 'Use Proxy - 被请求的资源必须通过指定的代理才能被访问',
    307: 'Temporary Redirect - 临时重定向，POST不会变成GET',
    308: 'Permanent Redirect - 永久重定向，POST不会变成GET'
};
```

### 4xx 客户端错误状态码

```javascript
// 4xx状态码表示客户端发送的请求有错误
const clientErrorStatusCodes = {
    400: 'Bad Request - 请求语法错误',
    401: 'Unauthorized - 未授权',
    402: 'Payment Required - 保留将来使用',
    403: 'Forbidden - 禁止访问',
    404: 'Not Found - 资源不存在',
    405: 'Method Not Allowed - 请求方法不允许',
    406: 'Not Acceptable - 服务器无法根据客户端请求的内容特性完成请求',
    407: 'Proxy Authentication Required - 请求要求代理的身份认证',
    408: 'Request Timeout - 服务器等待客户端发送的请求时间过长',
    409: 'Conflict - 请求冲突',
    410: 'Gone - 资源已不存在',
    411: 'Length Required - 服务器拒绝在没有定义Content-Length头的情况下接受请求',
    412: 'Precondition Failed - 客户端请求信息的先决条件错误',
    413: 'Payload Too Large - 请求体过大',
    414: 'URI Too Long - 请求的URI过长',
    415: 'Unsupported Media Type - 服务器无法处理请求附带的媒体格式',
    416: 'Range Not Satisfiable - 客户端请求的范围无效',
    417: 'Expectation Failed - 服务器无法满足Expect请求头信息的要求',
    418: 'I\'m a teapot - 一个幽默的状态码',
    421: 'Misdirected Request - 请求被指向到无法产生响应的服务器',
    422: 'Unprocessable Entity - 请求格式正确但语义错误',
    423: 'Locked - 资源被锁定',
    424: 'Failed Dependency - 请求失败依赖于之前的请求',
    426: 'Upgrade Required - 客户端应当切换到TLS/1.0',
    428: 'Precondition Required - 要求先决条件',
    429: 'Too Many Requests - 请求过于频繁',
    431: 'Request Header Fields Too Large - 请求头字段太大',
    451: 'Unavailable For Legal Reasons - 因法律原因不可用'
};
```

### 5xx 服务器错误状态码

```javascript
// 5xx状态码表示服务器在处理请求的过程中发生了错误
const serverErrorStatusCodes = {
    500: 'Internal Server Error - 服务器内部错误',
    501: 'Not Implemented - 服务器不支持请求的功能',
    502: 'Bad Gateway - 网关错误',
    503: 'Service Unavailable - 服务不可用',
    504: 'Gateway Timeout - 网关超时',
    505: 'HTTP Version Not Supported - HTTP版本不支持',
    506: 'Variant Also Negotiates - 服务器存在内部配置错误',
    507: 'Insufficient Storage - 服务器无法存储完成请求所必须的内容',
    508: 'Loop Detected - 服务器在处理请求时发现死循环',
    510: 'Not Extended - 获取资源所需要的策略并没有被满足',
    511: 'Network Authentication Required - 客户端需要进行身份验证才能获得网络访问权限'
};
```

## 最佳实践

### 1. 合理使用状态码

```javascript
// 好的做法：使用合适的状态码
app.post('/users', (req, res) => {
    // 创建资源成功
    res.status(201).json(newUser);
});

app.put('/users/:id', (req, res) => {
    // 更新资源成功
    res.status(200).json(updatedUser);
});

app.delete('/users/:id', (req, res) => {
    // 删除资源成功且无内容返回
    res.status(204).send();
});

// 避免总是返回200状态码
// res.status(200).json({ error: 'Something went wrong' }); // 不好的做法
```

### 2. 提供有意义的错误信息

```javascript
// 好的做法：提供详细的错误信息
res.status(400).json({
    error: 'Validation failed',
    details: {
        email: 'Email is required',
        password: 'Password must be at least 8 characters'
    }
});

// 避免返回模糊的错误信息
// res.status(400).json({ error: 'Bad request' }); // 不够具体
```

### 3. 保持一致性

```javascript
// 在整个API中保持状态码使用的一致性
// 所有创建资源的操作都返回201状态码
// 所有删除成功的操作都返回204状态码
// 所有资源未找到的情况都返回404状态码
```

## 总结

HTTP状态码是Web开发中的重要概念：

1. **五类状态码**：1xx(信息)、2xx(成功)、3xx(重定向)、4xx(客户端错误)、5xx(服务器错误)
2. **正确使用**：根据请求处理结果返回合适的状态码
3. **错误处理**：提供有意义的错误信息帮助客户端理解问题
4. **一致性**：在整个应用中保持状态码使用的统一

理解并正确使用HTTP状态码对于构建高质量的Web应用至关重要。