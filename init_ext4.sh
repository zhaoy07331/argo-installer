#!/bin/bash

set -e

#添加新版日志目录和权限
/bin/mkdir -p /opt/soft/log && /bin/chmod -R 777 /opt/soft/log/

#修改history格式
/bin/sed -i '/HISTTIMEFORMAT=/d' /etc/profile;
/bin/echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  `whoami` "' >> /etc/profile
source /etc/profile

/bin/echo LANG="en_US.UTF-8" > /etc/locale.conf

#修改时区
/bin/echo -e "\033[1;33m 修改时区  \033[0m"
/usr/bin/rm /etc/localtime && /usr/bin/ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
date -R | grep +0800

#加入crond

echo '*/15 * * * * root /usr/sbin/ntpdate ark1.analysys.xyz;/sbin/hwclock -w >> /var/log/ntpdate.log 2>&1'   >  /etc/cron.d/fangzhou
echo '30 1 * * * root find /tmp/ -mtime +7 -name "hadoop-unjar*" -exec rm -rf {} \;'   >>  /etc/cron.d/fangzhou
echo '30 1 * * * root find /opt/soft/log/ -mtime +7 -name "*" -type f -exec rm -rf {} \;'   >>  /etc/cron.d/fangzhou
echo '30 1 * * * root find /data/micro-services/ -mtime +7 -name "*.log" -type f -exec rm -rf {} \;'   >>  /etc/cron.d/fangzhou
echo '30 1 * * * root find /data/micro-services/ -mtime +7 -name "*.out" -type f -exec rm -rf {} \;'   >>  /etc/cron.d/fangzhou
echo '30 1 * * * root /bin/cp -rf /var/log/analysys-mysql/mysql.log /var/log/analysys-mysql/bak_mysql.log && echo "backup" > /var/log/analysys-mysql/mysql.log' >> /etc/cron.d/fangzhou
echo '30 1 * * * root /bin/cp -rf /var/log/analysys-mysql/slow.log /var/log/analysys-mysql/bak_slow.log && echo "backup" > /var/log/analysys-mysql/slow.log' >> /etc/cron.d/fangzhou
echo '30 1 * * * root /bin/cp -rf /var/log/ambari-server/ambari-server.log /var/log/ambari-server/bak_ambari-server.log && echo "clean" > /var/log/ambari-server/ambari-server.log' >> /etc/cron.d/fangzhou

#关闭防火墙和selinux
/bin/echo -e "\033[1;33m 关闭防火墙和selinux  \033[0m"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
if [ "`getenforce`" == "Enforcing" ];then
	setenforce 0;
	/bin/echo -e "\033[1;33m  Now is `getenforce` \033[0m";
else
	/bin/echo -e "\033[1;33m selinux is `getenforce` \033[0m";
fi


set +e
systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl stop postfix.service
systemctl disable postfix.service
systemctl stop irqbalance
systemctl disable irqbalance
systemctl enable rc-local.service
systemctl start rc-local.service
set -e


#关闭热键
/bin/rm -rf /usr/lib/systemd/system/ctrl-alt-del.target

#系统优化
/bin/echo -e "\033[1;33m 系统参数调整  \033[0m"
/bin/echo '* soft nofile 100000' > /etc/security/limits.conf
/bin/echo '* hard nofile 100000' >> /etc/security/limits.conf
/bin/echo '* soft nproc 100000' >> /etc/security/limits.conf
/bin/echo '* hard nproc 100000' >> /etc/security/limits.conf

###
/bin/sed -i "s/4096/100000/g" /etc/security/limits.d/20-nproc.conf
/bin/sed -i "s/#DefaultLimitCORE=/DefaultLimitCORE=infinity/g" /etc/systemd/system.conf
/bin/sed -i "s/#DefaultLimitNOFILE=/DefaultLimitNOFILE=100000/g" /etc/systemd/system.conf
/bin/sed -i "s/#DefaultLimitNPROC=/DefaultLimitNPROC=100000/g" /etc/systemd/system.conf
/bin/sed -i "s/#DefaultLimitCORE=/DefaultLimitCORE=infinity/g" /etc/systemd/user.conf
/bin/sed -i "s/#DefaultLimitNOFILE=/DefaultLimitNOFILE=100000/g" /etc/systemd/user.conf
/bin/sed -i "s/#DefaultLimitNPROC=/DefaultLimitNPROC=100000/g" /etc/systemd/user.conf
systemctl daemon-reload
###
sed -i '/session required pam_limits.so/d' /etc/pam.d/login
echo 'session required pam_limits.so' >> /etc/pam.d/login

/bin/echo 'net.ipv4.tcp_sack = 1' > /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_window_scaling = 1' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_timestamps = 0' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_syncookies = 1' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_fin_timeout = 1' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_tw_reuse = 1' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_tw_recycle = 0' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_synack_retries = 1' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_syn_retries = 1' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_keepalive_time = 30' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.ip_local_port_range = 20000 65000' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_max_syn_backlog = 8192' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_max_tw_buckets = 30000' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_max_orphans = 3276800' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_max_syn_backlog = 262144' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_rmem = 4096 87380 4194304' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_wmem = 4096 16384 4194304' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.tcp_mem = 94500000 915000000 927000000' >> /etc/sysctl.conf
/bin/echo 'net.ipv4.icmp_echo_ignore_broadcasts = 1' >> /etc/sysctl.conf
/bin/echo 'net.core.wmem_default = 8388608' >> /etc/sysctl.conf
/bin/echo 'net.core.rmem_default = 8388608' >> /etc/sysctl.conf
/bin/echo 'net.core.rmem_max = 16777216' >> /etc/sysctl.conf
/bin/echo 'net.core.wmem_max = 16777216' >> /etc/sysctl.conf
/bin/echo 'net.core.somaxconn = 16384' >> /etc/sysctl.conf
/bin/echo 'net.core.netdev_max_backlog = 16384' >> /etc/sysctl.conf
/bin/echo 'vm.swappiness = 10' >> /etc/sysctl.conf
/bin/echo 'fs.inotify.max_user_watches = 524288' >> /etc/sysctl.conf
/bin/echo 'fs.inotify.max_user_instances = 256' >> /etc/sysctl.conf
/bin/echo 'fs.inotify.max_queued_events = 32768' >> /etc/sysctl.conf
/bin/echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
/bin/echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf
sysctl -p

df -Th

echo -e "\033[1;33m 初始化完毕，部分配置需要重新登录服务器生效！  \033[0m"

