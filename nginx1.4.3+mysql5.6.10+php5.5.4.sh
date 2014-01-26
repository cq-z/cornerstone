#开始安装，指定安装目录
cd ~
mkdir webserver
cd webserver
cur_dir=$(pwd)

yum -y install gcc gcc-c++ autoconf e4fsprogs libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers ImageMagick-devel patch libaio gd-devel

#创建WEB目录
mkdir -p /data/http
groupadd www
useradd www -g www -d /data/http -p wwwmima
mkdir -p /data/logs
cat >>/etc/rc.local<<EOF
ulimit -SHn 65535
EOF

#安装pcre库
#wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.32.tar.gz
wget http://webserver.jongates.org/pcre-8.32.tar.gz
tar zxvf pcre-8.32.tar.gz
cd pcre-8.32
./configure --prefix=/usr/local/webserver/pcre
make && make install
cd ../

#安装nginx
#wget http://nginx.org/download/nginx-1.4.3.tar.gz
wget http://webserver.jongates.org/nginx-1.4.3.tar.gz
tar zxvf nginx-1.4.3.tar.gz
cd nginx-1.4.3
./configure --user=www --group=www --prefix=/usr/local/webserver/nginx --with-http_stub_status_module --with-http_ssl_module --with-pcre=/root/webserver/pcre-8.32 --with-http_realip_module --with-http_image_filter_module
make
make install
cd ../
#启动/usr/local/webserver/nginx/sbin/nginx
/usr/local/webserver/nginx/sbin/nginx
#nginx重启脚本
echo '/usr/local/webserver/nginx/sbin/nginx -t
kill -HUP `cat /usr/local/webserver/nginx/logs/nginx.pid`
' > /root/nginx.sh
chmod +x /root/nginx.sh

#安装mysql================

#下载解压
#wget http://downloads.mysql.com/archives/mysql-5.6/mysql-5.6.10-linux-glibc2.5-x86_64.tar.gz
wget http://webserver.jongates.org/mysql-5.6.10-linux-glibc2.5-x86_64.tar.gz
tar vxf mysql-5.6.10-linux-glibc2.5-x86_64.tar.gz
mv mysql-5.6.10-linux-glibc2.5-x86_64 /usr/local/webserver/mysql
#数据目录
mkdir -pv /data/mysql/data
groupadd -r mysql
useradd -g mysql -r -s /bin/false -M -d /data/mysql mysql
#安装
/usr/local/webserver/mysql/scripts/mysql_install_db --basedir=/usr/local/webserver/mysql --datadir=/data/mysql/data --user=mysql
#配置
cat >>/usr/local/webserver/mysql/my.cnf<<EOF
basedir = /usr/local/webserver/mysql
datadir = /data/mysql/data
port = 3306
socket = /tmp/mysql.sock
pid_file = /var/run/mysqld.pid
EOF
#修改启动文件中的值
sed -i "s#basedir=#basedir=/usr/local/webserver/mysql#" /usr/local/webserver/mysql/support-files/mysql.server
#启动
/usr/local/webserver/mysql/support-files/mysql.server start
#mysql加入环境
cat >>/etc/ld.so.conf<<EOF
/usr/local/webserver/mysql/lib
EOF
ldconfig
#加入开机启动
cat >>/etc/rc.local<<EOF
/usr/local/webserver/mysql/support-files/mysql.server start
EOF


#安装所需库
mkdir -p /usr/local/webserver/libs
#wget http://www.ijg.org/files/jpegsrc.v9.tar.gz 
wget http://webserver.jongates.org/jpegsrc.v9.tar.gz     
tar zxvf jpegsrc.v9.tar.gz
cd jpeg-9/
./configure --prefix=/usr/local/webserver/libs --enable-shared --enable-static
make
make install
cd ../

#wget http://prdownloads.sourceforge.net/libpng/libpng-1.6.2.tar.gz
wget http://webserver.jongates.org/libpng-1.6.2.tar.gz
tar zxvf libpng-1.6.2.tar.gz
cd libpng-1.6.2/
./configure --prefix=/usr/local/webserver/libs
make
make install
cd ../

#wget http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.gz
wget http://webserver.jongates.org/freetype-2.4.12.tar.gz
tar zxvf freetype-2.4.12.tar.gz
cd freetype-2.4.12/
./configure --prefix=/usr/local/webserver/libs
make
make install
cd ../

#wget "http://downloads.sourceforge.net/mcrypt/libmcrypt-2.5.8.tar.gz?big_mirror=0"
wget http://webserver.jongates.org/libmcrypt-2.5.8.tar.gz
tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8/
./configure --prefix=/usr/local/webserver/libs
make
make install
cd libltdl/
./configure --prefix=/usr/local/webserver/libs --enable-ltdl-install
make
make install
cd ../../

#wget "http://downloads.sourceforge.net/mhash/mhash-0.9.9.9.tar.gz?big_mirror=0"
wget http://webserver.jongates.org/mhash-0.9.9.9.tar.gz
tar zxvf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9/
./configure --prefix=/usr/local/webserver/libs
make
make install
cd ../

#类库加入环境
cat >>/etc/ld.so.conf<<EOF
/usr/local/webserver/libs/lib
EOF
ldconfig

#wget "http://downloads.sourceforge.net/mcrypt/mcrypt-2.6.8.tar.gz?big_mirror=0"
wget http://webserver.jongates.org/mcrypt-2.6.8.tar.gz
tar zxvf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8/
export LDFLAGS="-L/usr/local/webserver/libs/lib -L/usr/lib"
export CFLAGS="-I/usr/local/webserver/libs/include -I/usr/include"
touch malloc.h
./configure --prefix=/usr/local/webserver/libs --with-libmcrypt-prefix=/usr/local/webserver/libs
make
make install
cd ../



#编译安装PHP
wget http://cn2.php.net/get/php-5.5.6.tar.gz/from/this/mirror
tar zxvf php-5.5.6.tar.gz
cd php-5.5.6/
export LIBS="-lm -ltermcap -lresolv"
export DYLD_LIBRARY_PATH="/usr/local/webserver/mysql/lib/:/lib/:/usr/lib/:/usr/local/lib:/lib64/:/usr/lib64/:/usr/local/lib64"
export LD_LIBRARY_PATH="/usr/local/webserver/mysql/lib/:/lib/:/usr/lib/:/usr/local/lib:/lib64/:/usr/lib64/:/usr/local/lib64"
./configure --prefix=/usr/local/webserver/php --with-config-file-path=/usr/local/webserver/php/etc --with-mysql=/usr/local/webserver/mysql --with-mysqli=/usr/local/webserver/mysql/bin/mysql_config --with-iconv-dir --with-freetype-dir=/usr/local/webserver/libs --with-jpeg-dir=/usr/local/webserver/libs --with-png-dir=/usr/local/webserver/libs --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt=/usr/local/webserver/libs --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --enable-opcache --with-pdo-mysql --disable-fileinfo
make
make install
cp php.ini-development /usr/local/webserver/php/etc/php.ini
cd ../


#php重启脚本
echo 'kill -USR2 `cat /usr/local/webserver/php/var/run/php-fpm.pid`
' > /root/php.sh
chmod +x /root/php.sh

#其他
ln -s /usr/local/webserver/mysql/lib/libmysqlclient.18.dylib /usr/lib/libmysqlclient.18.dylib
cp /usr/local/webserver/php/etc/php-fpm.conf.default /usr/local/webserver/php/etc/php-fpm.conf
sed -i "s#;pid = run/php-fpm.pid#pid = run/php-fpm.pid#g" /usr/local/webserver/php/etc/php-fpm.conf
sed -i "s#user = nobody#user = www#g" /usr/local/webserver/php/etc/php-fpm.conf
sed -i "s#group = nobody#group = www#g" /usr/local/webserver/php/etc/php-fpm.conf
sed -i "s#;error_log = log/php-fpm.log#error_log = /data/logs/php-fpm.log#g" /usr/local/webserver/php/etc/php-fpm.conf


#创建nginx.conf文件：
rm -f /usr/local/webserver/nginx/conf/nginx.conf
echo '
#作为守护进程运行 Nginx
#daemon on;
user www www;
#工作进程数
worker_processes 8;
#保存进程id号
pid    logs/nginx.pid;
#加大 Nginx 所能操作的文件句柄数
worker_rlimit_nofile 65535;
events {
    use epoll;
    #每线程最多可接受的连接数，worker_processes * worker_connections
    worker_connections 65535;
}
http {
    include mime.types;
    default_type application/octet-stream;
    #charset gb2312;
    #系统错误日志
    error_log /data/logs/nginx_error.log  crit;
    server_names_hash_bucket_size 128;
    client_header_buffer_size 32k;
    large_client_header_buffers 4 32k;
    client_max_body_size 8m;      
    #文件传输处理方式，sendfile 性能低，关闭；  
    sendfile on;
    #Linux 内核 tcp_nopush TCP 函数调用，关闭；
    tcp_nopush on;
    #Linux & FreeBSD 内核 TCP 函数调用，开启；
    tcp_nodelay on;  
    #每个链接保存的时长(单位：秒)
    keepalive_timeout 60;
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;
    gzip on;
    gzip_min_length 1k;
    gzip_buffers 4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types text/plain text/css application/xml;#application/x-javascript;
    gzip_vary on;
    #limit_zone crawler $binary_remote_addr 16m;
    #limit_conn crawler 16;
    
    server{
        listen       80;
        server_name  localhost;
        index index.html index.htm index.php;
        root /data/http;
        
        if (!-f $request_filename) {
            rewrite "^/(.*).html(.*)" /$1.php$2 last;
            break;
        }
        location ~ .*\.(php|php5)?$ {
            fastcgi_pass  127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi.conf;
        }
        location ~ .*\.(js|css|gif|jpg|jpeg|png|bmp|swf)$ {
            expires      30d;
        }
        location /status {
            stub_status on;
            access_log   off;
        }
    }
}
' >>/usr/local/webserver/nginx/conf/nginx.conf


#php测试页
cat >>/data/http/php.php<<EOF
<?php
phpinfo();
?>
EOF

#加入开机启动
cat >>/etc/rc.local<<EOF
/usr/local/webserver/php/sbin/php-fpm
/usr/local/webserver/nginx/sbin/nginx
EOF

#优化Linux内核参数
cat >>/etc/sysctl.conf<<EOF
ulimit -SHn 65535
net.ipv4.tcp_max_syn_backlog = 65536
net.core.netdev_max_backlog =  32768
net.core.somaxconn = 32768

net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2

net.ipv4.tcp_tw_recycle = 1
#net.ipv4.tcp_tw_len = 1
net.ipv4.tcp_tw_reuse = 1

net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800

#net.ipv4.tcp_fin_timeout = 30
#net.ipv4.tcp_keepalive_time = 120
net.ipv4.ip_local_port_range = 1024  65535
EOF

#使配置立即生效：
/sbin/sysctl -p


#==============


#手动添加MYSQL管理员
#/usr/local/webserver/mysql/bin/mysql -u root -p -S /tmp/mysql.sock
#GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '111111';
#GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY '111111';
#exit

