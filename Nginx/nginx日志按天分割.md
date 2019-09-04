默认情况下，nginx将每天网站访问的日志都写在一个文件里面，随着时间的 推移，这个文件会越来越大，最终会成为问题。我们可以写个脚本来每天自动地按天(或者 小时)来切割日志。


```
#!/bin/bash
## 零点执行该脚本
old=$(date -d "-5 day" +%Y-%m-%d)

## Nginx 日志文件所在的目录
LOGS_PATH=/usr/local/nginx/logs

##设置pid文件
pid_path=&quot;/usr/local/nginx/nginx.pid&quot;

## 获取昨天的 yyyy-MM-dd
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)

## 移动文件
mv ${LOGS_PATH}/access.log ${LOGS_PATH}/access_${YESTERDAY}.log mv ${LOGS_PATH}/error.log ${LOGS_PATH}/error_${YESTERDAY}.log

## 向 Nginx 主进程发送 USR1 信号。USR1 信号是重新打开日志文件 kill -USR1 `cat ${pid_path}`
thistime2=$(date)

## 删除5天之前的文件
rm -rf ${LOGS_PATH}/access_${old}.log
rm -rf ${LOGS_PATH}/error_${old}.log
```

上面的程序是一个bash脚本。
 
- LOGS_PATH是nginx存放日志的路径;
- YESTERDAY 是昨天的时间，格式是%Y-%m-%d; 首先将当前nginx服务器正在写的日志移到带日期的文件中。
- 这里注意，mv完日志之后，一 定需要调用 kill -USR1 `cat ${pid_path}`，否则日志将不会写到 ${LOGS_PATH}access.log文件中。

这个脚本需要放到一个目录下面，这里我假设放到了我/usr/local/nginx/logs，名 称是nginx_cut.sh。我们需要定时的调用这个脚本才能切日志，可以利用Linux自带的定时 功能crontab -e 进行设置，内容如下:

```
00 00 * * *   /bin/sh   /usr/local/nginx/logs/nginx_cut.sh
```

crontab配置计划任务的书写格式

```
分钟 小时 日月周 [用户名] 命令
```

命令说明

- 第一个参数定义的是:分钟，表示每个小时的第几分钟来执行。范围0-59 
- 第二个参数定义的是:小时，表示从第几个小时来执行，范围是0-23 
- 第三个参数定义的是:日期，表示从每个月的第几天来执行，范围是1-31 
- 第四个参数定义的是:月，表示每年的第几个月来执行，范围是1-12 
- 第五个参数定义的是:周，表示每周的第几天执行，范围是0-6，其中0表示星期日 
- 第六个参数定义的是:用户名，也就是执行程序要通过哪个用户来执行，这个一般可以省略;
- 第七个参数定义的是:执行的命令和参数

设置完成以后，这个脚本就会在每天的00:00进行切割日志操作。