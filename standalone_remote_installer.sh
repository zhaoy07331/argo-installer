#!/bin/bash 
#by analysys
#v1.0



c_yellow="\e[1;33m"
c_red="\e[1;31m"
c_end="\e[0m"

mkdir /root/.ssh
chmod 700 /root/.ssh
touch ~/.ssh/config
cat > ~/.ssh/config << end
UserKnownHostsFile /dev/null
ConnectTimeout 15
StrictHostKeyChecking no
end
set -e

init_ext4(){

	echo -e "\033[42;34m ==============开始检查系统环境是否可用......================= \033[0m"
	cd /opt/soft
	sudo sh init_ext4.sh
}


function install()
{
    set -e
    if [ ""$osType == "centos7" ];then
        baseUrl="$repo_url/analysys_installer_base_centos7.tar.gz"
        basemd5Url="$repo_url/analysys_installer_base_centos7.tar.gz.md5"
        arkUrl="$repo_url/argo_$targetVersion/argo_centos7_$targetVersion.tar.gz"
        arkmd5Url="$repo_url/argo_$targetVersion/argo_centos7_$targetVersion.tar.gz.md5"
    elif [ ""$osType == "centos6" ];then
        baseUrl="$repo_url/analysys_installer_base_centos6.tar.gz"
        basemd5Url="$repo_url/analysys_installer_base_centos6.tar.gz.md5"
        arkUrl="$repo_url/argo_$targetVersion/argo_centos6_$targetVersion.tar.gz"
        arkmd5Url="$repo_url/argo_$targetVersion/argo_centos6_$targetVersion.tar.gz.md5"
    else
        echo "不支持的操作系统版本"
        exit 1
    fi



    echo "******************************************************************************"
    echo -e "\033[42;34m ==============开始下载基础安装包......================= \033[0m"
    echo "sudo yum install wget -y -d 0 -e 0"
    sudo yum install wget -y -d 0 -e 0
    cd /opt/soft

    if [ -f /opt/soft/analysys_installer_base_$osType.tar.gz ];then
        echo "已存在基础安装包，检查文件完整性..."
        echo " "
        echo " "
        if [ -f /opt/soft/analysys_installer_base_$osType.tar.gz.md5 ];then
            rm -rf /opt/soft/analysys_installer_base_$osType.tar.gz.md5
        fi
        wget -c -O  /opt/soft/analysys_installer_base_$osType.tar.gz.md5 $basemd5Url
        set +e
        checksum=`md5sum -c  analysys_installer_base_$osType.tar.gz.md5`
        set -e

        if [[ "$checksum" == analysys_installer_base_$osType.tar.gz:*  ]];then
            echo "文件完整，跳过下载"
            echo " "
            echo " "
        else
            echo "文件不完整，重新下载..."
            echo " "
            echo " "
            rm -rf /opt/soft/analysys_installer_base_$osType.tar.gz
            wget -c -O /opt/soft/analysys_installer_base_$osType.tar.gz $baseUrl
            rm -rf /opt/soft/analysys_installer_base_$osType.tar.gz.md5
            wget -c -O  /opt/soft/analysys_installer_base_$osType.tar.gz.md5 $basemd5Url
            set +e
            checksum=`md5sum  -c  analysys_installer_base_$osType.tar.gz.md5`
            set -e
            if [[ "$checksum" == analysys_installer_base_$osType.tar.gz:* ]];then
                echo "文件完整，下载成功"
                echo " "
                echo " "
            else
                echo "文件不完整，下载失败，可能是源出了问题，请联系我们！"
                exit 1
            fi
        fi
    else
        wget -c -O  /opt/soft/analysys_installer_base_$osType.tar.gz $baseUrl

        if [ -f /opt/soft/analysys_installer_base_$osType.tar.gz.md5 ];then
            rm -rf /opt/soft/analysys_installer_base_$osType.tar.gz.md5
        fi

        wget -c -O  /opt/soft/analysys_installer_base_$osType.tar.gz.md5 $basemd5Url

        set +e
        checksum=`md5sum  -c  analysys_installer_base_$osType.tar.gz.md5`
        set -e
        if [[ "$checksum" == analysys_installer_base_$osType.tar.gz:* ]];then
            echo "文件完整，下载成功"
            echo " "
            echo " "
        else
            echo "文件不完整，下载失败，可能是源出了问题，请联系我们！"
            exit 1
        fi

    fi


    echo "******************************************************************************"
    echo -e "\033[42;34m ==============开始下载$targetVersion安装包......================= \033[0m"

    if [ -f /opt/soft/argo_${osType}_$targetVersion.tar.gz ];then
        echo "已存在argo_${osType}_$targetVersion.tar.gz安装包，检查文件完整性..."
        echo " "
        echo " "
        if [ -f /opt/soft/argo_${osType}_$targetVersion.tar.gz.md5 ];then
            rm -rf /opt/soft/argo_${osType}_$targetVersion.tar.gz.md5
        fi
        wget -c -O  /opt/soft/argo_${osType}_$targetVersion.tar.gz.md5 $arkmd5Url
        set +e
        checksum=`md5sum  -c   argo_${osType}_$targetVersion.tar.gz.md5`
        set -e
        if [[ "$checksum" == argo_${osType}_$targetVersion.tar.gz:* ]];then
            echo "文件完整，跳过下载"
            echo " "
            echo " "
        else
            echo "文件不完整，重新下载..."
            echo " "
            echo " "
            rm -rf /opt/soft/argo_${osType}_$targetVersion.tar.gz
            wget -c -O  /opt/soft/argo_${osType}_$targetVersion.tar.gz $arkUrl
            rm -rf /opt/soft/argo_${osType}_$targetVersion.tar.gz.md5
            wget -c -O  /opt/soft/argo_${osType}_$targetVersion.tar.gz.md5 $arkmd5Url
            set +e
            checksum=`md5sum -c argo_${osType}_$targetVersion.tar.gz.md5`
            set -e
            if [[ "$checksum" == argo_${osType}_$targetVersion.tar.gz:* ]];then
                echo "文件完整，下载成功"
                echo " "
                echo " "
            else
                echo "文件不完整，下载失败，可能是源出了问题，请联系我们！"
                exit 1
            fi
        fi
    else
        wget -c -O  /opt/soft/argo_${osType}_$targetVersion.tar.gz $arkUrl

        if [ -f /opt/soft/argo_${osType}_$targetVersion.tar.gz.md5 ];then
            rm -rf /opt/soft/argo_${osType}_$targetVersion.tar.gz.md5
        fi

        wget -c -O  /opt/soft/argo_${osType}_$targetVersion.tar.gz.md5 $arkmd5Url
        set +e
        checksum=`md5sum -c argo_${osType}_$targetVersion.tar.gz.md5`
        set -e
        if [[ "$checksum" == argo_${osType}_$targetVersion.tar.gz:* ]];then
            echo "文件完整，下载成功"
            echo " "
            echo " "
        else
            echo "文件不完整，下载失败，可能是源出了问题，请联系我们！"
            exit 1
        fi

    fi


    echo "******************************************************************************"
    echo -e "\033[42;34m ==============开始解压安装包......================= \033[0m"
    cd /opt/soft
    echo "tar -zxf analysys_installer_base_centos7.tar.gz ..."
    tar -zxf analysys_installer_base_centos7.tar.gz
    echo "tar -zxf argo_${osType}_$targetVersion.tar.gz ..."
    tar -zxf argo_${osType}_$targetVersion.tar.gz
    cd analysys_installer


    echo "******************************************************************************"
    echo -e "\033[42;34m ==============开始自动修改安装参数......================= \033[0m"



    #修改ship.name参数
    blueprint="1node-${node_memory}g-ark-hdp2.6.1.0"
    cluster_defi_file="${blueprint}/cluster-defi.properties"
    sudo sed -i  "s/ship\.name=UNKNOW/ship\.name=${cluster_name}/" /opt/soft/analysys_installer/tool/ark-blueprint/conf/${cluster_defi_file}


    #修改host.file文件
    echo "ark1.analysys.xyz:${install_user}:${install_user_password}" > /opt/soft/analysys_installer/host.file

    #修改邮件告警模板文件
    sudo sed -i  "s/北京易观/${cluster_name}/" /opt/soft/analysys_installer/tool/alert-templates-custom.xml


    echo "******************************************************************************"
    echo -e "\033[42;34m ==============开始安装......================= \033[0m"
    cd /opt/soft/analysys_installer
    echo "sh analysys_install.sh ark1.analysys.xyz 22 $mysql_root_password $blueprint $osType $install_user 1"

  echo "y"|  sh analysys_install.sh ark1.analysys.xyz 22 $mysql_root_password $blueprint $osType $install_user 1

}


##提示信息
echo -e "${c_yellow}为了顺利安装，我们将收集一些信息。请您仔细填写。${c_end}"

#检查当前用户是否为root
osuser=`whoami`
if [ ${osuser} != "root" ];then
        echo -e "\e[1;31m You must use root to execute script.\e[0m"
        exit 99
fi

#设置主机名
hostnamectl set-hostname ark1

#设置host文件
#echo "internet name:"
echo "网卡和IP:"
for i in `ip addr | egrep "^[0-9]" | awk -F ':' '{print $2}'`
do
        echo -e "       \e[1;33m"$i": "`ifconfig $i | egrep -v "inet6" | awk -F 'net|netmaskt' '{print $2}' | sed ':label;N;s/\n//;b label' | sed -e 's/ //g' -e 's/)//g'`"\e[0m"
done

while true
do
        #read -p "`echo -e "please enter the name of Ethernet，default [${c_yellow}eth0${c_end}]: "`" eth
        read -p "`echo -e "请输入需要内网IP对应的网卡名称，默认 [${c_yellow}eth0${c_end}]: "`" eth
        ipaddr=`ifconfig ${eth:-eth0} 2> /dev/null | egrep -v "inet6" | awk -F'inet|netmask' '{print $2}' | sed ':label;N;s/\n//;b label' | sed 's/ //g'`
        [ "${ipaddr:-None}" == "None" ]&& echo -e "pleas input the ${c_red}exact name of Ethernet${c_end}"&& continue
        if [ -n "$(echo ${ipaddr} | sed 's/[0-9]//g' | sed 's/.//g')" ];then
                echo -e 'shell can not obtain ip,pleas input the ${c_red}exact name of Ethernet${c_end}'
        continue
        else
                echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 " > /etc/hosts
                echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6 " >> /etc/hosts
                echo ${ipaddr}"     ark1.analysys.xyz ark1" >> /etc/hosts
                break
        fi
done


##获取安装相关信息
#获取是安装还是升级
while true
do
	read -p "`echo -e "请输入您接下来的动作: ${c_yellow}install/upgrade${c_end}. 默认[${c_yellow}install${c_end}]: "`" argo_action
	
	if [ "${argo_action:=install}" == "install" ];then
		break
	elif [ "${argo_action}" == "upgrade" ];then
		#echo -e "${c_red}upgrade is not avable.${c_end}"
		echo -e "${c_red}upgrade 暂时不可用。${c_end}"
		#echo -e "${c_red}please use other options.${c_end}"
		echo -e "${c_red}请输入其他选项。${c_end}"
		continue
	else
		echo -e "${c_red}您输入的为无效选项，请输入正确选项动作。${c_end}"
		continue
	fi
done

#获取mysql密码
while true
do
        read -p "`echo -e "请输入mysql的密码.默认[${c_yellow}Eguan@123${c_end}] ："`" mysql_pwd
        if [ "${mysql_pwd:=Eguan@123}" == "None" ];then
          
                echo -e "${c_red}mysql不能为空。${c_end}"
                continue
        else
                break
        fi
done




#获取mysql密码
#while true
#do
#	#read -p "`echo -e "please enter the password of mysql 默认[${c_yellow}Eguan@123${c_end}] : "`" mysql_pwd
#	read -p "`echo -e "请输入mysql的密码.默认[${c_yellow}Eguan@123${c_end}] ："`" mysql_pwd
#	
#	if [ "${mysql_pwd:-None}" == "None" ];then
#		#echo -e "${c_red}The password of mysql is not empty.${c_end}"
#		echo -e "${c_red}密码不能为空。${c_end}"
#		continue
#	else #[ "${mysql_pwd}" != "None" ];then
#		#read -p "`echo -e "please enter the password of mysql again: "`" mysql_pwd_rp
#		read -p "`echo -e "请再次输入mysql密码： "`" mysql_pwd_rp
#		if [ "${mysql_pwd}" != "${mysql_pwd_rp}" ];then
#			echo -e "${c_red}2次输入的密码不匹配。${c_end}"
#			continue
#		else
#			break
#		fi

		
#	fi
#done

#获取argo版本号
while true
do
        read -p "`echo -e "请输入argo版本号.默认[${c_yellow}4.1.17${c_end}] ："`" argo_ver
        if [ "${argo_ver:=4.1.17}" == "None" ];then

                echo -e "${c_red}argo版本号不能为空。${c_end}"
                continue
        else
                break
        fi
done

#argo_ver=4.1.17

os_ver1=centos7
#获取root用户密码
while true
do
	#read -p "`echo -e "please enter the password of root: "`" root_pwd
	read -p "`echo -e "请输入linux系统root用户的密码： "`" root_pwd
	if [ "${root_pwd:-None}" == "None" ];then
		#echo -e "${c_red}The password of root is not empty.${c_end}"
		echo -e "${c_red}Root密码不能为空。${c_end}"
		continue
	else
		#read -p "`echo -e "please enter the password of root again: "`" root_pwd_rp
		read -p "`echo -e "请再次输入linux系统root密码："`" root_pwd_rp
		if [ "${root_pwd}" != "${root_pwd_rp}" ];then
			#echo -e "${c_red}The passwords entered twice do not match.${c_end}"
			echo -e "${c_red}2次输入的密码不匹配。${c_end}"
			continue
		else
			break
		fi
		
	fi
done


#获取集群名称
while true
do
	#read -p "`echo -e "please enter the clustername: default [${c_yellow}platformName${c_end}]: "`" cluster_name
	read -p "`echo -e "请输入集群名称，默认 [${c_yellow}platformName${c_end}]: "`" cluster_name
	if [ "${cluster_name:=platformName}" == "None" ];then
		#echo -e "${c_red}The cluster name can not be None.${c_end}"
		echo -e "${c_red}集群名称不能为空。${c_end}"
		continue
	else
		break
	fi
done

os_mem=`free -m | egrep Mem | awk '{printf("%.0f\n",$2/1024)}'`
if [ ${os_mem} -lt 7 ];then
	echo -e "${c_red}物理内存不能低于8G。${c_end}"
	exit 96

elif [ ${os_mem} -eq 7 ];then
        os_mem=$(($os_mem+1))
elif [ ${os_mem} -eq 15 ];then
        os_mem=$(($os_mem+1))
elif [ ${os_mem} -eq 31 ];then
	os_mem=$(($os_mem+1))
elif [ ${os_mem} -eq 63 ];then
	os_mem=$(($os_mem+1))
elif [ ${os_mem} -eq 127 ];then
	os_mem=$(($os_mem+1))
fi

while true
do
	read -p "`echo -e "请输入系统物理内存，只能为8/16/32/64/128,当前为 [${c_yellow}${os_mem}(G)${c_end}]: "`" os_mem

	if [ "${os_mem:-None}" == "None" ];then
		os_mem=`free -m | egrep Mem | awk '{printf("%.0f\n",$2/1024)}'`
		if [ ${os_mem} -lt 7 ];then
			echo -e "${c_red}物理内存不能低于8G。${c_end}"
			continue

                elif [ ${os_mem} -eq 7 ];then
                        os_mem=$(($os_mem+1))
                        break

                elif [ ${os_mem} -eq 15 ];then
                        os_mem=$(($os_mem+1))
                        break

		elif [ ${os_mem} -eq 31 ];then
			os_mem=$(($os_mem+1))
			break
		elif [ ${os_mem} -eq 63 ];then
			os_mem=$(($os_mem+1))
			break
		elif [ ${os_mem} -eq 127 ];then
			os_mem=$(($os_mem+1))
			break
		fi
	elif [ $os_mem -ne 8 -a $os_mem -ne 16 -a  $os_mem -ne 32 -a $os_mem -ne 64 -a $os_mem -ne 128 ];then
		echo -e "${c_red}node_memory只支持8 , 16 , 32 , 64 , 128 ,不支持其它值${c_end}"
		continue
	else
		break
	fi

done

#获取外网地址
while true
do
        #read -p "`echo -e "please enter the name of Ethernet，default [${c_yellow}eth0${c_end}]: "`" eth
        read -p "`echo -e "请输入外网IP: "`" IP_out
        [ "${IP_out:-None}" == "None" ]&& echo -e "${c_red}IP不能为空，请输入正确的IP地址。${c_end}"&& continue
        if [ -n "$(echo ${IP_out} | sed 's/[0-9]//g' | sed 's/.//g')" ];then
                echo -e '${c_red}请输入正确的IP地址，否则无法初始化数据${c_end}'
        continue
        else
                break
        fi
done


#初始化安装
echo -e "${c_yellow}安装大约需要30-50分钟左右，请您喝杯茶耐心等待。${c_end}"
init_ext4

#离线安装
if [ ""$argo_action == "install" ];then
    
    export mysql_root_password=$mysql_pwd
    export targetVersion=$argo_ver
    export osType=$os_ver1
    export install_user="root"
    export install_user_password=$root_pwd
    export cluster_name=$cluster_name
    export node_memory=$os_mem
    repo_url=`grep repo_url config.properties`
    repo_url=${repo_url##*=}
    export repo_url

    if echo "$cluster_name" | grep -q '^[a-zA-Z0-9]\+$'; then
        echo "OK"
    else
        echo "cluster_name 参数的值 $cluster_name 非法，只能是字母和数字"
        exit 1
    fi

    echo "检查机器硬件配置..."
    data1_size=`df -BG | grep data1 | awk '{print $2}' | awk -F 'G' '{print $1}'`
    if [ ""$data1_size == "" ];then
        echo "${c_yellow}没有检查到数据盘 /data1 请先挂载数据盘。${c_end}"
        exit 1
    else
        if [ $data1_size -lt 100 ];then
            echo "${c_yellow}数据盘 /data1 空间不大于100G，无法安装。${c_end}"
            exit 1
        fi
    fi

    echo "检查是否已经安装了方舟..."
    set +e
    hadoop version
    if [ $?"" -eq 0 ];then
        echo "检查到您已经安装了方舟或大数据平台hadoop相关的服务，如果您已经安装了方舟，请使用upgrade命令升级到你想要的版本，如果没有安装方舟，请你更换一台没有安装过任何大数据组件的机器！"
        exit 1
    fi

    echo "${c_yellow}您的系统正常，请忽略上面hadoop的错误输出。${c_end}"

    #初始化安装
    echo -e "${c_yellow}安装大约需要30-50分钟左右，请您喝杯茶耐心等待。${c_end}"

    sleep 5

    init_ext4

    install

    ##导入license
    echo -e "${c_yellow}开始导入License,请耐心等待${c_end}"
    su - streaming -c "/opt/soft/streaming/bin/init_license_info.sh 1 495D220F07341C03B1FC7CB4F25455227B29990C9B7511C26FEE4C76D72E1D14477CC6AD54741B8414DE9BF2B787351FA2E2F4FC9DF24F19FBDD4395BB2CC0A645FC2E9749DEA34A09FB58378D758E0A9903E2642F10FC464F5AF8D7A6AC41B31065A6D0CF2EE9FD1B047C5B40B24C76848C3568C3ACE24E3C48C5796E7CC585D4587CA5D4F3FC17F6C45C71426E4867DDA80A10D26E79E95DA2437DC72A428193B728B51A9D77914C7C5437C6CFD1B3"
    su - streaming -c "/opt/soft/streaming/bin/update_enterprise_code.sh wByeDrLc 1"
    su - streaming -c "/opt/soft/streaming/bin/update_enterprise_name.sh 1 Argo"

    ##初始化数据
    echo -e "${c_yellow}开始初始化数据,请耐心等待${c_end}"
    su - streaming -c "/opt/soft/streaming/bin/init_data_entrance_url.sh http://${IP_out}:8089"

    ##初始化指标监控地址
    echo -e "${c_yellow}开始初始化指标监控地址,请耐心等待${c_end}"
    su - streaming -c "/opt/soft/streaming/bin/init_monitor_list_url.sh ${IP_out}/view/sign/index.html?referrer=${IP_out}%2Fproject-management%2Fmonitoring%3FmonitorTab%3D1%26projectType%3D{{appkey}}#/"


    echo -e "${c_yellow}安装nmon工具${c_end}"
    #安装nmon工具
    #yum -y install  nmon

    echo -e "${c_yellow}安装全部完成，感谢耐心等待。${c_end}"

    echo -e "${c_yellow}恭喜您，安装成功！${c_end}"
    echo -e "${c_yellow}方舟访问地址 http://${IP_out}:4005 账号admin 密码 111111${c_end}"
    echo -e "${c_yellow}ambari管理地址 http://${IP_out}:8080 账号 admin 密码 admin${c_end}"
    echo -e "${c_yellow}sdk上报地址 http://${IP_out}:8089${c_end}"

    echo -e "${c_yellow}使用方法请参考官方说明。${c_end}"


elif [ ""$argo_action == "upgrade" ];then
    echo "暂不支持！"
    exit 1
fi