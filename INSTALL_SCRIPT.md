# 通过脚本安装 Argo

## 1. 环境准备

### 1.1 系统要求
请尽量不要让您的公网ip直接对外，不然会有中毒的风险。您可以使用内网ip通过网关的方式来访问外网。

方舟Argo安装部署手册的主要目的是指导使用该系统的用户方便快捷的安装系统和配置。
如果您已经下载好了安装包，请参考[离线安装](#offline_install)。

### 1.2 网络要求
能连通外网


### 1.3 硬件要求
* 体验环境
    * 4Core 8G内存 及以上
    * 系统盘:50G 
    * 数据盘:100G以上大小。**磁盘小于100G会安装失败！**
* 测试环境：
    * 8Core 16G内存 及以上
    * 系统盘:50G 
    * 数据盘:250G硬盘。
* 正式环境：
    * 16Core 32G内存 及以上
    * 系统盘:300G 
    * 数据盘:>500G磁盘，并且做RAID1或更高级别的配置。

### 1.4 系统要求
| 系统及其组件 | 系统要求                                        |
| ------------ | :---------------------------------------------- |
| 操作系统     | CentOS 7和 Redhat 7版本、强烈建议CentOS7.4      |
| 磁盘目录     | 系统盘：一定要有/opt目录。 |
| 磁盘目录     | 数据盘：如果只有一块数据盘，应该挂载到/data1目录下，如果有多块数据盘，依次挂载到/data1,/data2 ... 。 |
| 主机名       | 不能大写,不能有下划线"_"                        |
| 系统编码     | UTF-8                                           |
| 软件环境     | 不支持混合部署（单独给Argo一台服务器或云主机）                                  |

### 1.5 安装包说明

* standalone_remote_installer.sh  远程安装脚本
* standalone_offline_installer.sh 本地安装脚本
* init_ext4.sh 环境检查脚本，检查环境是否有问题

## 2.开始安装

### 2.1 准备工作

以下操作以4.3.1版本为样例，有些操作中涉及到的文件需要根据您安装的具体的版本号来定

* 创建目录

    先创建/opt/soft目录，/opt目录应该在系统盘上，可参考如下命令
    ```
    mkdir /opt/soft
    ```

* 在线安装
    1. 下载这里的 argo-installer 项目，解压后将config.properties和standalone_remote_installer.sh , init_ext4.sh放到/opt/soft目录下
    
        ```
        yum install wget unzip -y
        cd /tmp
        wget https://github.com/analysys/argo-installer/archive/4.3.1.zip
        unzip 4.3.1.zip
        cp argo-installer-4.3.1/config.properties /opt/soft/
        cp argo-installer-4.3.1/standalone_remote_installer.sh /opt/soft/
        cp argo-installer-4.3.1/init_ext4.sh /opt/soft/
        ```

* <span id="offline_install">离线安装</span> （_**在线自动安装，跳过该步骤**_）
    1. 下载安装包(百度网盘或Http）
    
    2. 将 analysys_installer_base_centos7.tar.gz， analysys_installer_base_centos7.tar.gz.md5， argo_centos7_4.3.1.tar.gz，argo_centos7_4.3.1.tar.gz.md5 4个文件放到服务器/opt/soft目录下。
    
    3. 下载这里的 argo-installer 项目，然后解压后将 config.properties 和standalone_offline_installer.sh，init_ext4.sh 文件放到服务器 /opt/soft/ 目录下
    
    1. **如果您通过windows机器下载脚本并上传到服务器上，过程中可能会导致shell脚本的文件格式变成 .dos，所以请先使用如下命令将shell脚本格式做个转换**
       
       ```
       cd /opt/soft
       
       #下载安装dos2unix工具
       yum install dos2unix -y
       
       #转换文件格式
       dos2unix init_ext4.sh
       
       #如果使用离线安装
       dos2unix standalone_offline_installer.sh
       ```
    

* 后续操作
    
    将init_ext4.sh脚本拷贝到机器上/opt/soft目录，执行该脚本检查机器是否满足要求。需要使用root用户或有sudo权限的普通用户
    
    ``` bash
    sudo sh init_ext4.sh
    ```

### 2.2 开始安装

#### 2.2.1 安装

以下操作以4.3.1版本为样例
1. 在线安装：配置服务器下载地址，修改/opt/soft/config.properties文件
    ```bash
    repo_url=http://arkinstall.analysys.cn/
    ```

    ```bash
    cd /opt/soft
    sh standalone_remote_installer.sh
    ```
2. 离线安装：
    ```bash
    cd /opt/soft
    sh standalone_offline_installer.sh
    ```

3. 输入必要的信息

    安装脚本需要您提供一些必要的系统信息，请按要求填写
    
    ```
    为了顺利安装，我们将收集一些信息。请您仔细填写。
    网卡和IP:
           lo: 127.0.0.1
           eth0: 172.31.43.79
    请输入需要内网IP对应的网卡名称，默认 [eth0]: 
    请输入您接下来的动作: install/upgrade. 默认[install]: 
    请输入mysql的密码.默认[Eguan@123] ：
    请输入argo的版本号，默认 [4.3.1]: 
    请输入linux系统root用户的密码： rrFG37Ui987
    请再次输入linux系统root密码：rrFG37Ui987
    请输入集群名称，默认 [platformName]: 
    请输入系统物理内存，只能为8/16/32/64/128,当前为 [64(G)]: 
    请输入外网IP: 
    
    ```
    
4. 等待安装成功

    第3步按要求输入需要的系统信息之后，就需要等待30分钟左右，直到出现如下日志输出，安装过程运行完成。如果日志不一样，或者有报错信息，请联系我们。

    ```
    ---------------------------------------------更新ark_config_info成功---------------------------------------
    + echo $'--------------------------------------\345\210\235\345\247\213\345\214\226\346\225\260\346\215\256\346\216\245\346\224\266\345\205\245\345\217\243url\346\210\220\345\212\237-----------------------------------'
    --------------------------------------初始化数据接收入口url成功-----------------------------------
    ```

#### 2.2.2 安装完成后，检查未成功启动的服务：

浏览器输入 http://${该服务器的内网ip}:8080

账密为 admin/admin

登陆进入后操作如下：
![](imgs/2.png)
按上图中的1、2、3步骤操作完成，直到没有红色叹号的服务。另外需要注意的是，由于服务状态检查有一定的延时，所以在安装完成过几分钟后再进行该操作，操作完成后也需要观察一段时间再看结果。

### 2.3 初始化收数地址（可选操作，使用IOS SDK时需要）

SDK往方舟里上报数据，需要知道方舟收数的地址。默认情况下，我们已经在安装脚本中将argo数据上报地址 http://${该服务器的外网ip}:8089 导入到了方舟argo中 。

但是IOS的SDK上报数据需要https，这种情况下，您需要单独部署一套nginx的服务器，并配置域名访问。具体请参考文档：[《前置 Nginx 配置说明》](https://github.com/analysys/argo-installer/issues/33)

然后将您配置的域名导入到argo中。

```bash
sudo su - streaming
/opt/soft/streaming/bin/init_data_entrance_url.sh https://${您配置的前置nginx的域名}:4089
```

### 2.4 开启故障自动恢复

#### 开启自动恢复功能，开启后，异常挂掉的服务会自己恢复重启

![](imgs/3.png)
然后:
![](imgs/4.png)


## 3.开始使用

### 3.1 管理后台

服务正常运行后，通过下列地址登录管理后台。

```
http://ip:4005/
```
初始账密为：

```
admin/111111
```

### 3.2 激活系统

第一次进入argo系统需要激活license，请输入下面的信息

> 495D220F07341C03B1FC7CB4F25455227B29990C9B7511C26FEE4C76D72E1D14477CC6AD54741B8414DE9BF2B787351FA2E2F4FC9DF24F19FBDD4395BB2CC0A645FC2E9749DEA34A09FB58378D758E0A9903E2642F10FC464F5AF8D7A6AC41B31065A6D0CF2EE9FD1B047C5B40B24C76848C3568C3ACE24E3C48C5796E7CC585D4587CA5D4F3FC17F6C45C71426E4867DDA80A10D26E79E95DA2437DC72A428193B728B51A9D77914C7C5437C6CFD1B3


接下来，你为自己创建一个日常使用的[账号](https://ark.analysys.cn/docs/enterprise-basic-function-member.html)，并创建一个[项目](https://ark.analysys.cn/docs/enterprise-basic-function-project-management.html)。

### 3.3 删除项目
argo可以在管理界面上通过项目管理模块来创建项目，但如果您想删除项目，需要您登陆argo的后台操作。
```
su - streaming
/opt/soft/streaming/drop_project.sh $appkey
```
