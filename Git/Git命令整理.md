# 一、常用命令介绍
## 1.1、Git全局设置
```
$ git config --global user.name "knight"
$ git config --global user.email "knight@dayuan.com"
```

## 1.2、在已存在的目录中创建仓库
```
git init
git remote add origin git@github.com:xinput123/docs.git
```

## 1.3、查看分支
```
git branch -r   // 查看远程分支
git branch	   // 查看本地分支
git branch -a   // 查看所有分支
```

## 1.4、拉取远程分支并创建本地分支
```
// dev2为远程分支,dev1为本地分支
$ git checkout -b dev1 origin/dev2;
```

## 1.5、本地分支与远程分支的映射关系
```
git branch -vv  // 输出映射关系

git branch -u origin/dev  // 将当前本地分支与远程分支建立映射关系

git branch --unset-upstream   // 撤销当前本地分支与远程分支的映射关系
```

## 1.6、合并分支
现有dev本地分支和远程分支，master本地分支和远程分支，现在要将dev分支代码合并到master分支上

- 1、切换到本地分支dev，并且pull拉取一下远程dev分支上的改动地方
- 2、将所有本地修改进行commit并且push到远程dev分支上，确保当前本地dev与远程dev是一致的
- 3、将当前本地分支切换到本地master上
- 4、将本地分支dev合并到本地master上
- 5、将本地已经合并了dev分支的master进行push到远程master上 大概思路就是这样。需要注意的是在进行merge(合并)的时候需要禁用fast-forward模式。 git merge --no-ff dev (dev为本地被合并的分支名字)


# 二、分支管理
## 2-1、直接合并
把两个分支上的历史轨迹合并，交汇到一起。比如要把dev分支上的所有定西合并到master分支：
- 首先切换到master分支： git checkout master
- 然后把dev分支给合并过来： git merge dev
- 注意没有参数的情况下merge是fast-forward的，即Git将master分支的指针直接移到dev的最前方
- 换句话说，如果顺着一个分支走下去可以到达另一个分支的话，那么Git在合并两者时，只会简单移动指针，所以这种合并称为 快进式(Fast-forward)

## 2-2、压合合并(squashed commits)
将一个分支上的若干个提交条目压合成另一个提交条目，提交到另一个分支的末梢。
把dev分支上的所有提交压合成主分支上的一个提交，即压合提交：

```
 git checkout master
 git merge --squash dev
```

此时，dev上的所有提交已经合并到当前工作区并暂存，但还没有作为一个提交，可以像其他提交一样，把这个改动提交到版本库中：

```
git commit –m “commit from dev”
```

## 2-3、拣选合并
拣选另一个分支上的某个提交条目的改动到这个分支上。每一次提交都会产生一个全局唯一的提交名称，利用这个名称就可以进行拣选提交。

比如在dev上的某个提交叫：321d67a
把它合并到master中：

```
git checkout master
git pull
git cherry-pick 321d67a
```

要拣选多个提交，可以给git cherry-pick命令传递-n选项，比如：

```
git cherry-pick –n 321d67a
```
这样在拣选了这个改动之后，进行暂存而不立即提交，接着可以进行下一个拣选操作，一旦拣选完需要的各个提交，就可以一并提交。

# 三、冲突处理
当两个分支对同一个文件的同一个文本块进行了处理，并试图合并时，Git不能自动合并的，称之为冲突。

```
<<<<<<< HEAD

test in master

=======

test in dev

>>>>>>> dev
```
- <<<<<<<标记冲突开始，后面跟的是当前分支中的内容。
- HEAD指向当前分支末梢的提交。
- =======之后，>>>>>>>之前是要merge过来的另一条分支上的代码。
- >>>>>>>之后的dev是该分支的名字。

# 四、版本回退: git reset 和 git revert
## 4-1、git reset（一般来说，不允许使用这个命令回退）
加入我们的系统有abcd四个提交，其中a和b是正常提交，而c和d是错误提交。现在，我们要把c和d都回退到。而此时，Head指针指向D提交。我们只需要把head指针移到b提交，就可以达到目的。

```
// 假设b的commit id 是  b001
git reset --hard b001
```

命令运行后，远程仓库的haed指针依然不变，仍然在d上。这个时候，如果我们直接使用git push 命令的话，将无法更改推到远程仓库。此时，只能使用 -f 选项强制将提交推送到远程仓库：

```
git push -f
```

采用这种方式回退代码的弊端：会使Head指针往回移动，从而丢失c和d的提交信息。

## 4-2、git revert
git revert的作用是通过创建一个新的版本，这个版本的内容与我们要回退的目标版本一样，但是Head指针是指向这个新生成的版本，而不是目标版本。

使用 git revert 命令来实现上述例子的话，我们可以这样做：先revert d，在revert c(有多个提交需要回退的话需要由新到旧进行revert)：

```
git revert d

git revert c
```

这里只有两个提交需要revert，我们可以一个一个回退，但是如果有很多个呢？一个一个的回退肯定效率太低而且容易出错。我们可以使用批量回退：

```
git revert older_commit^..newer_commit
```

这种做法，错误的提交c和d依然保留着。而且这样操作，head指针是向后移动的，可以直接使用git push命令推送到远程仓库中。

# 五、举例
现在有三个提交，a、b和c三个提交，而恰巧提交b是有问题的。应该怎么处理

```
git revert c

git revert b

git cherry-pick c
```




















