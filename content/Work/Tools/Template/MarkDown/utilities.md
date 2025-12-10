---
sort: 6
---

# 实用技巧


## Avatar Test

```
{% raw %}{% avatar wxyClark %}{% endraw %}
```

{% avatar wxyClark %}

```tip
Set config `plugins: [jekyll-avatar]`

For documentation, see: [https://github.com/benbalter/jekyll-avatar](https://github.com/benbalter/jekyll-avatar)
```


## Primer Utilities Test

Text can be **bold**, _italic_, or ~~strikethrough~~. [Links](https://github.com) should be blue with no underlines (unless hovered over).

{:.text-red}
Text can be **bold**, _italic_, or ~~strikethrough~~. [Links](https://github.com) should be blue with no underlines (unless hovered over).

{:.bg-yellow-dark}
Text can be **bold**, _italic_, or ~~strikethrough~~. [Links](https://github.com) should be blue with no underlines (unless hovered over).

{:.bg-yellow-dark.text-white}
Text can be **bold**, _italic_, or ~~strikethrough~~. [Links](https://github.com) should be blue with no underlines (unless hovered over).

{:.bg-yellow-dark.text-white.m-5}
Text can be **bold**, _italic_, or ~~strikethrough~~. [Links](https://github.com) should be blue with no underlines (unless hovered over).

{:.bg-yellow-dark.text-white.p-5.mb-6}
Text can be **bold**, _italic_, or ~~strikethrough~~. [Links](https://github.com) should be blue with no underlines (unless hovered over).

{:.bg-yellow-dark.text-white.p-5.mb-6}
Text can be **bold**{:.h1}, _italic_, or ~~strikethrough~~. [Links](https://github.com) should be blue with no underlines (unless hovered over).

{:.bg-yellow-dark.text-white.p-2.box-shadow-large}
Text can be **bold**{:.h1}, _italic_, or ~~strikethrough~~. [Links](https://github.com) should be blue with no underlines (unless hovered over).

{:.bg-yellow-dark.text-white.p-5.box-shadow-large.anim-pulse}
Text can be **bold**{:.h1}, _italic_, or ~~strikethrough~~. [Links](https://github.com) should be blue with no underlines (unless hovered over).

```tip
Edit this page to see how to add this to your docs, theme can use [@primer/css utilities](https://primer.style/css/utilities)
```


## 提及 Mentions
```
Hey @wxyClark, what do you think of this?
```

Hey @wxyClark, what do you think of this?

```tip
Set config `plugins: [jekyll-mentions]`

For documentation, see: [https://github.com/jekyll/jekyll-mentions](https://github.com/jekyll/jekyll-mentions)
```


# 数学 Mathjax

$$
\begin{aligned}
& \phi(x,y) = \phi \left(\sum_{i=1}^n x_ie_i, \sum_{j=1}^n y_je_j \right)
= \sum_{i=1}^n \sum_{j=1}^n x_i y_j \phi(e_i, e_j) = \\
& (x_1, \ldots, x_n) \left( \begin{array}{ccc}
\phi(e_1, e_1) & \cdots & \phi(e_1, e_n) \\
\vdots & \ddots & \vdots \\
\phi(e_n, e_1) & \cdots & \phi(e_n, e_n)
\end{array} \right)
\left( \begin{array}{c}
y_1 \\
\vdots \\
y_n
\end{array} \right)
\end{aligned}
$$

```note
For documentation, see: https://kramdown.gettalong.org/syntax.html#math-blocks
```


## Gist Test

```
{% raw %}{% gist c08ee0f2726fd0e3909d %}{% endraw %}
```

{% gist c08ee0f2726fd0e3909d %}
