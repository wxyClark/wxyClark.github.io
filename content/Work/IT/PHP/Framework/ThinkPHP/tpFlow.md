# TP-FLow工作流引擎

```danger
代码开源
文档收钱
前后端融合
```

## 部署

```sh
# ThinkPHP项目更新、加载依赖
git clone https://gitee.com/ntdgg/tpflow-demo
composer update
> 复制thinkphp官方项目的 .env文件
> 修改.htaccess重定向脚本 RewriteRule ^(.*)$ index.php/ [L,E=PATH_INFO:$1]

# 加载tpflow包
composer require guoguo/tpflow

# 复制 vendor/guoguo/tpflow/assets/work/ 目录到 public/static/ 目录下
# 复制 vendor/guoguo/tpflow/src/config/tpflow.php 到 config/ 目录下
```

## 操作步骤

* 【测试业务】——添加(业务单据基础数据)
* 【工作流】——添加(流程)，【流程】——设计(拖拽流程图)
* 【测试业务】——发起(业务单据基础数据)