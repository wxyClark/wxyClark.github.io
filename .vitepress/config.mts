export default {
  // 网站基本设置
  title: 'wxyClark 知识库', // 网站标题
  description: '基于 Obsidian 和 VitePress 构建的知识库, 拉近非软件开发人员与AI的距离', // 网站描述
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
      { icon: 'github', link: 'https://github.com/wxyClark' }
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