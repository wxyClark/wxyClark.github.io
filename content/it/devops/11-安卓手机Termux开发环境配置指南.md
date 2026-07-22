---
title: 安卓手机 Termux 开发环境配置指南
description: 无需科学上网，在安卓手机上配置 Termux/ZeroTermux，连接 GitHub，安装 Ubuntu，运行 Mimo/Opencode CLI
---

# 安卓手机 Termux 开发环境配置指南

> 本指南适用于 **国内网络环境**，无需科学上网，纯手机端操作。

---

## 目录

1. [安装 Termux / ZeroTermux](#1-安装-termux--zerotermux)
2. [换源（国内镜像加速）](#2-换源国内镜像加速)
3. [基础包安装与配置](#3-基础包安装与配置)
4. [配置 GitHub 支持（Pull 代码到手机）](#4-配置-github-支持pull-代码到手机)
5. [在 Termux 中安装 Ubuntu (proot-distro)](#5-在-termux-中安装-ubuntu-proot-distro)
6. [Ubuntu 内安装 Mimo](#6-ubuntu-内安装-mimo)
7. [Ubuntu 内安装 Opencode](#7-ubuntu-内安装-opencode)
8. [常见问题](#8-常见问题)

---

## 1. 安装 Termux / ZeroTermux

### 方案 A：ZeroTermux（推荐，内置中文）

从 GitHub 国内镜像下载 ZeroTermux 的 APK：

```
https://github.com/hanxinhao000/ZeroTermux/releases
```

如果 GitHub 访问慢，使用镜像站：

```
https://mirror.ghproxy.com/https://github.com/hanxinhao000/ZeroTermux/releases/download/v0.118.0/ZeroTermux_v0.118.0.apk
```

下载后直接在手机文件管理器中点击安装即可。  
> 如果提示"禁止安装未知来源应用"，在设置中允许即可。

### 方案 B：Termux（官方原版）

从 F-Droid 下载（**不要从 Google Play 下载，版本太旧**）：

```
https://f-droid.org/packages/com.termux/
```

或者在 F-Droid 客户端中搜索 "Termux" 安装。

---

## 2. 换源（国内镜像加速）

安装后打开 Termux / ZeroTermux，执行以下命令切换为清华源：

```bash
sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
```

更新包索引：

```bash
pkg update -y
```

升级已有包：

```bash
pkg upgrade -y
```

---

## 3. 基础包安装与配置

### 3.1 安装常用工具

```bash
pkg install -y curl wget git openssh vim python nodejs-lts
```

### 3.2 配置存储权限（访问手机文件）

```bash
termux-setup-storage
```

在弹出的系统对话框中点击 **允许**。  
之后手机存储会挂载到 `~/storage` 目录。

### 3.3 配置 Git 用户信息

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

---

## 4. 配置 GitHub 支持（Pull 代码到手机）

### 4.1 生成 SSH 密钥

```bash
ssh-keygen -t ed25519 -C "your@email.com"
```

一直按回车使用默认路径（`~/.ssh/id_ed25519`）和空密码。

### 4.2 查看并复制公钥

```bash
cat ~/.ssh/id_ed25519.pub
```

复制输出的全部内容。

### 4.3 添加到 GitHub

- 浏览器打开 `https://github.com/settings/keys`
- 点击 **New SSH key**
- Title 任意填写（如 "Phone Termux"）
- Key 粘贴刚才复制的公钥内容
- 点击 **Add SSH key**

### 4.4 测试连接

```bash
ssh -T git@github.com
```

如果看到 `Hi xxx! You've successfully authenticated` 说明配置成功。

### 4.5 Pull 代码到手机

```bash
# 克隆仓库
git clone git@github.com:你的用户名/仓库名.git

# 如果已有仓库，拉取最新代码
cd 仓库名
git pull
```

---

## 5. 在 Termux 中安装 Ubuntu (proot-distro)

### 5.1 安装 proot-distro

```bash
pkg install -y proot-distro
```

### 5.2 列出可安装的发行版

```bash
proot-distro list
```

### 5.3 安装 Ubuntu

```bash
proot-distro install ubuntu
```

### 5.4 进入 Ubuntu

```bash
proot-distro login ubuntu
```

### 5.5 Ubuntu 内换源（阿里云镜像）

进入 Ubuntu 后，替换 apt 源：

```bash
sed -i 's@ports.ubuntu.com@mirrors.aliyun.com@g' /etc/apt/sources.list
```

更新 Ubuntu 包索引：

```bash
apt update && apt upgrade -y
```

### 5.6 Ubuntu 内安装基础开发工具

```bash
apt install -y curl wget git vim python3 python3-pip nodejs npm build-essential
```

---

## 6. Ubuntu 内安装 Mimo

> Mimo 是一个轻量级 AI 编程助手 CLI 工具。

### 6.1 使用 pip 安装

```bash
pip3 install mimo-cli
```

### 6.2 验证安装

```bash
mimo --version
```

### 6.3 配置 Mimo（可选）

```bash
mimo config
```

按提示配置 API Key 等信息。

---

## 7. Ubuntu 内安装 Opencode

> Opencode 是一个智能编码 CLI 工具。

### 7.1 方式一：通过 npm 安装（推荐）

```bash
npm install -g @opencode-ai/cli
```

### 7.2 方式二：通过 curl 安装

```bash
curl -fsSL https://opencode.ai/install.sh | bash
```

### 7.3 验证安装

```bash
opencode --version
```

### 7.4 配置 Opencode

```bash
opencode config
```

### 7.5 在项目中使用

```bash
cd /path/to/your/project
opencode
```

---

## 8. 常见问题

### Q1: 安装包时提示 "Connection refused"

换源后重新运行：

```bash
pkg update && pkg upgrade -y
```

### Q2: Git clone 速度慢

代理拉取（在 Termux 中，不是在 Ubuntu 里）：

```bash
git clone https://mirror.ghproxy.com/https://github.com/用户名/仓库名.git
```

### Q3: 退出 Ubuntu

```bash
exit
```

### Q4: 删除 Ubuntu

```bash
proot-distro remove ubuntu
```

### Q5: 字体太小

- ZeroTermux：在左侧面板 → 样式设置 → 调整字号
- Termux：长按屏幕 → More → Style → 调整 Font Size

### Q6: 如何开启 Termux 后台运行

ZeroTermux 自带后台保活功能，在左侧面板开启即可。  
普通 Termux 可使用 `termux-wake-lock`：

```bash
pkg install termux-api
termux-wake-lock
```

### Q7: 中文输入法问题

ZeroTermux 内置了中文输入支持。  
普通 Termux 需要安装：

```bash
pkg install termux-extra
```

并在输入法设置中选择合适的输入法。

---

## 参考链接

- [Termux 官方文档](https://termux.dev/)
- [ZeroTermux GitHub](https://github.com/hanxinhao000/ZeroTermux)
- [清华 Termux 镜像源](https://mirrors.tuna.tsinghua.edu.cn/help/termux/)
- [Proot-Distro GitHub](https://github.com/termux/proot-distro)
- [Opencode 官网](https://opencode.ai)
