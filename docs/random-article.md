---
title: 随机文章 试试手气
---

<script setup>
import { onMounted } from 'vue'

const articles = [
  '/AI/',
  '/IT/',
  '/Life/',
  '/Tao/',
  '/notes/'
]

function getRandomArticle() {
  const randomIndex = Math.floor(Math.random() * articles.length)
  return articles[randomIndex]
}

onMounted(() => {
  // 随机重定向到一篇文章
  const randomArticle = getRandomArticle()
  window.location.href = randomArticle
})
</script>

# 随机文章

正在为您跳转到随机文章...