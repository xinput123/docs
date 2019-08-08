### 1、将Jar包安装到本地仓库
```
mvn install:install-file -Dfile=/Users/xinput/Downloads/oos-sdk-6.1.0.jar -DgroupId=com.ctyun.sdk -DartifactId=oos-sdk -Dversion=6.1.0 -Dpackaging=jar
```

### 2、上传Jar到私服
```
mvn deploy:deploy-file -DgroupId=com.ctyun.sdk -DartifactId=oos-sdk -Dversion=6.1.0 -Dpackaging=jar -Dfile=/Users/xinput/Downloads/oos-sdk-6.1.0.jar -Durl=https://repository.pgxcloud.com/content/repositories/snapshots -DrepositoryId= snapshots
```

### 3、命令参数解释
- DgroupId和DartifactId构成了该jar包在pom.xml的坐标， 对应依赖的DgroupId和DartifactId
- Dfile表示需要上传的jar包的绝对路径
- Dpackaging 为安装文件的种类
- Durl私服上仓库的url精确地址(打开nexus左侧repositories菜单，可以看到该路径)
- DrepositoryId服务器的表示id，在nexus的configuration可以看到
