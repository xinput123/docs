### 1、用户主目录下，看看有没有.ssh目录，如果有，再看看这个目录下有没有id_rsa和id_rsa.pub这两个文件，如果已经有了，可直接跳到下一步。如果没有，打开Shell（Windows下打开Git Bash），创建SSH Key：
```
ssh-keygen -t rsa -C "youremail@example.com"
```   
    
一直回车即可，因为自己用，不需要设置密码，当然了，也可以设置密码。
执行完成后，在用户主目录里找到.ssh目录，里面有id_rsa和id_rsa.pub两个文件，这两个就是SSH Key的秘钥对，id_rsa是私钥，不能泄露出去，id_rsa.pub是公钥，可以放心地告诉任何人。

### 2、登陆GitHub，打开“settings”，“SSH and GPG Keys”页面,然后，点“Add SSH Key”，填上任意Title，在Key文本框里粘贴id_rsa.pub文件的内容：
点“Add Key”，你就应该看到已经添加的Key。

### 3、验证是否通过
```
ssh -T [git@github.com](mailto:git@github.com)
```

### 4、添加远程库
登陆github，在右上角找到"Create a new repo"按钮，创建一个新的仓库；在Repository name填入testGit，其他保持默认设置，点击“Create repository”按钮，就成功地创建了一个新的Git仓库：

![clipboard.png](http://upload-images.jianshu.io/upload_images/4046640-4b698fe70e902b78.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们根据GitHub的提示，在本地的 testGit 仓库下运行命令，添加远程和本地的关联。

```
git remote add origin [git@github.com](mailto:git@github.com):xinput123/testGit.git
```

<br/>
### 修改github 语言问题，在仓库的根目录下添加.gitattributes文件。
```
*.js linguist-language=java
*.css linguist-language=java
*.html linguist-language=java
```
意思是将.js、css、html当作java语言来统计