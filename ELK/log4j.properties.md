## 一、日志相关配置。个人经常使用的日志配置文件。
#### 1、log4j.properties文件：
```
log4j.rootLogger = WARN, C, E

### console ###
log4j.appender.C = org.apache.log4j.ConsoleAppender
log4j.appender.C.Target = System.out
log4j.appender.C.Threshold = ERROR
log4j.appender.C.layout = org.apache.log4j.PatternLayout
log4j.appender.C.layout.ConversionPattern = [xinput-util][%p] [%-d{yyyy-MM-dd HH:mm:ss}] %C.%M(%L) | %m%n

### file ###
log4j.appender.E = org.apache.log4j.DailyRollingFileAppender
log4j.appender.E.File = ../logs/xinput-util.log
log4j.appender.E.Append = true
log4j.appender.E.Threshold = ERROR
log4j.appender.E.layout = org.apache.log4j.PatternLayout
log4j.appender.E.layout.ConversionPattern = [xinput-util][%p] [%-d{yyyy-MM-dd HH:mm:ss}] %C.%M(%L) | %m%n
log4j.appender.E.Encoding = UTF-8 
log4j.logger.com.xinput=INFO
log4j.logger.com.xinput.report.mapper=TRACE
log4j.logger.com.xinput.report.mapper.selectCrmSysUserById=TRACE
```

#### 2、maven中配置，没有配置版本号，可以自己选
```
<!-- SLF4J-->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-log4j12</artifactId>
    <version>1.7.25</version>
</dependency>
```

#### 3、相应方法
```
public class DateUtils {

	private static final Logger logger = LoggerFactory.getLogger(DateUtils.class);
	
	public static void main(String[] args) {
		try{
			String str = "abc";
			System.out.println(str);
			logger.info("参数 : " + str);
			throw new Exception("Exception .....");
		}catch (Exception e){
			e.printStackTrace();
			logger.info("error:",e);
		}
	}
}
```

## 二、Log4j 说明
#### 1、log4j.rootLogger = WARN, C, E
将等级为WARN的日志信息输出到C和E这两个目的地，stdout和R的定义在下面的代码，可以任意起名。等级可分为OFF、FATAL、ERROR、WARN、INFO、DEBUG、ALL，如果配置OFF则不打出任何信息，如果配置为INFO这样只显示INFO, WARN, ERROR的log信息，而DEBUG信息不会被显示。

#### 2、log4j.appender.C = org.apache.log4j.ConsoleAppender
定义名为 C 的输出端是哪种类型，可以是 ：

- org.apache.log4j.ConsoleAppender(控制台)；
- org.apache.log4j.FileAppender(文件)；
- org.apache.log4j.DailyRollingFileAppender(每天产生一个日志文件)；
- org.apache.log4j.RollingFileAppender(文件大小到达指定尺寸的时候产生一个新的文件)；
- org.apache.log4j.WriterAppender(将日志信息以流格式发送到任意指定的地方)。

#### 3、log4j.appender.C.layout = org.apache.log4j.PatternLayout
定义名为 C 的输出端的layout是哪种类型，可以是：

- org.apache.log4j.HTMLLayout（以HTML表格形式布局）；
- org.apache.log4j.PatternLayout（可以灵活地指定布局模式）；
- org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串） 
- org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等等信息）。

#### 4、log4j.appender.C.layout.ConversionPattern = [xinput-util][%p] [%-d{yyyy-MM-dd HH:mm:ss}] %C.%M(%L) | %m%n
如果使用pattern布局就要指定的打印信息的具体格式。ConversionPattern，打印参数如下：

- %m 输出代码中指定的消息；
- %p 输出优先级，即DEBUG，INFO，WARN，ERROR，FATAL
- %r 输出自应用启动到输出该log信息耗费的毫秒数
- %c 输出所属的类目，通常就是所在类的全名
- %t 输出产生该日志事件的线程名
- %n 输出一个回车换行符，Windows平台为“rn”，Unix平台为“n”
- %d 输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，比如：%d{yyyy MMM dd HH:mm:ss,SSS}，输出类似：2002年10月18日 22：10：28，921
- %L 输出日志事件的发生位置，包括类目名、发生的线程，以及在代码中的行数。
- [xinput-util]是log信息的开头，可以为任意字符，一般为项目简称。

![image.png](http://upload-images.jianshu.io/upload_images/4046640-8ff663a202feb200.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 5、log4j.appender.E = org.apache.log4j.DailyRollingFileAppender
定义名为 E 的输出端的类型为每天产生一个日志文件。

#### 6、log4j.appender.E.File = ../logs/xinput-util.log
为定义名为E的输出端的文件名为logs/xinput-util.log,文件名可以自行修改。

#### 7、log4j.appender.C.Threshold = ERROR
指定日志消息的输出最低层次。

#### 8、log4j.appender.E.MaxFileSize=10KB，log4j.appender.E.MaxBackupIndex=50
第一条命令指定 在日志文件到达该大小时，将会自动滚动，即将原来的内容移到*.log.1文件；第二条命令指定可以产生的滚动文件的最大数。当然了，这两个命令只有和 log4j.appender.E = org.apache.log4j.RollingFileAppender 这个一起时，才能生效。

#### 9、log4j.appender.C.Target ，在控制台打印出来的颜色，默认是 System.out。

- System.err在控制台打印出来的日志呈现红色（醒目色）；
- System.out在控制台打印出来的日志呈现黑色（正常色）；

#### 10、log4j.logger.com.xinput=INFO
指定com.xinput包下的所有类的等级为INFO的日志全部输出。

#### 11、log4j.logger.com.xinput.report.mapper=TRACE
- 记录com.xinput.report.mapper接口或者是mapper.xml命名空间为com.xinput.report.mapper的sql进行日志记录。

#### 12、log4j.logger.com.xinput.report.mapper.selectCrmSysUserById=TRACE
- 将日志从整个mapper接口级别调整到到语句级别，从而实现更细粒度的控制。如上配置只记录 selectCrmSysUserById语句的日志。
-  ***如果某些查询可能会返回大量的数据，只想记录其执行的SQL语句该怎么办?***
Mybatis中SQL语句的日志级别为DEBUG（JDK Logging中为FINE），结果日志的级别为TRACE（JDK Logging中为FINER)。