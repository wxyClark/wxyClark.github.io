# 错误级别

```tip
顶级错误处理器 set_error_handler 一般用于捕捉 E_NOTICE 、E_USER_ERROR、E_USER_WARNING、E_USER_NOTICE 级别的错误，
不能捕捉 E_ERROR, E_PARSE, E_CORE_ERROR, E_CORE_WARNING, E_COMPILE_ERROR 和E_COMPILE_WARNING。
```

| 值   | 常量  | 说明  |
| ---- | ---- |---- |
| 1 | E_ERROR | 致命的运行时错误。脚本终止不再继续运行。如：内存不足 |
| 2 | E_WARNING | 运行时警告 (非致命错误)。仅给出提示信息，但是脚本不会终止运行。 |
| 4 | E_PARSE | 编译时语法解析错误。解析错误仅仅由分析器产生。 |
| 8 | E_NOTICE | 运行时通知。表示脚本遇到可能会表现为错误的情况，也可能没有错。 |
| A | B |C |
| 256 | E_USER_ERROR | 用户产生的错误信息。类似 E_ERROR, 使用PHP函数 trigger_error() 来产生的。 |
| 512 | E_USER_WARNING | 用户产生的错误信息。类似 E_WARNING, 使用PHP函数 trigger_error() 来产生的。 |
| 1024 | E_USER_NOTICE | 用户产生的错误信息。类似 E_NOTICE, 使用PHP函数 trigger_error() 来产生的。 |
| A | B |C |
| 8192 | E_DEPRECATED | 运行时通知。启用后将会对在未来版本中可能无法正常工作的代码给出警告。|
| A | B |C |
| 30719 | E_ALL | 用户产少的警告信息。 类似 E_DEPRECATED, 但是是由用户自己在代码中使用PHP函数 trigger_error()来产生的。 |



## 常规配置

生产：
开发：