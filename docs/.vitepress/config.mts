import { defineConfig } from 'vitepress';
import { withMermaid } from "vitepress-plugin-mermaid";
import { resolve } from 'path';

export default withMermaid(defineConfig({
  // 设置基础路径为你的GitHub仓库名，这样GitHub Pages可以正确访问
  base: '/', 
  
  // 网站基本设置
  title: 'wxyClark 知识库', // 网站标题
  description: '基于 Obsidian 和 VitePress 构建的知识库, 缩短非软件开发人员与AI的距离', // 网站描述
  lang: 'zh-CN', // 语言
  
  // 响应式设计配置
  appearance: 'auto', // 支持暗色/亮色模式自动切换
  
  // 移动端优化
  head: [
    ['meta', { name: 'viewport', content: 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no' }],
    ['meta', { name: 'theme-color', content: '#3eaf7c' }], // 主题颜色
  ],
  
  // 避免docs目录外的文件被访问
  cleanUrls: true,
  
  // 构建输出目录（默认为.vitepress/dist，相对于docs目录）
  
  // 主题配置（控制网站外观）
  themeConfig: {
    // 顶部导航栏 - 根据docs下的一级目录创建
    nav: [
      { text: '首页', link: '/' },
      { text: 'AI', link: '/ai/' },
      { text: 'IT', link: '/it/' },
      { text: '生活', link: '/life/' },
      { text: '道', link: '/tao/' },
      { text: 'demo', link: '/demo/' },
      { text: '待归档', link: '/notes/' },
      { text: '试试手气', link: '/random-article' }
    ],
    // 左侧边栏导航 - 自动展开当前层级
    sidebar: {
      '/ai/': [
        {
          text: 'AI',
          items: [
            { text: '目录', link: '/ai/' }
          ]
        }
      ],
      '/it/': [
        {
          text: 'IT',
          items: [
            { text: '基础', link: '/it/base/' },
            { text: '前端', link: '/it/frontend/' },
            { text: '后端', link: '/it/backend/' },
            { text: '数据库', link: '/it/database/' },
            { text: '中间件', link: '/it/middleware/' },
            { text: '架构', link: '/it/architecture/' },
            { text: '算法', link: '/it/algorithm/' }
          ]
        }
      ],
      '/life/': [
        {
          text: 'Life',
          items: [
            { text: '目录', link: '/life/' }
          ]
        }
      ],
      '/tao/': [
        {
          text: 'Tao',
          items: [
            { text: '目录', link: '/tao/' }
          ]
        }
      ],
      '/demo/': [
        {
          text: 'Demo',
          items: [
            { text: 'Markdown 示例', link: '/demo/markdown-examples' }
          ]
        }
      ],
      '/notes/': [
        {
          text: 'Notes',
          items: [
            { text: '首页', link: '/notes/' }
          ]
        }
      ]
    },

    // 开启右侧"本页目录" (大纲)
    outline: {
      level: [2, 6], // 显示从 h2 到 h6 的标题
      label: '本页目录'
    },
    // 搜索框
    search: {
      provider: 'local'
    },
    // 页面底部显示"最后更新时间"
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
}));