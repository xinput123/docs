## 使用CI的好处
- 1.标准化编译环境
- 2.大规模团队协同开发
- 3.自动化部署上线

## 问题
都知道CI的好处，但是最近有一个项目在使用Ci的时候，总是通不过。报错问题如下

```
~ using java version "1.8.0_222"
2019.11.05 03:25:43,700 INFO  play - Starting /home/travis/build/precisource/vendor/vendor
:: loading settings :: url = jar:file:/home/travis/build/precisource/vendor/play-1.4.4/framework/lib/ivy-2.4.0.jar!/org/apache/ivy/core/settings/ivysettings.xml
2019.11.05 03:25:43,981 INFO  play - Module api is available (/home/travis/build/precisource/vendor/vendor/modules/api-0.3.8)
2019.11.05 03:25:43,983 INFO  play - Module logger is available (/home/travis/build/precisource/vendor/vendor/modules/logger-2.4)
2019.11.05 03:25:44,235 INFO  play - Precompiling ...
2019.11.05 03:25:46,911 ERROR play - 
@7dlji921k
Cannot start in PROD mode with errors
Compilation error (In /app/controllers/v1/Users.java around line 221)
The file /app/controllers/v1/Users.java could not be compiled. Error raised is : The method readQueryBody(Class&lt;UserListParams>) is undefined for the type Users
play.exceptions.CompilationException: The method readQueryBody(Class<UserListParams>) is undefined for the type Users
	at play.classloading.ApplicationCompiler$2.acceptResult(ApplicationCompiler.java:264)
	at org.eclipse.jdt.internal.compiler.Compiler.handleInternalException(Compiler.java:678)
	at org.eclipse.jdt.internal.compiler.Compiler.compile(Compiler.java:522)
	at play.classloading.ApplicationCompiler.compile(ApplicationCompiler.java:300)
	at play.classloading.ApplicationClassloader.getAllClasses(ApplicationClassloader.java:420)
	at play.Play.preCompile(Play.java:609)
	at play.Play.init(Play.java:309)
	at play.server.Server.main(Server.java:160)
The command "${TRAVIS_BUILD_DIR}/play-${PLAY_VERSION}/play precompile" exited with 255.
```

## 问题分析
## 1、首先查看ci文件
```
language: java
jdk: openjdk8

branches:
  only:
    - master


cache:
  directories:
    - $HOME/.ivy2/cache

env:
- PLAY_VERSION=1.4.4

before_script:
  - wget http://downloads.typesafe.com/play/${PLAY_VERSION}/play-${PLAY_VERSION}.zip
  - unzip -n play-${PLAY_VERSION}.zip -d ${TRAVIS_BUILD_DIR}
script:
  - cd ${TRAVIS_BUILD_DIR}/vendor
  - ${TRAVIS_BUILD_DIR}/play-${PLAY_VERSION}/play deps
  - ${TRAVIS_BUILD_DIR}/play-${PLAY_VERSION}/play precompile
  - cd -
  - cd ${TRAVIS_BUILD_DIR}/java-sdk
  - mvn install -DskipTests=true -Dmaven.javadoc.skip=true -B -V
  - cd -
notifications:
  slack:
    rooms:
      - precisource:dj0bdaE93PZdiQIbfoZiSjIw#ci
```

ci文件没有任何问题，错误 Error raised is : The method readQueryBody(Class&lt;UserListParams>) is undefined for the type Users
play.exceptions.CompilationException: The method readQueryBody(Class<UserListParams>) is undefined for the type Users，是由于没有找到这个对应的方法。通过查看代码得知，是通过 api-0.3.8 这个包引入的。但是本地已经jenkins直接构建都是可以通过，为什么会出现这种问题呢？

#### 2、解决方法
由上面分析我们知道，问题肯定是出在了 api-0.3.8 这个引入包中，那么我们将ci服务器上的包的缓存清除，再重新下载。

#### 3、修改后的ci文件
在 script: 添加 
  - rm -rf $HOME/.ivy2/cache/play1-base

```
language: java
jdk: openjdk8

branches:
  only:
    - master

cache:
  directories:
    - $HOME/.ivy2/cache

env:
- PLAY_VERSION=1.4.4

before_script:
  - wget http://downloads.typesafe.com/play/${PLAY_VERSION}/play-${PLAY_VERSION}.zip
  - unzip -n play-${PLAY_VERSION}.zip -d ${TRAVIS_BUILD_DIR}
  - rm -rf $HOME/.ivy2/cache/play1-base
script:
  - cd ${TRAVIS_BUILD_DIR}/vendor
  - ${TRAVIS_BUILD_DIR}/play-${PLAY_VERSION}/play deps
  - ${TRAVIS_BUILD_DIR}/play-${PLAY_VERSION}/play precompile
  - cd -
  - cd ${TRAVIS_BUILD_DIR}/java-sdk
  - mvn install -DskipTests=true -Dmaven.javadoc.skip=true -B -V
  - cd -
notifications:
  slack:
    rooms:
      - precisource:dj0bdaE93PZdiQIbfoZiSjIw#ci
```

这样就能解决问题了，ci通过后，再重新将添加的语句删除。