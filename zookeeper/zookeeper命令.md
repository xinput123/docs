# ZooKeeper命令

### 启动服务器
```
./zkServer.sh start
```

### 查看Zookeeper状态
```
./zkServer.sh status
```

### 创建持久节点
```
create /app    创建持久节点

create /name "xinput"   创建持久节点，并设置持久节点的值
```

### 创建顺序节点
```
create -s /age    创建顺序节点

create -s /ages "18"   创建顺序节点，并设置持久节点的值
```

### 创建临时节点
```
create -e /node 创建node临时节点，临时节点不会保存，重启后就删除了

create -e /master "xinput" 创建 master 临时节点，并设置节点的值为 "xinput"
```

### 创建子节点
```
create /app/app1 创建子节点。创建子节点时，父节点一定要存在，并且必须是持久节点，临时节点不允许有子节点

create /app/app11 "app11" 创建字节点
```

### 创建临时子节点
```
create -e /app/app2 创建临时子节点。创建子节点时，父节点一定要存在，并且必须是持久节点，临时节点不允许有子节点

create -e /app/app3 "app3" 创建字节点
```

### 查看节点数据
```
get /name
```

### 设置、修改节点数据
```
set /name "lai"
```

### 删除没有子节点的节点
```
delete /name
```

### 删除有子节点的节点
```
rmr /name
deleteall /name   rmr已过期，推荐使用deleteall代替
```

### Zk监控节点
- stat -w /master  表示监控 master 这个几点的信息，如果这个节点信息发生改变，会收到一个通知


### Zk查看节点
- ls -R /  查看主节点下的所有节点信息，-R 表示递归向下查看
