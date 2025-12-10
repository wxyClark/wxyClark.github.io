# 通用规则

## 路由
* guest模式 支持注册、获取验证码、找回密码
* login模式 登录才能访问数据 验签()
* inner模式 内部系统间调用， 验签()

## 日志

* 只记录业务数据变更，不记录 id,updated_at、updated_by
* 设置通用的日志数据格式、日志生成方式

## 代码组织

* Controllers
> 一级目录：web api middleware openApi
> 二级目录：模块/子项