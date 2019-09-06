## 引入 log4j2.jar的包,如在springboot中
```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-log4j2</artifactId>
</dependency>
```

## 剔除其他log.jar包
```
<dependency>
<groupId>org.springframework.boot</groupId>
<artifactId>spring-boot-starter-web</artifactId>
<exclusions>
    <exclusion>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-logging</artifactId>
    </exclusion>
</exclusions>
```

## log4j2.xml,按日期切割
```
<?xml version="1.0" encoding="UTF-8"?>
<!--日志级别以及优先级排序: OFF > FATAL > ERROR > WARN > INFO > DEBUG > TRACE > ALL -->
<!-- status log4j2内部日志级别 -->
<configuration status="INFO">
    <!-- 全局参数 -->
    <Properties>
        <Property name="pattern">%d{yyyy-MM-dd HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n</Property>
    </Properties>

    <appenders>
        <Console name="Console" target="SYSTEM_OUT">
            <!-- 本地测试需要打印sql语句时，可以将此处的 level设置为debug，以及 loggers.root.level设置为debug，即可查看全部sql语句 -->
            <ThresholdFilter level="INFO"/>
            <PatternLayout pattern="${pattern}"/>
        </Console>

        <!--处理INFO级别的日志，并把该日志放到logs/info.log文件中-->
        <RollingFile name="RollingFileInfo" fileName="./logs/info.log"
                     filePattern="logs/$${date:yyyy-MM}/info-%d{yyyy-MM-dd-HH}.log">
            <Filters>
                <!--只接受INFO级别的日志，其余的全部拒绝处理-->
                <ThresholdFilter level="INFO"/>
                <ThresholdFilter level="WARN" onMatch="DENY" onMismatch="NEUTRAL"/>
            </Filters>
            <PatternLayout pattern="${pattern}"/>
            <!-- 设置策略 -->
            <Policies>
                <!--
                    基于时间的触发策略。该策略主要是完成周期性的log文件封存工作。有两个参数：
				    interval，integer型，指定两次封存动作之间的时间间隔。
				        单位:以日志的命名精度来确定单位， 比如yyyy-MM-dd-HH 单位为小时，
				        yyyy-MM-dd-HH-mm 单位为分钟
				    modulate，boolean型，说明是否对封存时间进行调制。
				        若modulate=true，则封存时间将以0点为边界进行偏移计算。

				    比如，modulate=true，interval=4hours，
					    那么假设上次封存日志的时间为03:00，则下次封存日志的时间为04:00，
					    之后的封存时间依次为08:00，12:00，16:00
			     -->
                <TimeBasedTriggeringPolicy modulate="true" interval="1"/>
            </Policies>
            <DefaultRolloverStrategy max="360"/>
        </RollingFile>

        <!--处理WARN级别的日志，并把该日志放到logs/warn.log文件中-->
        <RollingFile name="RollingFileWarn" fileName="./logs/warn.log"
                     filePattern="logs/$${date:yyyy-MM}/warn-%d{yyyy-MM-dd-HH}-%i.log">
            <Filters>
                <!--只接受WARN级别的日志，其余的全部拒绝处理-->
                <ThresholdFilter level="WARN"/>
                <ThresholdFilter level="ERROR" onMatch="DENY" onMismatch="NEUTRAL"/>
            </Filters>
            <PatternLayout pattern="${pattern}"/>
            <Policies>
                <TimeBasedTriggeringPolicy modulate="true" interval="1"/>
            </Policies>
            <DefaultRolloverStrategy max="360"/>
        </RollingFile>

        <!--处理error级别的日志，并把该日志放到logs/error.log文件中-->
        <RollingFile name="RollingFileError" fileName="./logs/error.log"
                     filePattern="logs/$${date:yyyy-MM}/error-%d{yyyy-MM-dd-HH}-%i.log">
            <ThresholdFilter level="ERROR"/>
            <PatternLayout pattern="${pattern}"/>
            <Policies>
                <TimeBasedTriggeringPolicy modulate="true" interval="1"/>
            </Policies>
            <DefaultRolloverStrategy max="360"/>
        </RollingFile>
    </appenders>

    <loggers>
        <root level="INFO">
            <appender-ref ref="Console"/>
            <appender-ref ref="RollingFileInfo"/>
            <appender-ref ref="RollingFileWarn"/>
            <appender-ref ref="RollingFileError"/>
        </root>

        <!--log4j2 自带过滤日志-->
        <!-- Spring Loggers -->
        <logger name="org.springframework" level="info"/>
        <logger name="org.springframework.beans" level="info"/>
        <logger name="org.springframework.core" level="info"/>
        <logger name="org.springframework.context" level="info"/>
        <logger name="org.springframework.web" level="info"/>
        <logger name="org.springframework.batch" level="info"/>
        <logger name="org.springframework.integration" level="info"/>

        <!-- Apache Loggers -->
        <logger name="org.apache" level="info"/>
        <logger name="org.apache.http" level="info"/>
        <logger name="org.apache.shiro" level="info"/>
        <logger name="org.apache.solr" level="info"/>
        <logger name="org.apache.lucene" level="info"/>
        <logger name="org.apache.tomcat" level="info"/>
        <logger name="org.apache.commons" level="info"/>

        <!-- MyBatis Loggers -->
        <logger name="org.mybatis" level="info"/>
        <logger name="org.apache.ibatis" level="info"/>

        <!-- Alibaba Loggers -->
        <logger name="com.alibaba" level="info"/>
        <logger name="com.alibaba.druid" level="info"/>
    </loggers>
</configuration>
```