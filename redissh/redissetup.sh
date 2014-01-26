#!/bin/bash
#基于PHP的基础环境已配置
#配置tcl8.5
tar zxvf tcl8.5.12-src.tar.gz
cd tcl8.5.12/unix
./configure --prefix=/usr/local/tcl8.5
make && make install
cp /usr/local/tcl8.5/bin/tclsh8.5 /usr/bin/

#解压
tar xzvf redis-2.6.13.tar.gz
cd redis-2.6.13
make
make test
make install

#启动脚本
mkdir /etc/redis
cp redis-2.6.13/redis.conf /etc/redis

#建立守护进程
cat $cur_dir/redis > /etc/init.d/redis


#设置开机启动
chmod +x /etc/init.d/redis
chkconfig redis on

#启动redis服务
service redis restart

#redis.so客户端暂时不用

#安装phpredis模块
tar xzvf phpredis-2.2.2-84-g6d244bb.tar.gz
cd nicolasff-phpredis-6d244bb/
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install

#修改php.ini文件，添加redis.so
cat >> /usr/local/php/etc/php.ini << "EOF"

[redis]
extension=redis.so
EOF

#重启php-fpm
service php-fpm restart 












