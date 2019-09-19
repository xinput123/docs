#### 1、查看文件大小或系统使用情况 du df
- **du -h** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;  查看当前目录下所有文件大小的总和
- **du -sh** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  查看当该目录下总的文件大小
- **du -sh mysql5.6.tar.gz** &nbsp;&nbsp; 查看mysql5.6.tar.gz文件的大小 du -ah 显示当前目录下每个文件的大小
- **df -h** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 显示目前所有文件系统的可用空间及使用情况。

#### 2、在linux中修改当前用户密码
```
// 先查看用户是否是root
id

// 输入修改密码指令
passwd

// 输入两次密码即可，直接粘贴复制
```

#### 3、后台任务管理
```
// 创建后台,创建了一个名叫stats的后台，并马上进入，退出时需要ctrl A D。
screen -S stats

// 进入名称为stats的后台
screen -r stats

// 创建一个新的后台任务,创建了一个名叫stats的后台，并马上进入，退出时需要 ctrl A D。
screen -S stats

// 查看后台任务,查看名称叫stats的后台。
ps -ef | grep stats 

// 进入后台,进入名称为stats的后台
screen -r stats 
```

#### 4、tar 命令
```

```