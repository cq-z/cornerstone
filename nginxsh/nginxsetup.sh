#!/bin/bash
#nginx安装脚本(动态页面含静态页面)，基于Centos 6 64位
#将该脚本及相应的配置文件放至服务器执行即可
#安装环境
yum -y install zlib-devel pcre-devel openssl openssl-devel
yum -y install gcc make vixie-cron ntpdat
echo "已完成环境更新"

#设置用户
mkdir -p $3/www/test
useradd -d /dev/null -s /sbin/nologin webuser
chown -R webuser $3/www/

#获取当前路径
cur_dir=$(pwd)

#进入下载目录
if [ -d $1"/soft/nginx" ];then 
   cd $1/soft/nginx
else
   cd $1/soft
   #解压nginx安装包
   tar zxvf nginx.tar.gz
   cd $1/soft/nginx
fi

#建立好文件存放目录,测试目录为test
mkdir -p /data/www/test/
mkdir -p /data/logs/test/



#版本信息伪装
sed -i 's/1.0.10/7.5.1.0.10/g;s/"nginx\/" NGINX_VERSION/"Microsoft-IIS\/" NGINX_VERSION/g;s/"NGINX"/"Microsoft-IIS"/g' ./src/core/nginx.h
./configure --prefix=$2/nginx --with-http_stub_status_module --with-http_ssl_module
make && make install

#备份并修改nginx.conf
mv $2/nginx/conf/nginx.conf $2/nginx/conf/nginx.conf.bak

cat $cur_dir/nginx.conf > $2/nginx/conf/nginx.conf

#配置子站信息

cat $cur_dir/webserver.conf > $2/nginx/conf/webserver.conf

#设置日志切割脚本每日切割日志，配置日志切割脚本
mkdir -p $2/nginx/var

cat $cur_dir/logcron.sh > $2/nginx/sbin/logcron.sh

#为 logcron.sh 脚本设置可执行属性
chmod +x $2/nginx/sbin/logcron.sh

#将 logcron.sh 加入定时任务
echo "00 00 * * * /bin/bash  $2/nginx/sbin/logcron.sh" >> /var/spool/cron/root

#设置服务脚本,创建NGINX开机启动脚本

cat $cur_dir/nginx > /etc/init.d/nginx

#为 nginx.sh 脚本设置可执行属性
chmod +x /etc/init.d/nginx

#添加 Nginx 为系统服务（开机自动启动）
chkconfig --add nginx
service nginx restart
chkconfig nginx on

$1/LNMP.sh



