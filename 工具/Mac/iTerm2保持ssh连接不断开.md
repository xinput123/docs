### 1、问题
iTerm2终端非常好用，但是进行ssh连接时，空闲一段时间后，经常会自动断掉。

### 2、解决：配置ssh参数
通过配置 ServerAliveInterval 来实现。在 ~/.ssh/config 中加入： ServerAliveInterval=30.

打开 vim ~/.ssh/config，新增

```
Host *
    ServerAliveInterval 60
```
- Host * : 所有连接的机器都保持
