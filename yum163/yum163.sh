#!/bin/bash
#更新YUM源为163.com
yum -y install gcc make wget cmake vim vixie-cron ntpdat
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -O /etc/yum.repos.d/CentOS-Base.repo
yum clean all
yum makecache