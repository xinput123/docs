## 一、可运行jar的pom配置
```
<build>
    <plugins>
        <plugin>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.1</version>
            <configuration>
                <source>1.8</source>
                <target>1.8</target>
                <encoding>UTF-8</encoding>
            </configuration>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>2.17</version>
            <configuration>
                <skipTests>true</skipTests>
            </configuration>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <configuration>
                <archive>
                    <manifest>
                        <addClasspath>true</addClasspath>
                        <classpathPrefix>lib/</classpathPrefix>
                        <!-- 如果不加这一句则依赖的SNAPSHOT的jar包就会表现为MANIFEST.MF中的
                        Class-Path: lib/facede-user-1.0-20160512.093945-1.jar
                        但是打包到../lib/facede-user-1.0-SNAPSHOT.jar下面包,这样就会出现找不到类的情况 -->
                        <useUniqueVersions>false</useUniqueVersions>
                        <!--指明main方法所在的具体路径 -->
                        <mainClass>Mainf方法</mainClass>
                    </manifest>
                </archive>
            </configuration>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-dependency-plugin</artifactId>
            <executions>
                <execution>
                    <id>copy</id>
                    <phase>package</phase>
                    <goals>
                        <goal>copy-dependencies</goal>
                    </goals>
                    <configuration>
                        <outputDirectory>
                            ./target/lib
                        </outputDirectory>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

## 二、maven坑点
#### 1、MAVEN插件打包SNAPSHOT包MANIFEST.MF 时间戳问题
> 当用maven的maven-jar-plugin插件打包依赖的SNAPSHOT的jar包就会表现为MANIFEST.MF中的Class-Path: lib/user-1.0-SNAPSHOT-20160512.093945-1.jar。
> 需要在里面添加 **<useUniqueVersions>false</useUniqueVersions>**。见下图位置

```
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <configuration>
        <archive>
            <manifest>
                <addClasspath>true</addClasspath>
                <classpathPrefix>lib/</classpathPrefix>
                <useUniqueVersions>false</useUniqueVersions>
                <mainClass>Mainf方法</mainClass>
            </manifest>
        </archive>
    </configuration>
</plugin>
```