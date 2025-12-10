# TOKEN

## BASIC TOKEN

## OAUTH TOKEN

## JWT TOKEN

```php
## Laravel 构造token 绕过 登录验证
$user = []; // 模拟用户 读表 或 指定
$jwt_user = User::find($user['id']);
$token = JWTAuth::fromUser($jwt_user);

$jwt_user = User::find($user['id']);
$mes_account_code = '';
$account = [];
Auth::login($jwt_user);
$claims = [
    'account_code' => $mes_account_code,
    'user_name' => $user['user_name'],
    'account_coop_mode' => $account['coop_mode']
];
$token = auth('web')->getToken();
```

TODO 补充 claims 参数