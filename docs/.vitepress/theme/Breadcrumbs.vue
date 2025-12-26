<template>
  <nav class="breadcrumbs" v-if="breadcrumbs.length > 0">
    <ol>
      <li v-for="(crumb, index) in breadcrumbs" :key="index">
        <a v-if="crumb.link" :href="crumb.link">{{ crumb.text }}</a>
        <span v-else>{{ crumb.text }}</span>
      </li>
    </ol>
  </nav>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useData } from 'vitepress'

const { page } = useData()

const breadcrumbs = ref([])

onMounted(() => {
  const path = window.location.pathname
  const pathSegments = path.split('/').filter(segment => segment !== '')
  
  breadcrumbs.value = []
  
  // 添加首页
  breadcrumbs.value.push({ text: '首页', link: '/' })
  
  let currentPath = ''
  for (let i = 0; i < pathSegments.length; i++) {
    const segment = pathSegments[i]
    currentPath += '/' + segment
    
    // 根据路径获取对应的文本
    let text = segment
    
    // 特殊路径映射
    switch(segment) {
      case 'ai':
        text = 'AI'
        break
      case 'it':
        text = 'IT'
        break
      case 'life':
        text = 'Life'
        break
      case 'tao':
        text = 'Tao'
        break
      case 'demo':
        text = 'Demo'
        break
      case 'notes':
        text = 'Notes'
        break
      case 'base':
        text = '基础'
        break
      case 'frontend':
        text = '前端'
        break
      case 'backend':
        text = '后端'
        break
      case 'database':
        text = '数据库'
        break
      case 'middleware':
        text = '中间件'
        break
      case 'architecture':
        text = '架构'
        break
      case 'algorithm':
        text = '算法'
        break
      case 'markdown-examples':
        text = 'Markdown 示例'
        break
      default:
        // 如果是小写开头的路径，转换为标题格式
        text = segment.charAt(0).toUpperCase() + segment.slice(1)
    }
    
    // 最后一个路径段不添加链接，因为它是当前页面
    if (i === pathSegments.length - 1) {
      breadcrumbs.value.push({ text, link: null })
    } else {
      breadcrumbs.value.push({ text, link: currentPath + '/' })
    }
  }
})
</script>

<style scoped>
.breadcrumbs {
  padding: 1rem 0;
  margin-bottom: 1.5rem;
  border-bottom: 1px solid var(--vp-c-divider);
}

.breadcrumbs ol {
  display: flex;
  flex-wrap: wrap;
  padding: 0;
  margin: 0;
  list-style: none;
}

.breadcrumbs li {
  display: inline;
  font-size: 0.85rem;
}

.breadcrumbs li:not(:last-child)::after {
  content: " / ";
  margin: 0 0.5rem;
  color: var(--vp-c-text-2);
}

.breadcrumbs a {
  color: var(--vp-c-text-2);
  text-decoration: none;
}

.breadcrumbs a:hover {
  color: var(--vp-c-brand);
}

.breadcrumbs span {
  color: var(--vp-c-text-1);
  font-weight: 500;
}
</style>