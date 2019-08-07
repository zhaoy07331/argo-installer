# 通过 Docker 安装 Argo

不建议将 Docker 安装版作为生产环境来使用，会有性能的损失和稳定性的风险。但由于 Docker 的便利性，我们依然欢迎大家尝试并且非常希望收到大家的反馈。

开始前，请确保 docker 的安装磁盘有 100G 以上的剩余空间。

## 安装 Docker

如果已经安装好 docker 请直接进入[下一步](https://github.com/analysys/argo-installer/blob/master/INSTALL_DOCKER.md#%E5%AE%89%E8%A3%85-argo)。

### 关闭防火墙

```bash
systemctl stop firewalld
systemctl disable firewalld
```

### 关闭selinux

```bash
sed -i ‘s/SELINUX=enforcing/SELINUX=disabled/g’ /etc/selinux/config
setenforce 0
```

### 安装epel源

```bash
yum install -y epel-release
```

### 安装docker

```bash
yum install docker -y
```

### 启动docker

```bash
systemctl start docker
systemctl enable docker
```

## 安装 Argo

### 拉取镜像

8G内存版

```bash
docker pull eguanargo/argo:431
```

16G内存版

```bash
docker pull eguanargo/argo16:433
```

32G内存版

```bash
docker pull eguanargo/argo32:433
```

### 通过渠道下载tar包 把tar包解开成镜像

```bash
tar xzvf argo431.tar.gz
cat argo431.tar | docker import - eguan/argo:431
```

### 启动容器

在“特权模式”下执行：

```bash
docker run -itd --privileged --name argo3 --hostname ark1 -v /kudu:/data1/kudu -p 8080:8080 -p 4005:4005 -p 8089:8089 -m 8G eguan/argo:431 /usr/sbin/init
```

#### 参数说明

- -p 8080:8080  // 容器往外映射的端口
- -p 4005:4005  // 后台端口
- -p 8089:8089  // SDK上数地址
- -m 8G/16G/32G // 分配的内存大小，根据版本不同而定

容器启动后，系统初始化10分钟左右，之后就可以访问了。

#### 访问 Ambari

- 地址：服务器IP:8080
- 账号：admin
- 密码：admin

查看服务自动启动情况，等到服务都能正常启动。

#### 访问 Argo

- 地址：服务器IP:4005
- 账号：admin
- 密码：111111

登录成功后，需先创建项目，然后就可以通过 appid 加上`服务器（外网）IP:8089`可以进行埋点上报了。

### 其它问题

#### 默认 Mysql 密码是什么？
Eguan@Grafana_123
