有很多场景，我们都需要删除redis中某些具有相似特征的key,即使是线上环境也是。如果key数量很小容易处理，如果这些key很多很多，必须通过scan命令循环扫描一一删除，如果直接执行keys命令会堵死redis服务。下面这个脚本就是通过循环扫码key再删除，直至结束。

## redis-del-keys.sh
见[redis-del-keys.sh](https://github.com/xinput123/docs/blob/master/Redis/redis-del-keys.sh)

## 运行
```
sh redis-del-keys.sh localhost 6379 users:*
```