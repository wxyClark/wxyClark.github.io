# Linux

遇到问题时要在第一时间看屏幕返回的提示和Nginx服务的error.log，获取有效信息以便解决问题


rz是一个很好的从本地上传文件的工具，参数-y表示覆盖和上传文件同名的内容

## 规则

### 权限最小化原则

### 更改配置前进行备份

### 平滑重启
* sshd nginx 等支持reload 的重启命令，优先使用reload，减少影响
* 有临时生效设置的，使用 临时+永久 不立即重启的方式配置，减少重启次数

### 重现错误过程排错，是优秀运维人员的重要本领之一

{% include list.liquid all=true %}