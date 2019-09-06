### 1、maven pom文件,maven配置profile
```
<build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
        <resources>
            <resource>
                <directory>src/main/resources</directory>
                <filtering>true</filtering>
                <excludes> <!--不同环境下的配置文件-->
                    <exclude>application.properties</exclude>
                    <exclude>application-dev.properties</exclude>
                    <exclude>application-pro.properties</exclude>
                    <exclude>application-test.properties</exclude>
                </excludes>
            </resource>
            <resource>
                <directory>src/main/resources</directory>
                <filtering>true</filtering>
                <includes>
                    <include>application.properties</include>
                    <!-- 根据你maven指定的参数P test -Dtest=TestActiveMQ -Pdev 加
                    载不同的配置文件-->
                    <include>application-${profileActive}.properties</include>
                </includes>
            </resource>
        </resources>
    </build>
    <profiles>
        <profile>
            <id>dev</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <profileActive>dev</profileActive>
            </properties>
        </profile>
        <profile>
            <id>pro</id>
            <properties>
                <profileActive>pro</profileActive>
            </properties>
        </profile>
        <profile>
            <id>test</id>
            <properties>
                <profileActive>test</profileActive>
            </properties>
        </profile>
    </profiles>
```

### 2、指定编译环境
```
install -Dmaven.test.skip=true

install -Dmaven.test.skip=true -P dev
```