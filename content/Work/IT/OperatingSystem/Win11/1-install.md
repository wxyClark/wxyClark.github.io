---
sort: 1
---

# 系统安装


[官方镜像下载](https://www.microsoft.com/zh-cn/software-download/windows11)

升级Windows 11的最低系统要求：
- CPU：1GHz 双核
- 内存：4G RAM
- 存储：64G
- BIOS：支持UEFI安全启动
- 显示器：9英寸，720P分辨率

## 安装方式
1、windows硬盘安装

[知乎 无需PE，绕过TPM2.0限制升级Win11](https://zhuanlan.zhihu.com/p/417296843)

[B站 不要PE，绕过TPM2.0限制升级Win11](https://www.bilibili.com/read/cv13789090)

- 下载Win_11_Boot_And_Upgrade_FiX_KiT_v2.0
- Windows11.iso下载 并移动到 TOOL_PATH\\Source_ISO\W11下
- 执行TOOL_PATH\Win_11_Boot_And_Upgrade_FiX_KiT_v2.0汉化by知彼而知己.cmd 文件
- 输入 2 等待脚本执行结束，解压 Windows11_FIXED_2021-12-27.ISO 文件
- 【断网】，执行解压的iso目录下的setup.exe

2、U盘安装

- [下载windows官方升级工具](https://www.microsoft.com/zh-cn/software-download/windows11)
- [制作启动U盘【至少8G】](https://www.bilibili.com/read/cv13486273)
- BIOS修改UEFI启动

## 跳过TPM2.0

[Win11安装前跳过TPM](http://baijiahao.xitongzhijia.net/article/218025.html)
- 按住"Win+R / Shift+F10"，输入 " regedit "，打开注册表编辑器
- 新建注册表项

```angular2html
导航到 "HKEY_LOCAL_MACHINE\SYSTEM\Setup"，
右击 创建一个名为 "LabConfig" 的项
 新建2个 DWORD（32位）值：
    输入名称：BypassTPMCheck 值：1
    输入名称：BypassSecureBootCheck 值：1
```
- 点击ESC 返回，继续安装

## 磁盘分区

[NTFS整数G分区计算](https://www.iplaysoft.com/tools/partition-calculator/)

| 磁盘  | 分配(M)  | 大小(G) | 备注 |
| ---- | ---- | ---- | ----- |
| C盘 | 131850M | 128G | 131078M + 100M + 16M [+ 654M]|
| D盘 | 32774M | 32G | BackUp |
| NTFS盘 | 65539M | 64G | Work |
| NTFS盘 | 102407M | 100G | Do |
| NTFS盘 | 204806M | 200G | File |
| NTFS盘 | 262147M | 256G | Video |
| NTFS盘 | 512002M | 500G | Library |
