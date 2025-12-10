# gitFlow

## merge代码的时候笔名多人操作，可能出现异常

remote branch tracking


## 重置develop分支

* 开发过程中，develop会积累不上线的垃圾代码，需要避免干扰；或需要在测试环境验证线上问题，需要重置develop分支；

```shell
# 本地操作
git checkout develop
git reset --hard master
# 【*】千万不要操作 git pull

git status
git push origin develop --force

# 【*】删除本地项目
git clone https://github.com/xxx/xxx.git
git checkout develop


# 开发环境重新拉取代码
git clone https://github.com/xxx/xxx.git
git checkout develop
```