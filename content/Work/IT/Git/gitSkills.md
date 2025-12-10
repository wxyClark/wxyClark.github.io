# git小技巧

## 版本控制最佳做法

* 提交代码之前一定要先测试——在你还没有确认工作完成(彻底的测试)之前，忍住提交代码的冲动
* 提交应该是相关更改的封装——较小的提交可使其他开发人员更容易理解更改，并在出现问题时将其回滚。
* 写”好”的提交注释——用简短的总结语句，后续正文与开头用空白行分开。——做了什么，为什么这样做
* 经常提交会使你的提交变小，并且帮助你仅提交相关的更改。——可以更轻松地定期同步整合代码更改，并避免合并冲突
* 不要提交未完成的代码——将功能的实现分成逻辑块，并记住要尽可能早的频繁的提交
* 如果你只是因为需要干净的工作区（切换分支，同步更改等）而打算提交未完成的代码，请考虑改用git stash


## 分支合并错误

* 开发代码 错误的提交了到测试分支develop,使用stash迁移代码后，强制develop与远端同步

```bash
git reset --hard origin/master
```

* 回滚到上个版本

```bash
git reset --hard HEAD 
git commit '回滚到上个版本XXX'
git push origin HEAD --force
```

* 回滚到指定历史版本

```bash
git reset --hard <commit_id>  
git commit '回滚到上个版本XXX'
git push origin HEAD --force
```

* 把新建的本地分支推送到远端同名分支(建议在远端创建,本地pull)
```bash
git checkout -b <新分支名>
git push --set-upstream origin <本地分支名>
```

## 重写最近commit message


```bash
git commit --amend '新的注释'
```
 

## 移花接木

 ```bash
# 复制一个特定的提交到当前分支
git cherry-pick <commit_id>|分支名
git checkout targetBranch
git cherry-pick <commit_id>|分支名

# 这是一个左开右闭的操作，就是commit1不会被合并
git cherry-pick commit1..commit100

# 未提交代码转移分支 使用stash
git stash 
git checkout branchName
git stash pop

# 提交到错误分支的代码转移分支 使用stash
git reset --soft <commit_id>
git stash 
git checkout branchName
git stash pop

# 删除误提交的代码
git reset --hard <commit_id>
 ```

phpstormIDE 选中要复制的若干分支，点击【cherry-pick】，到需要的分支上，点【推送】

## merge vs rebase

* git rebase 和git merge 做的事其实是一样的,都是合并分支
* merge 好在它是一个安全的操作; 缺点是 

| **对比** | merge | rebase |
| ---- | ---- |---- |
| 优点 | 安全<br>现有的分支不会被更改 | 整个 feature 分支移动到 master 分支的后面<br>项目历史会非常整洁(完美的线性) |
| 缺点 | 多人协作,log会出现分支交叉不方便回退 | rebase 为原分支上每一个提交创建一个新的提交，<br>重写了项目历史，并且不会带来合并提交<br>rebase 不会有合并提交中附带的信息——你看不到 feature 分支中并入了上游的哪些更改。 |
| 命令 | git checkout feature<br>git merge master<br>也可以把它们压缩在一行里:<br>git merge master feature | git checkout feature<br>git rebase master<br >交互式的rebase:<br>git rebase -i master |


* 将代码 Merge Request 到团队共用分支 master 前，需把 master 代码 rebase 到自己分支
```bash
git rebase master                      // 第一轮 rebase 
git status                             // 看状态,如有冲突就处理
git pull                               // 处理完冲突要执行这步
git rebase --continue                  // 下一轮 rebase
git rebase --skip                      // 执行 git status 发现没有冲突，则执行这一步
git push -f origin <本地自己的开发分支> // 在 git rebase --skip 后，执行这一步
```

* 通过 git bisect 自动二分法快速定位问题
> 某个系统，在开发过程中一直都没测试出问题，突然有一天，发现 Bug。

> 这种蛮多情况是衰退，如果这个 Bug 的复现几率很大的话，就可以直接用二分法快速定位了。
> 
> git bisect 就可以辅助进行自动二分法。
```bash
git bisect start
git bisect bad efa5cf
git bisect good b6fcf0
git bisect run grep -q UCONFIG Makefile
```

* 用 git fetch 取代 git clone，实现断点续传
```bash
git fetch <仓库地址>
git checkout -b master FETCH_HEAD
```

 ## 查看修改日志

| 命令 | 用途 | 备注 |
| ---- | ---- |---- |
| git reflog | 查看命令历史 | 摘要 |
| git log | 查看详细提交历史 | 完整信息 |
| git log -n | 查看最近n次提交历史 | 完整信息 |
| git log --after="2022-1-1" --before="2022-2-2" | 查看指定时段的提交历史 | 可只指定after或before |
| git log --author="wxy" | 看某一特定作者的提交 | 完整信息 |
| git log --grep="NoSQL" | 按提交信息 | 可以传入 -i 参数来忽略大小写匹配 |
| git log -- <filePath> | 按文件路径 | -- 可以省略 |
| git log -S "代码中的内容" | 按代码内容 | 可以使用 -G"<regex>" 正则匹配 |
| git log master..feature | 按分支差异 | 在 feature 分支而不在 master 分支中所有的提交 |
| git log --no-merges | 过滤合并提交 |  |
| git log --merges | 只看合并提交 |  |
| git log --pretty=oneline | 查看简化提交历史 | commit message |
| git log --pretty=format:"<string>" | 自定义格式<br>使用像 printf 一样的占位符 | format:"%cn committed %h on %cd" |
| git log --graph | 查看分支合并图 | 图 |
| git shortlog | 显示提交信息的第一行(做了什么) | 创建发布声明设计的 |
| git log -stat <file> | 显示每次提交的文件增删数量 | 详情 |
| git log -p <file> | 显示特定文件随时间的修改 | 详情 |
| git blame -L 50,50 <file> | 查看特定文件什么时间被什么人修改了什么内容 | 列表 |
| git bisect | 自动二分法快速定位问题 | 突现BUG,定位 |
| git fetch 仓库地址 | 用 git fetch 取代 git clone，实现断点续传 | 突现BUG,定位 |



## 配置

* 查看全部Git配置   git config --list
* 显示颜色提示      git config --global color.ui true

## 使用token 替换 ssh-key

* git remote set-url origin https://@github.com/<USERNAME>/<REPO>.git

## .gitignore修改无效

* git rm -r --cache .

## 工作流

```tip
开发分支——>测试分支 合并 只能是单向合并，【test分支部分代码验证不通过，不能影响其他开发分支上线】

合并分支前 同步远端分支 git fetch origin branchName
```

### 版本一：小规模开发

* 基于 master 发布
* 基于 master 创建开发分支 feature/userName/Date/featureName
* 基于 master 创建修复分支 bugix/userName/Date/featureName
* 基于 develop 测试
* 自测通过的代码合并到 develop 分支【单向合并】
* git fetch origin master
* 产品验收通过的分支提交 mergeRequest 到 master

### 版本二：中规模开发

【迭代开发】

* 基于 released 分支发布
* 基于 develop 创建开发主分支 dev-Version
* 基于开发主分支 dev-Version 创建独立开发分支 dev-Version-ModuleName/userName/Date
* 自测通过的代码合并到 dev-Version 分支【单向合并】
* 基于 develop 分支【+迭代版本号】创建 test-Version
* 联测通过的代码合并到 test-Version 分支【单向合并】
* 产品验收通过的 dev 分支提交 mergeRequest 到 develop
* 运维基于 develop + 封版时间 创建 released-Version 分支
* 发版之后，将 released-Version 分支 合并到 master 【?合并时机】

【bug修复】

* 基于 develop 分支创建修复分支 released-Version-bugfix-Version
* 基于 released-Version-bugfix-Version 分支创建独立修复分支 released-Version-bugfix-Version/userName/bugName
* 自测通过的代码合并到 test-Version 分支【单向合并】
* 产品验收通过的分支提交 mergeRequest 到 released-Version-bugfix-Version
* 运维 基于 released-Version-bugfix-Version + 例行bug修复封版时间 发版
* 发版之后，将 released-Version-bugfix-Version 分支 合并到 develop、master
  

### 版本三：双周灰度发布

* 全量发布的分支不再创建 released-Version-bugfix-Version 分支

| 周一 | 周二 | 周三 | 周四 | 周五 | 周六 | 周日 | 周一 | 周二 | 周三 | 周四 | 周五 | 周六 | 周日 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 2  | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 |
| <需> | 例 |  | Ver2-1<br>一灰 3% | **技** | - | - | <需> | 例 |  | Ver2-2<br>二灰 10% | **技** | - | - |
| <求> | 行 |  | Ver1-3<br>三灰 25% | **术** | - | - | <求> | 行 |  | Ver1-4<br>全量 100% | **术** | - | - |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| <评> | bug |  | Ver2-3<br>三灰 25% | **分** | - | - | <评> | bug |  | Ver2-4<br>全量 100% | **分** | - | - |
| <审> | 修复 |  | Ver3-1<br>一灰 3% | **享** | - | - | <审> | 修复 |  | Ver3-2<br>二灰 10% | **享** | - | - |
| 15 | 16  | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 |
| 周一 | 周二 | 周三 | 周四 | 周五 | 周六 | 周日 | 周一 | 周二 | 周三 | 周四 | 周五 | 周六 | 周日 |