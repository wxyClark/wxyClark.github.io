import DefaultTheme from 'vitepress/theme'
import { h } from 'vue'
import Breadcrumbs from './Breadcrumbs.vue'
import './style.css'

export default {
  ...DefaultTheme,
  // 在页面内容前添加面包屑
  Layout: function () {
    return h(DefaultTheme.Layout, null, {
      'doc-before': () => h(Breadcrumbs)
    })
  }
}