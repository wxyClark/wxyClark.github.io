# Flowable

```tip
开源工作流项目
```

## docker部署

[flowable all-in-one](https://hub.docker.com/r/flowable/all-in-one)

```shell
docker run -p 8080:8080 flowable/all-in-one

Flowable IDM (http://localhost:8080/flowable-idm)
Flowable Modeler (http://localhost:8080/flowable-modeler)
Flowable Task (http://localhost:8080/flowable-task)
Flowable Admin (http://localhost:8080/flowable-admin)

user: admin
password: test
```


## 数据库转MySQL

```tip
flowable 默认数据库是H2
```

[工作流框架：支持MySQL的Flowable安装](https://blog.csdn.net/chancein007/article/details/122483279)