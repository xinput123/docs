## 一、centos7安装docker
```
#查看你当前的内核版本
uname -r

#安装 Docker
yum -y install docker

#启动 Docker 后台服务
service docker start
```

## 二、centos7升级docker
#### 2-1、删除旧的docker,旧Docker版本 现在：特指1.13 前的版本，这是Docker的一个重要改动
```
docker stop `docker ps -a -q`
docker rm `docker ps -a -q`
docker rmi -f `docker images -a -q` //这里将会强制删除
```

<br/>

#### 2-2、移除旧版本的软件信息
```
yum -y remove docker docker-common container-selinux
```

<br/>

#### 2-3、移除docker-compose
```
// 先查看docker-compose位置
which docker-compose

rm -rf /usr/local/bin/docker-compose
```

<br/>

#### 2--4、设置最新稳定版本的Docker仓库
```
yum-config-manager --add-repo  https://docs.docker.com/v1.13/engine/installation/linux/repo_files/centos/docker.repo
```

<br/>

## 三、安装docker
#### 3-1、更新yum源
```
yum makecache fast
```

<br/>

#### 3-2、依赖
```
yum install -y yum-utils device-mapper-persistent-data lvm2aa
```

<br/>

#### 3-3、docker源
```
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

<br/>

#### 3-4、下载docker
```
yum -y install docker-ce
```

<br/>

#### 3-5、启动
```
systemctl start docker
```

<br/>

#### 3-6、开机自启动
```
systemctl enable docker
```

<br/>

#### 3-7、tab补全
```
yum -y install bash-completion
```

<br/>

#### 3-8、docker-compose下载
```
curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

<br/>

#### 3-9、授权
```
chmod +x /usr/local/bin/docker-compose
```