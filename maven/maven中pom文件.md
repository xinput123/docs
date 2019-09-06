#### 1、指定项目打包后的名称
```
<build>
	<!-- 指定生成包的名字 -->
	<finalName>eureka-server</finalName>
</build>
```

#### 2、指定main方法入口
```
<build>
	<plugins>
		<plugin>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-maven-plugin</artifactId>
			<configuration>
				<!-- 指定main方法 -->
				<mainClass>com.learn6.EurekaServer</mainClass>
			</configuration>
		</plugin>
	</plugins>
</build>

```