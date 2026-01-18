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
    // 左侧边栏导航 - 按路径动态生成
    sidebar: {
      // AI 目录完整配置
      '/ai/': [
        {
          text: 'AI',
          items: [
            { text: '目录', link: '/ai/' },
            { text: 'AI基础知识', link: '/ai/01_AI基础知识' },
            { text: 'RAG技术原理', link: '/ai/02_RAG技术原理' },
            { text: 'Agent架构设计', link: '/ai/03_Agent架构设计' },
            { text: '工作流搭建', link: '/ai/04_工作流搭建' },
            { text: '工程化实践', link: '/ai/05_工程化实践' },
            { text: 'AI开发最佳实践', link: '/ai/AI开发最佳实践' },
            { text: 'RAG系统从0到1搭建指南', link: '/ai/RAG系统从0到1搭建指南' },
            { text: '术语表', link: '/ai/术语表' },
            { text: '软件开发AI效率提升最佳实践', link: '/ai/软件开发AI效率提升最佳实践' }
          ]
        }
      ],
      // IT 目录完整配置
      '/it/': [
        {
          text: 'IT',
          items: [
            { text: 'IT 目录', link: '/it/' },
            { text: '算法', link: '/it/algorithm/' },
            { text: '架构', link: '/it/architecture/' },
            { text: '后端', link: '/it/backend/' },
            { text: '基础', link: '/it/base/' },
            { text: '复杂系统设计', link: '/it/complex/' },
            { text: '数据库', link: '/it/database/' },
            { text: 'DevOps', link: '/it/devops/' },
            { text: '前端', link: '/it/frontend/' },
            { text: 'Go语言', link: '/it/go/' },
            { text: '领导力', link: '/it/leader/' },
            { text: '中间件', link: '/it/middleware/' },
            { text: 'NoSQL', link: '/it/nosql/' },
            { text: '面向对象编程', link: '/it/oop/' },
            { text: 'PHP', link: '/it/php/' },
            { text: 'Python3', link: '/it/python3/' }
          ]
        }
      ],
      // IT/Algorithm 目录
      '/it/algorithm/': [
        {
          text: '算法',
          items: [
            { text: '算法 目录', link: '/it/algorithm/' }
          ]
        }
      ],
      // IT/Architecture 目录
      '/it/architecture/': [
        {
          text: '架构',
          items: [
            { text: '架构 目录', link: '/it/architecture/' }
          ]
        }
      ],
      // IT/Backend 目录
      '/it/backend/': [
        {
          text: '后端',
          items: [
            { text: '后端 目录', link: '/it/backend/' }
          ]
        }
      ],
      // IT/Base 目录
      '/it/base/': [
        {
          text: '基础',
          items: [
            { text: '基础 目录', link: '/it/base/' },
            { text: 'PHP调度', link: '/it/base/01-PHP调度' },
            { text: 'MySQL MVCC、B+树', link: '/it/base/02-MySQL MVCC、 B+树' },
            { text: 'ES 倒排索引', link: '/it/base/03-ES 倒排索引' },
            { text: 'MQ', link: '/it/base/04-MQ' },
            { text: '拿到一个需求，开发的完整流程是怎样的', link: '/it/base/05-拿到一个需求，开发的完整流程是怎样的' },
            { text: 'Laravel框架生命周期', link: '/it/base/06-Laravel框架每次请求的生命周期，框架本身用到哪些设计模式' },
            { text: 'Yii2框架生命周期', link: '/it/base/07-Yii2框架每次请求的生命周期，框架本身用到哪些设计模式' },
            { text: 'ThinkPHP框架生命周期', link: '/it/base/08-ThinkPHP框架每次请求的生命周期，框架本身用到哪些设计模式' },
            { text: 'Hyperf框架生命周期', link: '/it/base/09-Hyperf框架每次请求的生命周期，框架本身用到哪些设计模式' },
            { text: 'Workerman框架生命周期', link: '/it/base/10-workerman框架每次请求的生命周期，框架本身用到哪些设计模式' }
          ]
        }
      ],
      // IT/Complex 目录
      '/it/complex/': [
        {
          text: '复杂系统设计',
          items: [
            { text: '复杂系统设计 目录', link: '/it/complex/' },
            { text: '微服务架构的优缺点', link: '/it/complex/01-微服务架构的优缺点' },
            { text: '如何设计合理的服务拆分边界', link: '/it/complex/02-如何设计合理的服务拆分边界' },
            { text: '服务间的通信方式有哪些？各有什么特点？', link: '/it/complex/03-服务间的通信方式有哪些？各有什么特点？' },
            { text: '如何实现分布式事务？', link: '/it/complex/04-如何实现分布式事务？' },
            { text: 'CAP理论在分布式系统中的应用？', link: '/it/complex/05-CAP理论在分布式系统中的应用？' },
            { text: '服务注册发现的原理和实现？', link: '/it/complex/06-服务注册发现的原理和实现？' },
            { text: '负载均衡策略有哪些？', link: '/it/complex/07-负载均衡策略有哪些？' },
            { text: '熔断器模式的原理和作用？', link: '/it/complex/08-熔断器模式的原理和作用？' },
            { text: 'API网关的作用和设计要点？', link: '/it/complex/09-API网关的作用和设计要点？' },
            { text: '如何监控和追踪分布式系统的调用链？', link: '/it/complex/10-如何监控和追踪分布式系统的调用链？' },
            { text: '如何进行PHP应用的性能分析？', link: '/it/complex/11-如何进行PHP应用的性能分析？' },
            { text: 'Xdebug的使用方法和性能影响？', link: '/it/complex/12-Xdebug的使用方法和性能影响？' },
            { text: 'OPcache的作用和配置优化？', link: '/it/complex/13-OPcache的作用和配置优化？' },
            { text: '如何优化PHP应用的内存使用？', link: '/it/complex/14-如何优化PHP应用的内存使用？' },
            { text: '数据库查询优化的方法有哪些？', link: '/it/complex/15-数据库查询优化的方法有哪些？' },
            { text: '前端资源压缩和CDN加速的实现？', link: '/it/complex/16-前端资源压缩和CDN加速的实现？' },
            { text: '如何减少HTTP请求次数？', link: '/it/complex/17-如何减少HTTP请求次数？' },
            { text: '图片懒加载和响应式图片的实现？', link: '/it/complex/18-图片懒加载和响应式图片的实现？' },
            { text: '代码层面的性能优化技巧？', link: '/it/complex/19-代码层面的性能优化技巧？' },
            { text: '如何设计高性能的API接口？', link: '/it/complex/20-如何设计高性能的API接口？' },
            { text: '如何防范SQL注入攻击？', link: '/it/complex/21-如何防范SQL注入攻击？' },
            { text: 'XSS攻击的原理和防护措施？', link: '/it/complex/22-XSS攻击的原理和防护措施？' },
            { text: 'CSRF攻击的防范方法？', link: '/it/complex/23-CSRF攻击的防范方法？' },
            { text: 'JWT的原理和安全注意事项？', link: '/it/complex/24-JWT的原理和安全注意事项？' },
            { text: 'OAuth2.0的授权流程？', link: '/it/complex/25-OAuth2.0的授权流程？' },
            { text: '密码应该如何安全存储？', link: '/it/complex/26-密码应该如何安全存储？' },
            { text: 'HTTPS的原理和配置要点？', link: '/it/complex/27-HTTPS的原理和配置要点？' },
            { text: '如何防范DDoS攻击？', link: '/it/complex/28-如何防范DDoS攻击？' },
            { text: 'API接口的安全认证方式有哪些？', link: '/it/complex/29-API接口的安全认证方式有哪些？' },
            { text: '文件上传的安全风险和防范措施？', link: '/it/complex/30-文件上传的安全风险和防范措施？' }
          ]
        }
      ],
      // IT/Database 目录
      '/it/database/': [
        {
          text: '数据库',
          items: [
            { text: '数据库 目录', link: '/it/database/' }
          ]
        }
      ],
      // IT/DevOps 目录
      '/it/devops/': [
        {
          text: 'DevOps',
          items: [
            { text: 'DevOps 目录', link: '/it/devops/' },
            { text: 'Docker原理和PHP应用', link: '/it/devops/01-Docker原理和PHP应用' },
            { text: 'CI_CD流水线设计', link: '/it/devops/02-CI_CD流水线设计' },
            { text: 'Kubernetes基本概念', link: '/it/devops/03-Kubernetes基本概念' },
            { text: '蓝绿部署和滚动更新', link: '/it/devops/04-蓝绿部署和滚动更新' },
            { text: '灰度发布', link: '/it/devops/05-灰度发布' },
            { text: '日志收集和分析', link: '/it/devops/06-日志收集和分析' },
            { text: '监控告警系统', link: '/it/devops/07-监控告警系统' },
            { text: '容量规划', link: '/it/devops/08-容量规划' },
            { text: '故障排查和应急响应', link: '/it/devops/09-故障排查和应急响应' },
            { text: '自动化运维工具', link: '/it/devops/10-自动化运维工具' }
          ]
        }
      ],
      // IT/Frontend 目录
      '/it/frontend/': [
        {
          text: '前端',
          items: [
            { text: '前端 目录', link: '/it/frontend/' },
            { text: 'JavaScript中的闭包', link: '/it/frontend/01-JavaScript中的闭包是什么？请举例说明其应用场景' },
            { text: '常见中级前端面试题10道', link: '/it/frontend/01-常见中级前端面试题10道' },
            { text: 'CSS盒模型的理解', link: '/it/frontend/02-CSS盒模型的理解及其两种模式的区别' },
            { text: 'JavaScript原型链和继承', link: '/it/frontend/03-JavaScript中的原型链和继承是如何工作的？' },
            { text: 'Promise的理解和使用', link: '/it/frontend/04-如何理解和使用Promise？它解决了什么问题？' },
            { text: '事件冒泡和事件捕获', link: '/it/frontend/05-什么是事件冒泡和事件捕获？如何阻止事件冒泡？' },
            { text: 'Vue.js双向数据绑定', link: '/it/frontend/06-Vue.js中的双向数据绑定是如何实现的？' },
            { text: 'HTTP状态码', link: '/it/frontend/07-HTTP状态码的分类及其含义' },
            { text: '前端性能优化', link: '/it/frontend/08-如何优化前端性能？列举几种常用方法' },
            { text: '跨域问题及解决方案', link: '/it/frontend/09-什么是跨域问题？如何解决？' },
            { text: '前后端对接效率提升', link: '/it/frontend/10-前后端对接过程中怎样提升效率' }
          ]
        }
      ],
      // IT/Middleware 目录
      '/it/middleware/': [
        {
          text: '中间件',
          items: [
            { text: '中间件 目录', link: '/it/middleware/' },
            { text: 'Redis数据结构和使用场景', link: '/it/middleware/01-Redis数据结构和使用场景' },
            { text: 'Redis持久化机制', link: '/it/middleware/02-Redis持久化机制' },
            { text: '缓存雪崩、穿透、击穿防护', link: '/it/middleware/03-缓存雪崩、穿透、击穿防护' },
            { text: 'Redis集群原理和数据分片策略', link: '/it/middleware/04-Redis集群原理和数据分片策略' },
            { text: 'Memcached和Redis区别', link: '/it/middleware/05-Memcached和Redis区别' },
            { text: '消息队列的作用和使用场景', link: '/it/middleware/06-消息队列的作用和使用场景' },
            { text: 'RabbitMQ和Kafka区别', link: '/it/middleware/07-RabbitMQ和Kafka区别' },
            { text: '消息可靠投递保障', link: '/it/middleware/08-消息可靠投递保障' },
            { text: '消息顺序性和幂等性处理', link: '/it/middleware/09-消息顺序性和幂等性处理' },
            { text: '延迟消息的实现方式', link: '/it/middleware/10-延迟消息的实现方式' }
          ]
        }
      ],
      // IT/NoSQL 目录
      '/it/nosql/': [
        {
          text: 'NoSQL',
          items: [
            { text: 'NoSQL 目录', link: '/it/nosql/' },
            { text: 'MySQL索引原理和慢查询优化', link: '/it/nosql/01-MySQL索引原理和慢查询优化' },
            { text: '事务ACID特性和隔离级别', link: '/it/nosql/02-事务ACID特性和隔离级别' },
            { text: 'N+1查询问题及解决方案', link: '/it/nosql/03-N+1查询问题及解决方案' },
            { text: '数据库连接池的作用和实现原', link: '/it/nosql/04-数据库连接池的作用和实现原' },
            { text: '分库分表策略和实现', link: '/it/nosql/05-分库分表策略和实现' },
            { text: '数据库读写分离设计', link: '/it/nosql/06-数据库读写分离设计' },
            { text: 'ORM优缺点和原生SQL使用场景', link: '/it/nosql/07-ORM优缺点和原生SQL使用场景' },
            { text: '悲观锁和乐观锁实现方式', link: '/it/nosql/08-悲观锁和乐观锁实现方式' },
            { text: '数据一致性和完整性保证', link: '/it/nosql/09-数据一致性和完整性保证' },
            { text: '数据库备份和恢复最佳实践', link: '/it/nosql/10-数据库备份和恢复最佳实践' }
          ]
        }
      ],
      // IT/OOP 目录
      '/it/oop/': [
        {
          text: '面向对象编程',
          items: [
            { text: '面向对象编程 目录', link: '/it/oop/' },
            { text: 'MVC模式优缺点', link: '/it/oop/01-MVC模式优缺点' },
            { text: '依赖注入和控制反转', link: '/it/oop/02-依赖注入和控制反转' },
            { text: '服务容器设计', link: '/it/oop/03-服务容器设计' },
            { text: 'Laravel中间件原理', link: '/it/oop/04-Laravel中间件原理' },
            { text: 'Laravel服务提供者和门面模式', link: '/it/oop/05-Laravel服务提供者和门面模式' },
            { text: '设计模式使用', link: '/it/oop/06-设计模式使用' },
            { text: '单例模式', link: '/it/oop/07-单例模式' },
            { text: '工厂模式', link: '/it/oop/08-工厂模式' },
            { text: '观察者模式', link: '/it/oop/09-观察者模式' },
            { text: '插件系统设计', link: '/it/oop/10-插件系统设计' }
          ]
        }
      ],
      // IT/PHP 目录
      '/it/php/': [
        {
          text: 'PHP',
          items: [
            { text: 'PHP 目录', link: '/it/php/' },
            { text: 'PHP7和PHP8新特性', link: '/it/php/01-PHP7和PHP8新特性' },
            { text: 'PHP引用传值和复制传值', link: '/it/php/02-PHP引用传值和复制传值' },
            { text: 'PHP命名空间', link: '/it/php/03-PHP命名空间' },
            { text: 'PHP trait详解', link: '/it/php/04-PHP_trait详解' },
            { text: 'PHP魔术方法', link: '/it/php/05-PHP魔术方法' },
            { text: 'PHP生命周期', link: '/it/php/06-PHP生命周期' },
            { text: 'PHP内存泄漏处理', link: '/it/php/07-PHP内存泄漏处理' },
            { text: 'PHP协程和异步编程', link: '/it/php/08-PHP协程和异步编程' },
            { text: 'PHP自动加载器', link: '/it/php/09-PHP自动加载器' },
            { text: 'PHP SPL标准库', link: '/it/php/10-PHP SPL标准库' }
          ]
        }
      ],
      // IT/Python3 目录
      '/it/python3/': [
        {
          text: 'Python3',
          items: [
            { text: 'Python3 目录', link: '/it/python3/' },
            { text: '基础入门-变量数据类型运算符', link: '/it/python3/01-基础入门-变量数据类型运算符' },
            { text: '控制流与函数-条件循环函数', link: '/it/python3/02-控制流与函数-条件循环函数' },
            { text: '面向对象编程-类继承多态', link: '/it/python3/03-面向对象编程-类继承多态' },
            { text: '高级特性-装饰器生成器上下文管理器', link: '/it/python3/04-高级特性-装饰器生成器上下文管理器' },
            { text: '常用模块与文件操作', link: '/it/python3/05-常用模块与文件操作' },
            { text: '异常处理与调试', link: '/it/python3/06-异常处理与调试' },
            { text: '易混淆知识点对比', link: '/it/python3/07-易混淆知识点对比' },
            { text: 'Python3与PHP语法特性对比', link: '/it/python3/08-Python3与PHP语法特性对比' }
          ]
        }
      ],
      // IT/Go 目录
      '/it/go/': [
        {
          text: 'Go语言',
          items: [
            { text: 'Go语言适合的开发场景', link: '/it/go/01-Go语言适和的开发场景' },
            { text: '用法差异、快速入门方法', link: '/it/go/02-用法差异、快速入门方法' },
            { text: '思想差异、使用场景', link: '/it/go/03-思想差异、使用场景' },
            { text: '主流框架快速入门', link: '/it/go/04-主流框架快速入门' },
            { text: 'Go主流框架介绍、对比', link: '/it/go/05-Go主流框架介绍、对比、适合开发哪些类型的项目' },
            { text: '跨境电商系统技术组合', link: '/it/go/06-在跨境电商系统中Go、PHP、Vue怎样组合是最优的' }
          ]
        }
      ],
      // IT/Leader 目录
      '/it/leader/': [
        {
          text: '领导力',
          items: [
            { text: '角色转换与心态调整', link: '/it/leader/01_角色转换与心态调整' },
            { text: '团队管理基础', link: '/it/leader/02_团队管理基础' },
            { text: '技术规划与决策', link: '/it/leader/03_技术规划与决策' },
            { text: '项目管理与交付', link: '/it/leader/04_项目管理与交付' },
            { text: '团队建设与文化', link: '/it/leader/05_团队建设与文化' },
            { text: '沟通与协作', link: '/it/leader/06_沟通与协作' },
            { text: '绩效考核与激励', link: '/it/leader/07_绩效考核与激励' }
          ]
        }
      ],
    // 其他目录的侧边栏配置
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
          { text: 'Markdown 示例', link: '/demo/markdown-examples' },
          { text: '首页', link: '/demo/' }
        ]
      }
    ],
    '/notes/': [
      {
        text: 'Notes',
        items: [
          { text: '首页', link: '/notes/' },
          { text: 'Home', link: '/notes/home' }
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