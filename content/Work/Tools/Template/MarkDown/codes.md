---
sort: 3
---

# 代码块

`inline code`

[`inline code inside link`](./)

```
:root {
  @for $level from 1 through 12 {
    @if $level % 4 == 0 {
      --toc-#{$level}: #{darken($theme-white, 4 * 8.8%)};
    } @else {
      --toc-#{$level}: #{darken($theme-white, $level % 4 * 8.8%)};
    }
  }
}
```

**Highlight:**

```scss
:root {
  @for $level from 1 through 12 {
    @if $level % 4 == 0 {
      --toc-#{$level}: #{darken($theme-white, 4 * 8.8%)};
    } @else {
      --toc-#{$level}: #{darken($theme-white, $level % 4 * 8.8%)};
    }
  }
}
```

## 支持的语言

| 支   | 持  | 的 | 语 | 言 |
| ---- | ---- |---- |--- |---- |
| actionscript3 | apache | applescript | asp | brainfuck |
| c | cfm | clojure | cmake | coffee-script |
| coffeescript | coffee | cpp ( C++) | cs | csharp |
| css | csv | bash | diff | elixir |
| go | haml | http | java |erb (HTML + Embedded Ruby) | 
| javascript | json | jsx | less | lolcode |
| markdown | matlab | nginx | objectivec | make (Makefile) |
| pascal | PHP | Perl | python | profile (python profiler output) |
| rust | shell | sh | salt | saltstate (Salt) |
| sql | scss | svg | zsh | bash (Shell scripting) |
| swift | rb | jruby | ruby - Ruby | smalltalk |
| volt | vhdl | vue | vim | viml (Vim Script) | 
| xml | yaml | cc | dd | ee |


