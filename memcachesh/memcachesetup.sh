#!/bin/bash

#获取当前路径
cur_dir=$(pwd)

#安装libevent
#进入下载目录
if [ -d $1"/soft/libevent-1.2" ];then 
   cd $1/soft/libevent-1.2
else
   cd $1/soft
   tar zxvf libevent-1.2.tar.gz 
   cd $1/soft/libevent-1.2
fi
./configure --prefix=/usr
make && make install
#针对64位系统
ln -s $2/libevent-1.2.so.1 /usr/lib64/


#安装memcached，同时需要安装中指定libevent的安装位置
#进入下载目录
if [ -d $1"/soft/memcached-1.2.0" ];then 
   cd $1/soft/memcached-1.2.0
else
   cd $1/soft
   tar zxvf memcached-1.2.0.tar.gz
   cd $1/soft/memcached-1.2.0
fi
./configure --with-libevent=/usr 
make && make install

#安装Memcache的PHP扩展 
#进入下载目录
if [ -d $1"/soft/memcache-2.2.1 " ];then 
   cd $1/soft/memcache-2.2.1 
else
   cd $1/soft
   tar zxvf memcache-2.2.1.tgz 
   cd $1/soft/memcache-2.2.1 
fi
$2/php/bin/phpize 
./configure --enable-memcache --with-php-config=$2/php/bin/php-config --with-zlib-dir 
make && make install

#设置成开机启动
cat $cur_dir/memcache > /etc/init.d/memcache
chmod +x /etc/init.d/memcache
chkconfig --level 3 memcache on

#修改php.ini文件
cat >> $2/php/etc/php.ini << "EOF"

[memcached]
extension=memcache.so
EOF

#重启PHP服务
service php-fpm restart
service memcache restart
