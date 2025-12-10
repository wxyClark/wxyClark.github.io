# Chrome浏览器

## 下载
  [Chrome](https://www.google.cn/chrome/) 右下角选择 “中文 - 中国”
  
## 插件
  [参考资料](https://www.cnplugins.com/tool/howtobackupchromeplugins.html)
  
  [chrome 网上应用店](https://chrome.google.com/webstore)
  
### 推荐插件
* Adblock Plus - 免费的广告拦截器
* Octotree - GitHub code tree
* SpanTree - GitLab Tree
* Postman Interceptor
* Xdebug helpe
* Enable Copy
* Image Downloader
* Video Speed Controller
*  购物党自动比价工具

### 插件打包备份
* 浏览器地址栏输入:chrome://extensions/，选择开发模式，单击打包扩展程序
* 进入chrome插件的安装目录，C:\Users\【当前用户名称】\AppData\Local\Google\Chrome\User Data\Default\Extensions目录下
* 看到许多以id号命名的目录，这些文件就是插件，进入id目录，会看到一个版本号目录
  
### 重新载入备份的chrome插件
#### 方法一
* 右击Chrome 桌面快捷方式，选择-"属性"-"快捷方式"，
* 然后在"目标"一栏尾部添加参数 --enable-easy-off-store-extension-install，
* 然后再运行浏览器就可以像以前那样正常安装Web Store之外的第三方扩展应用及脚本程序了
#### 方法二
* 首先把需要安装的第三方插件，后缀.crx 改成 .rar，然后解压，得到一个文件夹
* 再打开chrome://extensions/ 谷歌扩展应用管理，
* 点击右上角的开发者模式，就可以看到“加载正在开发的扩展程序”这一选项。
* 选择刚才步骤1中解压好的文件夹，确定
* 确认新增扩展程序，点击添加，成功添加应用程序。
  
