## 一、在根目录创建模板文件。如 pr_template,内容如下:
```
[type]: 

[scope]:

[subject]:

[Body]:

[Footer]:
```

#### 1-1、type: commit类型
- **feat:** 新特性
- **fix:** 修改问题
- **refactor:** 代码重构
- **docs:** 文档修改
- **style:** 代码格式修改, 注意不是 css 修改
- **test:** 测试用例修改
- **chore:** 其他修改, 比如构建流程, 依赖管理.

#### 1-2、scope：本次commit影响范围
- 数据层
- 控制层
- 视图层

#### 1-3、subject: 此次commit的简单描述
- 不超过50字
- 结尾无任何标点
- 使用祈使句

#### 1-4、body: 此次commit的详情信息
- Why(为什么改)
- How(怎么改的，不是技术细节，而是说做了什么)
- What(应该注意什么)

#### 1-5、Footer
如果当前代码与上一个版本不兼容，则 Footer 部分以BREAKING CHANGE开头，后面是对变动的描述、以及变动理由和迁移方法。


## 二、步骤
```
<!--设置模板,只设置当前分支的提交模板-->
git config commit.template   [模板文件名]

<!--或者设置全局-->
git config  — —global commit.template   [模板文件名] 

<!--设置文本编辑器，git config –global core.editor  [编辑器名字]-->
git config –global core.editor vi

<!--编辑模板提交代码-->
git add 先将代码入库
git commit
```