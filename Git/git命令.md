#### 1、git 别名
```
// 查看当前别名配置
git config --list | grep alias

// 拉取代码
git alias fu "fetch upstream" 

// 合并代码
git alias mu "merge upstream/master"

// 查看状态
git config --global alias.st status

// 查看分支
git config --global alias.br branch

// 用git last就能显示最近一次的提交
git config --global alias.last 'log -1'     

// 查看提交日志
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

// 取消别名
git config --global --unset alias.br
```

#### 2、git 分支
```
// 查看分支
git branch       查看本地分支
git branch -r    查看远程分支
git branch -a   查看全部分支
git branch --no-merged  没有合并的分支

// 分支切换
git branch dev   创建dev分支
git checkout dev   切换到dev分支
git checkout -b dev  创建并切换到dev分支

// 合并分支
git merge dev   使用"快进模式"合并dev分支到当前分支上
git merge --no-ff  -m "merge with no-ff" dev   禁用"k快速模式"合并分支。因为这次合并要创建一个新的commit，所以需要加上 -m参数。

// 删除分支
git branch -d dev    删除本地dev分支
git push origin --delete 分支名   删除远程分支
git push origin :hotfixes/BJVEP933    删除远程仓库的hotfixes/BJVEP933分支 

// 提交新的分支到远程
git push origin <local_branch>:<remote_branch>     远程分支若不存在会自动创建

// 提交新的分支到远程
// 回退版本
```

#### 3、撤销
```
// 在没有执行git add的情况下
git checkout -- 1.txt  丢弃工作区 1.txt 文件的修改。

// 已经使用git add添加到了暂存区
git reset HEAD 1.txt    先把暂存区的修改回退到工作区。当我们用HEAD时，表示最新的版本。
git checkout -- 1.txt  再丢弃工作区 1.txt 文件的修改。

// 已经commit但是没有push。找到上次Git commit的 id,不是自己提交的id；
git reset --hard commit_id 。先完成撤销,同时将代码恢复到前一commit_id 对应的版本。(如果代码不多，可以直接到这一行就可以了)。
git reset commit_id  完成Commit命令的撤销，但是不对代码修改进行撤销，可以直接通过git commit 重新提交对本地代码的修改。
```

#### 4、git status 中文文件名编码问题解决
使用git status查看时，不能显示正确的中文，而是八进制。
![image.png](https://upload-images.jianshu.io/upload_images/4046640-b1071b349c4b34f2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
-- 通过将Git配置变量 core.quotepath 设置为false，就可以解决中文文件名称在这些Git命令输出中的显示问题，
git config --global core.quotepath false
```