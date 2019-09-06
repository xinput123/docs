今天在运行代码时，遇到这样一个错误：  java.lang.UnsatisfiedLinkError: no jacob-1.18-x64 in java.library.path。

网上看了一圈，说是jacob.jar和jacob.dll版本不一致导致的。

于是去pom.xml文件中和system32文件夹中看了一下，果然是这个原因造成的：

```
<dependency>
	<groupId>com.jacob</groupId>
	<artifactId>jacob</artifactId>
	<version>1.1.8</version>
</dependency>
```

![clipboard.png](http://upload-images.jianshu.io/upload_images/4046640-6d8fcc050ba4cf96.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


**解决方法**：
一般把jacob.dll（不同版本的jacob的dll文件名有所不同）复制到C:\Program Files\Java\jdk1.6.0_17\jre\bin目录下即可。

在tomcat上使用时要在tomcat使用的jdk的jdk/jre/bin目录下放置配套的jacob.dll文件。
  
jdk安装目录的jdk/jre/bin目录下放置jacob.dll文件
[https://github.com/xinput123/FileAndTools/tree/master/jacob]