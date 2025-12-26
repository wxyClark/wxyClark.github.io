# VitePress + Obsidian 构建 GithubPages 

## 账号准备

- github注册，注意 **用户名** 将作为github.io的 **二级域名** 前缀
- 创建 **用户名**.github.io 的空项目，Public

## 软件准备

### git
安装 [git](https://git-scm.com/)
```sh
git --version
```

### node.js
[Node.js](https://nodejs.org/zh-cn) 官网下载并安装 LTS (长期支持版，推荐 18 或更高版本)

```sh
node -v
npm -v
```

## 初始化

进入 git bash

```sh
# 创建一个名为 obsidianRepo 的文件夹
mkdir obsidianRepo  
# 进入这个文件夹
cd obsidianRepo     

# 初始化一个新的 npm 项目（一路按回车用默认值即可）
npm init -y
# 安装 VitePress 作为开发依赖
npm add -D vitepress@next
# 这个向导会帮你创建基础的文件结构
npx vitepress init
```

现在你的项目结构应该是这样的:
```text
my-knowledge-base
├── docs                    # 核心目录！你的所有 Obsidian 笔记都将放在这里
│   ├── .vitepress         # VitePress 配置目录
│   │   └── config.js      # 网站的主配置文件（马上会修改它）
│   ├── api-examples.md    # 示例文件，可删除
│   ├── markdown-examples.md # 示例文件，可删除
│   └── index.md           # 网站的首页
└── package.json           # 项目依赖记录
```

## 配置网站 (让网站有导航和功能)

### 配置
编辑  docs/.vitepress/config.js 替换文件
```javascript
export default {
  // 网站基本设置
  title: '我的知识库', // 网站标题
  description: '基于 Obsidian 和 VitePress 构建的知识库',
  lang: 'zh-CN', // 语言

  // 主题配置（控制网站外观）
  themeConfig: {
    // 顶部导航栏
    nav: [
      { text: '首页', link: '/' },
      { text: '知识库', link: '/notes/' } // 假设你的笔记都放在 /notes/ 目录下
    ],
    // 左侧边栏导航（这里是一个示例结构，未来可以自动化生成）
    sidebar: {
      // 当访问 /notes/ 路径时，显示这个侧边栏
      '/notes/': [
        {
          text: '开始',
          items: [
            { text: '欢迎', link: '/notes/' },
            { text: '如何使用本知识库', link: '/notes/how-to-use' }
          ]
        },
        {
          text: '学习笔记',
          collapsed: false, // 默认展开这个分组
          items: [
            { text: 'VitePress 搭建记录', link: '/notes/vitepress-setup' },
            { text: 'JavaScript 核心概念', link: '/notes/javascript-core' }
          ]
        }
      ]
    },
    // 开启右侧“本页目录” (大纲)
    outline: {
      level: [2, 6], // 显示从 h2 到 h6 的标题
      label: '本页目录'
    },
    // 搜索框
    search: {
      provider: 'local'
    },
    // 页面底部显示“最后更新时间”
    lastUpdated: true,
    // 社交链接（例如 GitHub）
    socialLinks: [
      { icon: 'github', link: 'https://github.com/你的用户名' }
    ]
  },
  // Markdown 扩展配置
  markdown: {
    // 启用行号
    lineNumbers: true,
    // 关键！启用 Mermaid 图表支持[citation:9]
    mermaid: true
  }
}
```

### 验证多级目录访问
在 docs 目录下创建 notes 文件夹，并添加一个 index.md 文件作为知识库的入口

* 启动本地预览 (先看看网站长什么样)
```sh
npm run docs:dev
```