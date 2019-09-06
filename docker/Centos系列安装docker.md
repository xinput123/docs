## 一、Centos系列安装Docker
#### 1、Centos 6，可以使用EPEL库安装docker
```
yum install http://mirrors.yun-idc.com/epel/6/i386/epel-release-6-8.noarch.rpm

yum install docker-io
```

#### 2、Centos 7 ，系统Centos-Extras库中已带Docker
```
yum install docker
```

## 二、docker启动
```
service docker start

# 开机启动
chkconfig docker on
```