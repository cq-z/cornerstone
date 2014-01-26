#!/bin/bash
#����PHP�Ļ�������������
#����tcl8.5
tar zxvf tcl8.5.12-src.tar.gz
cd tcl8.5.12/unix
./configure --prefix=/usr/local/tcl8.5
make && make install
cp /usr/local/tcl8.5/bin/tclsh8.5 /usr/bin/

#��ѹ
tar xzvf redis-2.6.13.tar.gz
cd redis-2.6.13
make
make test
make install

#�����ű�
mkdir /etc/redis
cp redis-2.6.13/redis.conf /etc/redis

#�����ػ�����
cat $cur_dir/redis > /etc/init.d/redis


#���ÿ�������
chmod +x /etc/init.d/redis
chkconfig redis on

#����redis����
service redis restart

#redis.so�ͻ�����ʱ����

#��װphpredisģ��
tar xzvf phpredis-2.2.2-84-g6d244bb.tar.gz
cd nicolasff-phpredis-6d244bb/
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install

#�޸�php.ini�ļ������redis.so
cat >> /usr/local/php/etc/php.ini << "EOF"

[redis]
extension=redis.so
EOF

#����php-fpm
service php-fpm restart 












