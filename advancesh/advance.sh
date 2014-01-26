#!/bin/bash
#基于《centos6.2基本安装》的安全和优化脚本
#该脚本需LNMP和ssh的配置完成后，再实施
#网卡IP、网关、DNS和静态路由需手动配置


#基本组件&工具
yum -y install gcc make wget cmake vim vixie-cron ntpdate

#凌晨4时进行时间同步
echo "* 4 * * * /usr/sbin/ntpdate 210.72.145.44 > /dev/null 2>&1" >> /var/spool/cron/root

#优化Linux的内核参数
str=`cat <<EOF
net.core.netdev_max_backlog =  32768
net.core.somaxconn = 32768
net.core.rmem_default=36700160
net.core.wmem_default=36700160
net.core.rmem_max=36700160
net.core.wmem_max=36700160
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_wmem = 8192 8388608 33554432
net.ipv4.tcp_rmem  = 32768 8388608 33554432
net.ipv4.tcp_max_orphans = 3276800 
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_max_tw_buckets = 65535
net.ipv4.ip_local_port_range = 1024  65535 
EOF
`
echo "$str">> /etc/sysctl.conf
/sbin/sysctl -p

#防火墙配置
str=`cat <<EOF
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 51722 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -s 192.168.1.0-255 -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 12000 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 873 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOF
`
echo "$str"> /etc/sysconfig/iptables

#重启防火墙配置
service iptables restart










