## Jrebel激活服务搭建

#### 1、开源代码下载 
[Jrebel激活代码](https://gitee.com/ylyyj/JrebelLicenseServerforJava)

#### 2、运行 MainServer 类中的mai方法即可
```
License Server started at http://localhost:8081
JetBrains Activation address was: http://localhost:8081/
JRebel 7.1 and earlier version Activation address was: http://localhost:8081/{tokenname}, with any email.
JRebel 2018.1 and later version Activation address was: http://localhost:8081/{guid}(eg:http://localhost:8081/779a56c2-4163-430e-9492-087bbb568a30), with any email.
```

#### 3、在线生成guid
[在线生成guid](http://www.ofmonkey.com/transfer/guid)

#### 4、如果放在一个固定的服务器上运行也可，打包，运行jar包，或者扔到docker中运行也可