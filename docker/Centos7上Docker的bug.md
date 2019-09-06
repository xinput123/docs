```
Cannot ssh into a running pod/container – rpc error: code = 2 desc = oci 
runtime error: exec failed: container_linux.go:247: starting container 
process caused “process_linux.go:110: decoding init error from pipe 
caused \“read parent: connection reset by peer\“” command terminated 
with exit code 126 #21590
```

## 一、Bug的影响
如果你使用的是 CentOS7，需要用到 kubectl exec 或者为 Pod 配置了基于命令返回值的健康检查（非常用的 HTTP Get 方式）的话，该 Bug 将导致命令返回错误，Pod 无法正常启动，引起大规模故障，而且也无法使用 kubectl exec 或者 docker exec 与容器交互。

```
   livenessProbe:
     exec:
       command:
       - /usr/local/bin/sidecar-injector
       - probe
       - --probe-path=/health
       - --interval=4s
     failureThreshold: 3
     initialDelaySeconds: 10
     periodSeconds: 4
     successThreshold: 1
     timeoutSeconds: 1
   readinessProbe:
     exec:
       command:
       - /usr/local/bin/sidecar-injector
       - probe
       - --probe-path=/health
       - --interval=4s
     failureThreshold: 3
     initialDelaySeconds: 10
     periodSeconds: 4
     successThreshold: 1
     timeoutSeconds: 1
```

以上 YAML 配置摘自 [Istio](https://istio.io/zh/) 发行版中的 istio-demo.yaml 文件。

## 二、Bug成因
根据 [RedHat](https://bugzilla.redhat.com/show_bug.cgi?id=1655214) 的 Bug 报告，导致该 Bug 的原因是：

**CentOS7 发行版中的 Docker 使用的 docker-runc 二进制文件使用旧版本的 golang 构建的，这里面一些可能导致 FIPS 模式崩溃的错误。**

## 三、发现原因
使用docker1.13.1-84的版本创建镜像容器，docker exec总是提示最上面的错误。

## 四、解决方法
**有两种解决方法，都需要替换 Docker 版本。**

### 4-1、降级到旧的 RedHat CentOS 官方源中的 Docker 版本
将 RedHat 官方源中的 Docker 版本降级，这样做的好处是所有的配置无需改动，参考 https://github.com/openshift/origin/issues/21590。

#### 查看docker版本
```
$ rpm -qa | grep -i docker
    docker-common-1.13.1-84.git07f3374.el7.centos.x86_64
    docker-client-1.13.1-84.git07f3374.el7.centos.x86_64
    docker-1.13.1-84.git07f3374.el7.centos.x86_64
```

#### 降级 Docker 版本
```
yum downgrade docker-1.13.1-75.git8633870.el7.centos.x86_64 docker-client-1.13.1-75.git8633870.el7.centos.x86_64 docker-common-1.13.1-75.git8633870.el7.centos.x86_64
```

#### 降级之后再查看 Docker 版本：
```
$ rpm -qa | grep -i docker
    docker-common-1.13.1-75.git8633870.el7.centos.x86_64
    docker-1.13.1-75.git8633870.el7.centos.x86_64
    docker-client-1.13.1-75.git8633870.el7.centos.x86_64
```

此为临时解决方法，RedHat 也在着手解决该问题，为了可能会提供补丁，见 Bug 1655214 - docker exec does not work with registry.access.redhat.com/rhel7:7.3。

### 4-2、更新到 Docker-CE
Docker 自1.13版本之后更改了版本的命名方式，也提供了官方的 CentOS 源，替换为 Docker-CE 亦可解决该问题，不过 Docker-CE 的配置可能会与 Docker 1.13 有所不同，所以可能需要修改配置文件。