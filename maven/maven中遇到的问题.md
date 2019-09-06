## 问题一
在使用maven过程中，有时候经常遇到提示红线，检查有指定的jar包，关闭后重启还是一样。最后发现是pom.xml文件中没有build标签。如下。一般的加上即可。

#### 1、普通的项目
```
<build>
	<plugins>
		<plugin>
			<groupId>org.apache.maven.plugins</groupId>
			<artifactId>maven-compiler-plugin</artifactId>
			<configuration>
				<source>1.8</source>
				<target>1.8</target>
			</configuration>
		</plugin>
	</plugins>
</build>
```

#### 2、springboot项目
```
<build>
	<plugins>
	   <plugin>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-maven-plugin</artifactId>
			<configuration/>
		</plugin>
	</plugins>
</build>
```

## 问题二
#### IDEA+MAVEN配置Mybatis问题。同事使用的eclipse或者STS运行的Maven+SSM框运行的项目没有任何问题，而我使用的IDEA开发工具，运行经常性提示这种错误：
```
org.apache.ibatis.binding.BindingException: Invalid bound statement (not found)
org.apache.ibatis.binding.MapperMethod$SqlCommand.(MapperMethod.java:189)
org.apache.ibatis.binding.MapperMethod.(MapperMethod.java:43)
org.apache.ibatis.binding.MapperProxy.cachedMapperMethod(MapperProxy.java:58)
org.apache.ibatis.binding.MapperProxy.invoke(MapperProxy.java:51)
com.sun.proxy.$Proxy25.getBrand(Unknown Source)
```

#### 分析问题原因：
一开始以为是xml文件所在的package名称和interface的package名称不对应导致的，但这样子不应该其他人可以运行。后来知道其实是IDEA和Eclipse编译的不用导致的。

- 1、eclipse和myeclipse中mapper.java和mapper.xml在同一目录下，直接配置扫描不会出现上述问题。

- 2、idea默认是不打包src中的xml文件。

- 3、这是IDEA和eclipse差异的问题。

#### 解决方法
- 1、将所有跟mybatis有关的配置文件放到resourses文件夹中。

- 2、在maven配置maven对资源文件的访问，具体做法：在pom中，build节点中加入一下配置：

```
<resources>
	<resource>
		<directory>src/main/resources</directory>
		<includes>
			<include>**/*.properties</include>
			<include>**/*.xml</include>
			<include>**/*.yml</include>
		</includes>
		<filtering>true</filtering>
	</resource>
	<resource>
	   <directory>src/main/java</directory>
	   <includes>
		   <include>**/*.properties</include>
			<include>**/*.xml</include>
			<include>**/*.yml</include>
	   </includes>
	 </resource>
</resources>
```

## 问题三
### Maven中 jar 包冲突的排查，主要使用到以下命令。

#### 1、mvn dependency:tree
以层级树方式展现。往往并不能查看到所有的传递依赖。

#### 2、mvn dependency:tree后的参数
- 1、-Dverbose 以层级树方式展现，全部。

- 2、-Dincludes=org.springframework:spring-tx  查找要查看的。可以不写全。

- 3、-Dexcludes=org.springframework:spring-tx 不包括这个。

mvn dependency:tree -Doutput=1.txt   导出到1.txt中。


<br/>
## 问题四
### 1、maven 下载 jar 包失败
删除本地的 repository 库中所有 .lastupdate 后缀的文件，重新下载

<br/>
## 问题五
### 2、idea 创建maven项目报错: Failed to create parent directories for tracking file
这个错误是下载一个pom文件的时候，maven创建这个文件所在的目录出错，所以直接在对应的提示的错误位置创建这个目录文件即可，只需要创建到版本号所在的文件即可。然后maven项目重新reimport就行了