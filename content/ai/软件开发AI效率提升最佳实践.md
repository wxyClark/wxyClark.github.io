# 软件开发 AI 效率提升最佳实践

## 一、通用 AI 辅助开发原则

### 1. AI 工具选择
- **代码补全**: GitHub Copilot、Cursor、Codeium（免费）
- **代码审查**: CodeGeeX、Tabby
- **文档生成**: ChatGPT、Claude、DeepSeek
- **代码解释**: Sourcegraph Cody、Bloop
- **调试助手**: AI Debugging Tools

### 2. 提示词工程最佳实践
```
# 好的提示词结构：
[角色] 你是一位资深的[语言]工程师
[任务] 请帮我[具体任务]
[上下文] 当前项目使用[框架/库]，代码风格遵循[规范]
[约束] 要求代码[具体要求]，包含[测试/注释]
[输出] 返回[代码片段/完整文件/解释]
```

### 3. 工作流优化
- **需求分析**: AI 辅助理解需求文档
- **架构设计**: AI 生成初始架构草图
- **代码生成**: AI 生成基础代码框架
- **代码审查**: AI 检查代码质量和安全
- **测试生成**: AI 自动生成测试用例
- **文档编写**: AI 生成 API 文档和注释

---

## 二、PHP 开发最佳实践

### 1. AI 辅助开发工具

#### 免费工具组合
- **代码补全**: Codeium（VS Code 插件，免费）
- **代码生成**: ChatGPT / DeepSeek / Claude
- **代码审查**: PHPStan + AI 解释
- **测试生成**: PHPUnit + AI 辅助

#### VS Code 配置
```json
{
  "php.validate.executablePath": "C:/php/php.exe",
  "intelephense.environment.phpVersion": "8.2",
  "intelephense.files.maxSize": 5000000
}
```

### 2. Laravel 项目 AI 实践

#### 快速生成 CRUD
```bash
# 使用 AI 生成完整 CRUD 代码
# 提示词示例：
"生成一个 Laravel 10 的 User 模型，包含以下字段：
- name (string, required)
- email (string, unique, required)
- password (string, required)
- status (enum: active, inactive, default: active)
- created_at, updated_at

要求：
1. 生成 Migration
2. 生成 Model with fillable, casts, relationships
3. 生成 Controller with index, store, show, update, destroy
4. 生成 FormRequest 验证
5. 生成 Resource API 响应
6. 生成 Factory 和 Seeder
7. 包含完整注释
8. 遵循 PSR-12 编码规范"
```

#### AI 生成的最佳实践代码

**Migration 示例**:
```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->string('password');
            $table->enum('status', ['active', 'inactive'])->default('active');
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
```

**Model 示例**:
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasFactory, Notifiable, HasApiTokens, SoftDeletes;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'status',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'created_at' => 'datetime',
            'updated_at' => 'datetime',
        ];
    }

    /**
     * Scope a query to only include active users.
     */
    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }
}
```

### 3. AI 辅助调试技巧

#### 错误分析提示词
```
"我遇到以下错误，请帮我分析原因并提供解决方案：

错误信息：
[粘贴完整错误堆栈]

相关代码：
[粘贴相关代码片段]

环境信息：
- PHP 版本：8.2
- Laravel 版本：10.x
- 数据库：MySQL 8.0

要求：
1. 分析错误原因
2. 提供详细的修复步骤
3. 给出预防类似错误的建议
4. 如果需要代码修改，提供完整代码"
```

### 4. AI 自动生成测试

#### PHPUnit 测试生成
```bash
# 提示词
"为以下 UserController 生成完整的 PHPUnit 测试类：

[粘贴 UserController 代码]

要求：
1. 测试所有方法（index, store, show, update, destroy）
2. 包含正常场景和异常场景
3. 使用 Factory 生成测试数据
4. 测试验证规则
5. 测试权限控制（如果有）
6. 使用数据提供者测试多种情况
7. 遵循 Laravel 测试最佳实践"
```

### 5. PHP AI 开发检查清单

- [ ] 使用 Codeium 进行代码补全
- [ ] 使用 AI 生成基础 CRUD 代码
- [ ] 使用 PHPStan 进行静态分析
- [ ] 使用 AI 生成单元测试
- [ ] 使用 AI 生成 API 文档
- [ ] 使用 AI 优化 SQL 查询
- [ ] 使用 AI 检查安全漏洞

---

## 三、Go 开发最佳实践

### 1. AI 辅助开发工具

#### 免费工具组合
- **代码补全**: Codeium / Cursor（免费版）
- **代码生成**: ChatGPT / DeepSeek / Claude
- **代码审查**: golangci-lint + AI 解释
- **测试生成**: AI 生成 table-driven tests

#### VS Code 配置
```json
{
  "go.useLanguageServer": true,
  "go.lintTool": "golangci-lint",
  "go.lintOnSave": "package",
  "go.formatTool": "goimports",
  "go.buildOnSave": "package",
  "go.testFlags": ["-v", "-race"],
  "go.coverOnSingleTest": true
}
```

### 2. Go 项目 AI 实践

#### 快速生成 REST API
```bash
# 提示词示例
"生成一个 Go REST API，使用 Gin 框架，实现用户管理功能：

要求：
1. User 结构体包含：ID, Name, Email, Password, Status, CreatedAt, UpdatedAt
2. 实现 CRUD 接口：
   - GET /users - 获取用户列表（分页、过滤）
   - GET /users/:id - 获取单个用户
   - POST /users - 创建用户（验证必填字段）
   - PUT /users/:id - 更新用户
   - DELETE /users/:id - 删除用户
3. 使用 GORM 操作数据库
4. 包含输入验证
5. 包含错误处理
6. 包含日志记录
7. 遵循 Go 最佳实践和项目结构
8. 包含完整的注释"
```

#### AI 生成的最佳实践代码

**项目结构**:
```
project/
├── cmd/
│   └── server/
│       └── main.go
├── internal/
│   ├── handler/
│   │   └── user.go
│   ├── model/
│   │   └── user.go
│   ├── repository/
│   │   └── user.go
│   ├── service/
│   │   └── user.go
│   └── middleware/
│       └── auth.go
├── pkg/
│   └── database/
│       └── database.go
├── go.mod
└── go.sum
```

**Handler 示例**:
```go
package handler

import (
    "net/http"
    "strconv"

    "github.com/gin-gonic/gin"

    "your-project/internal/model"
    "your-project/internal/service"
)

type UserHandler struct {
    userService *service.UserService
}

func NewUserHandler(userService *service.UserService) *UserHandler {
    return &UserHandler{
        userService: userService,
    }
}

// CreateUser 创建用户
// @Summary 创建用户
// @Tags users
// @Accept json
// @Produce json
// @Param user body model.CreateUserRequest true "用户信息"
// @Success 201 {object} model.User
// @Router /users [post]
func (h *UserHandler) CreateUser(c *gin.Context) {
    var req model.CreateUserRequest
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": "无效的请求参数",
            "details": err.Error(),
        })
        return
    }

    user, err := h.userService.CreateUser(&req)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{
            "error": "创建用户失败",
            "details": err.Error(),
        })
        return
    }

    c.JSON(http.StatusCreated, user)
}

// GetUser 获取用户
// @Summary 获取用户
// @Tags users
// @Produce json
// @Param id path int true "用户ID"
// @Success 200 {object} model.User
// @Router /users/{id} [get]
func (h *UserHandler) GetUser(c *gin.Context) {
    id, err := strconv.ParseUint(c.Param("id"), 10, 64)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": "无效的用户ID",
        })
        return
    }

    user, err := h.userService.GetUserByID(uint(id))
    if err != nil {
        c.JSON(http.StatusNotFound, gin.H{
            "error": "用户不存在",
        })
        return
    }

    c.JSON(http.StatusOK, user)
}
```

### 3. AI 辅助并发编程

#### 并发模式生成
```bash
# 提示词
"生成一个 Go Worker Pool 实现，用于处理批量任务：

要求：
1. 支持动态调整 worker 数量
2. 支持任务超时控制
3. 支持优雅关闭
4. 包含错误处理和重试机制
5. 包含性能监控指标
6. 提供使用示例
7. 包含完整的注释和文档"
```

### 4. AI 自动生成测试

#### Table-driven Tests 生成
```bash
# 提示词
"为以下函数生成完整的 table-driven tests：

[粘贴函数代码]

要求：
1. 覆盖所有分支和边界情况
2. 包含正常场景和异常场景
3. 使用 subtests 组织测试
4. 包含 benchmark 测试
5. 使用 testify 断言库
6. 包含测试数据表"
```

### 5. Go AI 开发检查清单

- [ ] 使用 Codeium 进行代码补全
- [ ] 使用 golangci-lint 进行代码检查
- [ ] 使用 AI 生成 table-driven tests
- [ ] 使用 AI 优化并发代码
- [ ] 使用 AI 生成 Swagger 文档
- [ ] 使用 AI 检查 race condition
- [ ] 使用 AI 优化性能

---

## 四、Python 开发最佳实践

### 1. AI 辅助开发工具

#### 免费工具组合
- **代码补全**: Codeium / Cursor（免费版）
- **代码生成**: ChatGPT / DeepSeek / Claude
- **代码审查**: Ruff / Pylint + AI 解释
- **测试生成**: AI 生成 pytest 测试

#### VS Code 配置
```json
{
  "python.defaultInterpreterPath": "${workspaceFolder}/.venv/Scripts/python.exe",
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "python.linting.ruffEnabled": true,
  "python.formatting.provider": "black",
  "python.testing.pytestEnabled": true,
  "python.testing.pytestArgs": ["tests"]
}
```

### 2. Python 项目 AI 实践

#### 快速生成 FastAPI 项目
```bash
# 提示词示例
"生成一个 FastAPI 项目，实现用户管理功能：

要求：
1. 使用 Pydantic 进行数据验证
2. 实现以下接口：
   - POST /api/users/register - 用户注册
   - POST /api/users/login - 用户登录（JWT）
   - GET /api/users/me - 获取当前用户信息
   - PUT /api/users/me - 更新用户信息
   - GET /api/users - 获取用户列表（分页）
3. 使用 SQLAlchemy ORM
4. 包含密码加密
5. 包含 JWT 认证中间件
6. 包含 CORS 配置
7. 包含完整的错误处理
8. 包含 API 文档
9. 遵循 Python 最佳实践"
```

#### AI 生成的最佳实践代码

**项目结构**:
```
project/
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── api/
│   │   ├── __init__.py
│   │   └── v1/
│   │       ├── __init__.py
│   │       └── users.py
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py
│   │   └── security.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── user.py
│   ├── schemas/
│   │   ├── __init__.py
│   │   └── user.py
│   └── db/
│       ├── __init__.py
│       └── session.py
├── tests/
│   ├── __init__.py
│   └── test_users.py
├── .env
├── requirements.txt
└── pyproject.toml
```

**API 示例**:
```python
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app.core.security import (
    create_access_token,
    verify_password,
    get_password_hash,
    get_current_user,
)
from app.db.session import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserResponse, Token

router = APIRouter()


@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register(user: UserCreate, db: Session = Depends(get_db)):
    """
    用户注册

    - **email**: 用户邮箱（唯一）
    - **password**: 用户密码（至少8位）
    - **name**: 用户姓名
    """
    # 检查邮箱是否已存在
    existing_user = db.query(User).filter(User.email == user.email).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="邮箱已被注册"
        )

    # 创建新用户
    db_user = User(
        email=user.email,
        name=user.name,
        hashed_password=get_password_hash(user.password),
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)

    return db_user


@router.post("/login", response_model=Token)
async def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    """
    用户登录

    返回 JWT access token
    """
    # 查找用户
    user = db.query(User).filter(User.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="邮箱或密码错误",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # 生成 token
    access_token = create_access_token(data={"sub": user.email})

    return {"access_token": access_token, "token_type": "bearer"}
```

### 3. AI 辅助数据处理

#### Pandas 代码生成
```bash
# 提示词
"生成一个 Python 脚本，使用 Pandas 处理 CSV 数据：

需求：
1. 读取 data.csv 文件
2. 清洗数据：删除重复行、处理缺失值
3. 数据转换：日期格式转换、字符串标准化
4. 数据分析：计算统计指标、分组聚合
5. 数据可视化：生成柱状图、折线图
6. 导出处理后的数据到 processed.csv
7. 包含完整的错误处理
8. 包含进度显示
9. 使用类型注解
10. 包含详细的注释"
```

### 4. AI 自动生成测试

#### Pytest 测试生成
```bash
# 提示词
"为以下 FastAPI 路由生成完整的 pytest 测试：

[粘贴路由代码]

要求：
1. 使用 pytest-asyncio
2. 使用测试数据库（SQLite）
3. 测试所有端点
4. 包含正常场景和异常场景
5. 测试认证和授权
6. 使用 fixtures
7. 测试数据验证
8. 包含性能测试
9. 使用 pytest-cov 测试覆盖率"
```

### 5. Python AI 开发检查清单

- [ ] 使用 Codeium 进行代码补全
- [ ] 使用 Ruff 进行代码检查
- [ ] 使用 Black 进行代码格式化
- [ ] 使用 AI 生成 pytest 测试
- [ ] 使用 AI 优化数据处理代码
- [ ] 使用 AI 生成类型注解
- [ ] 使用 AI 检查安全漏洞

---

## 五、前端开发最佳实践

### 1. AI 辅助开发工具

#### 免费工具组合
- **代码补全**: Codeium / Cursor（免费版）
- **代码生成**: ChatGPT / DeepSeek / Claude
- **UI 组件**: shadcn/ui + AI 定制
- **样式生成**: AI 生成 Tailwind CSS
- **测试生成**: AI 生成 Vitest 测试

#### VS Code 配置
```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "typescript.tsdk": "node_modules/typescript/lib",
  "tailwindCSS.experimental.classRegex": [
    ["cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]"]
  ]
}
```

### 2. React 项目 AI 实践

#### 快速生成组件
```bash
# 提示词示例
"生成一个 React 组件，使用 TypeScript + Tailwind CSS：

组件需求：用户卡片列表
1. 显示用户头像、姓名、邮箱、状态
2. 支持分页
3. 支持搜索过滤
4. 支持按状态筛选
5. 加载状态显示
6. 空状态显示
7. 响应式设计
8. 使用 shadcn/ui 组件库
9. 包含完整的类型定义
10. 包含错误处理
11. 使用 React Hooks
12. 遵循 React 最佳实践"
```

#### AI 生成的最佳实践代码

**组件示例**:
```tsx
import { useState, useEffect } from 'react';
import { Search, Filter, UserPlus } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Skeleton } from '@/components/ui/skeleton';

interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  status: 'active' | 'inactive' | 'pending';
}

interface UserListProps {
  users: User[];
  loading?: boolean;
  onAddUser?: () => void;
}

export function UserList({ users, loading = false, onAddUser }: UserListProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;

  // 过滤用户
  const filteredUsers = users.filter((user) => {
    const matchesSearch =
      user.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.email.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesStatus =
      statusFilter === 'all' || user.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  // 分页
  const totalPages = Math.ceil(filteredUsers.length / itemsPerPage);
  const paginatedUsers = filteredUsers.slice(
    (currentPage - 1) * itemsPerPage,
    currentPage * itemsPerPage
  );

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active':
        return 'bg-green-500';
      case 'inactive':
        return 'bg-gray-500';
      case 'pending':
        return 'bg-yellow-500';
      default:
        return 'bg-gray-500';
    }
  };

  const getInitials = (name: string) => {
    return name
      .split(' ')
      .map((n) => n[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  };

  if (loading) {
    return (
      <div className="space-y-4">
        {[...Array(5)].map((_, i) => (
          <Card key={i}>
            <CardContent className="p-4">
              <div className="flex items-center space-x-4">
                <Skeleton className="h-12 w-12 rounded-full" />
                <div className="space-y-2">
                  <Skeleton className="h-4 w-[200px]" />
                  <Skeleton className="h-3 w-[150px]" />
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* 工具栏 */}
      <div className="flex flex-col sm:flex-row gap-4">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
          <Input
            placeholder="搜索用户..."
            value={searchQuery}
            onChange={(e) => {
              setSearchQuery(e.target.value);
              setCurrentPage(1);
            }}
            className="pl-10"
          />
        </div>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-[180px]">
            <Filter className="mr-2 h-4 w-4" />
            <SelectValue placeholder="状态筛选" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">全部状态</SelectItem>
            <SelectItem value="active">活跃</SelectItem>
            <SelectItem value="inactive">非活跃</SelectItem>
            <SelectItem value="pending">待审核</SelectItem>
          </SelectContent>
        </Select>
        {onAddUser && (
          <Button onClick={onAddUser}>
            <UserPlus className="mr-2 h-4 w-4" />
            添加用户
          </Button>
        )}
      </div>

      {/* 用户列表 */}
      {paginatedUsers.length === 0 ? (
        <Card>
          <CardContent className="p-12 text-center">
            <p className="text-gray-500">没有找到匹配的用户</p>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-3">
          {paginatedUsers.map((user) => (
            <Card key={user.id} className="hover:shadow-md transition-shadow">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-4">
                    <Avatar>
                      <AvatarImage src={user.avatar} alt={user.name} />
                      <AvatarFallback>{getInitials(user.name)}</AvatarFallback>
                    </Avatar>
                    <div>
                      <CardTitle className="text-base">{user.name}</CardTitle>
                      <p className="text-sm text-gray-500">{user.email}</p>
                    </div>
                  </div>
                  <Badge className={getStatusColor(user.status)}>
                    {user.status}
                  </Badge>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      {/* 分页 */}
      {totalPages > 1 && (
        <div className="flex justify-center space-x-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
            disabled={currentPage === 1}
          >
            上一页
          </Button>
          <span className="flex items-center px-4 text-sm text-gray-600">
            第 {currentPage} / {totalPages} 页
          </span>
          <Button
            variant="outline"
            size="sm"
            onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
            disabled={currentPage === totalPages}
          >
            下一页
          </Button>
        </div>
      )}
    </div>
  );
}
```

### 3. AI 辅助样式生成

#### Tailwind CSS 生成
```bash
# 提示词
"生成一个响应式的登录页面，使用 Tailwind CSS：

需求：
1. 居中的登录卡片
2. 包含邮箱和密码输入框
3. 包含登录按钮和忘记密码链接
4. 包含社交登录选项
5. 响应式设计（移动端适配）
6. 包含加载状态
7. 包含表单验证样式
8. 使用 shadcn/ui 组件
9. 现代化的设计风格
10. 暗色模式支持"
```

### 4. AI 自动生成测试

#### Vitest 测试生成
```bash
# 提示词
"为以下 React 组件生成完整的 Vitest 测试：

[粘贴组件代码]

要求：
1. 使用 @testing-library/react
2. 测试组件渲染
3. 测试用户交互
4. 测试 props 传递
5. 测试异步操作
6. 测试错误状态
7. 使用快照测试
8. 测试可访问性
9. 测试响应式行为
10. 包含 mock 数据"
```

### 5. 前端 AI 开发检查清单

- [ ] 使用 Codeium 进行代码补全
- [ ] 使用 AI 生成组件代码
- [ ] 使用 AI 生成 Tailwind CSS 样式
- [ ] 使用 AI 生成 Vitest 测试
- [ ] 使用 AI 优化性能
- [ ] 使用 AI 生成 Storybook 文档
- [ ] 使用 AI 检查可访问性

---

## 六、跨语言 AI 协作最佳实践

### 1. API 契约优先开发
```bash
# 提示词
"生成前后端通用的 API 契约文档：

需求：
1. 使用 OpenAPI 3.0 规范
2. 包含用户管理相关接口
3. 包含完整的请求/响应示例
4. 包含错误码定义
5. 包含认证说明
6. 生成 TypeScript 类型定义
7. 生成 PHP Request/Response 类
8. 生成 Go 结构体
9. 生成 Python Pydantic 模型"
```

### 2. 数据库 Schema 同步
```bash
# 提示词
"根据数据库表结构生成各语言的模型定义：

表结构：
[粘贴 SQL 或 Migration]

生成：
1. Laravel Eloquent Model
2. Go GORM Model
3. Python SQLAlchemy Model
4. TypeScript Interface
5. 包含完整的类型定义和注释"
```

### 3. 统一错误处理
```bash
# 提示词
"生成前后端统一的错误处理方案：

需求：
1. 定义标准错误码和错误消息
2. 生成 PHP 异常处理类
3. 生成 Go 错误处理中间件
4. 生成 Python 异常处理
5. 生成前端错误拦截器
6. 生成错误类型定义（TypeScript）
7. 包含日志记录"
```

---

## 七、AI 提示词模板库

### 代码生成模板
```
请生成[语言]代码，实现[功能描述]：

技术栈：
- 框架：[框架名称]
- 数据库：[数据库类型]
- 其他依赖：[依赖列表]

功能需求：
1. [需求1]
2. [需求2]
3. [需求3]

代码要求：
- 遵循[语言]最佳实践
- 包含完整的类型定义
- 包含详细的注释
- 包含错误处理
- 包含单元测试
- 使用[代码风格]规范
```

### 代码审查模板
```
请审查以下代码，指出问题和改进建议：

代码：
[粘贴代码]

审查要点：
1. 代码质量和可读性
2. 性能优化建议
3. 安全漏洞检查
4. 最佳实践遵循
5. 错误处理是否完善
6. 是否有潜在的 bug

请提供：
- 问题列表（按优先级排序）
- 改进建议的具体代码
- 预防类似问题的建议
```

### 调试辅助模板
```
我遇到以下问题，请帮我分析：

问题描述：
[描述问题]

错误信息：
[粘贴错误信息]

相关代码：
[粘贴代码片段]

环境信息：
- [语言]版本：[版本号]
- 框架版本：[版本号]
- 操作系统：[系统信息]

已尝试的解决方法：
1. [方法1]
2. [方法2]

请提供：
1. 问题原因分析
2. 详细的解决步骤
3. 预防类似问题的建议
4. 如果需要代码修改，提供完整代码
```

---

## 八、效率提升技巧

### 1. 批量代码生成
- 使用 AI 一次性生成多个相关文件
- 使用模板统一代码风格
- 建立代码片段库

### 2. 自动化工作流
- 使用 GitHub Actions 自动化测试和部署
- 使用 AI 生成 CI/CD 配置
- 使用 pre-commit hooks 自动格式化

### 3. 文档自动化
- 使用 AI 生成 API 文档
- 使用 AI 生成 README
- 使用 AI 生成变更日志

### 4. 学习资源
- 使用 AI 解释复杂代码
- 使用 AI 生成学习计划
- 使用 AI 推荐最佳实践

---

## 九、常见问题与解决方案

### 1. AI 代码质量不可靠
**解决方案**:
- 始终进行代码审查
- 编写单元测试验证
- 使用静态分析工具
- 逐步引入 AI 生成的代码

### 2. AI 不理解项目上下文
**解决方案**:
- 提供清晰的项目背景
- 粘贴相关代码片段
- 说明技术栈和约束
- 使用项目专属提示词

### 3. AI 生成代码不符合规范
**解决方案**:
- 在提示词中明确规范要求
- 使用代码格式化工具
- 配置 linter 规则
- 建立代码审查流程

---

## 十、快速检查清单

### PHP 项目
- [ ] Codeium 代码补全已启用
- [ ] PHPStan 静态分析已配置
- [ ] AI 生成的基础代码已审查
- [ ] 单元测试已生成并运行
- [ ] API 文档已生成

### Go 项目
- [ ] Codeium 代码补全已启用
- [ ] golangci-lint 已配置
- [ ] AI 生成的代码已通过 lint
- [ ] Table-driven tests 已生成
- [ ] Swagger 文档已生成

### Python 项目
- [ ] Codeium 代码补全已启用
- [ ] Ruff/Black 已配置
- [ ] 类型注解已添加
- [ ] Pytest 测试已生成
- [ ] API 文档已生成

### 前端项目
- [ ] Codeium 代码补全已启用
- [ ] ESLint/Prettier 已配置
- [ ] TypeScript 类型已定义
- [ ] Vitest 测试已生成
- [ ] Storybook 文档已生成

---

**记住：AI 是助手，不是替代品。始终进行代码审查和测试，确保代码质量和安全性！**