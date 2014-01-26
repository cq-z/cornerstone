#!/bin/bash

#��ȡ��ǰ·��
cur_dir=$(pwd)

#��װlibevent
#��������Ŀ¼
if [ -d $1"/soft/libevent-1.2" ];then 
   cd $1/soft/libevent-1.2
else
   cd $1/soft
   tar zxvf libevent-1.2.tar.gz 
   cd $1/soft/libevent-1.2
fi
./configure --prefix=/usr
make && make install
#���64λϵͳ
ln -s $2/libevent-1.2.so.1 /usr/lib64/


#��װmemcached��ͬʱ��Ҫ��װ��ָ��libevent�İ�װλ��
#��������Ŀ¼
if [ -d $1"/soft/memcached-1.2.0" ];then 
   cd $1/soft/memcached-1.2.0
else
   cd $1/soft
   tar zxvf memcached-1.2.0.tar.gz
   cd $1/soft/memcached-1.2.0
fi
./configure --with-libevent=/usr 
make && make install

#��װMemcache��PHP��չ 
#��������Ŀ¼
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

#���óɿ�������
cat $cur_dir/memcache > /etc/init.d/memcache
chmod +x /etc/init.d/memcache
chkconfig --level 3 memcache on

#�޸�php.ini�ļ�
cat >> $2/php/etc/php.ini << "EOF"

[memcached]
extension=memcache.so
EOF

#����PHP����
service php-fpm restart
service memcache restart
