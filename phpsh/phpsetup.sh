#!/bin/bash
#PHP5.3安装，基于Centos 6.2 64位
#将该脚本及相应的配置文件放至服务器执行即可

#安装组件
yum -y install gcc-c++ bzip2 bzip2-devel libpng-devel libtiff-devel freetype-devel zlib zlib-devel libtool  gcc make
yum -y install autoconf e4fsprogs libjpeg  libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel  openldap-clients openldap-servers ImageMagick-devel patch libaio gd-devel

#获取当前路径
cur_dir=$(pwd)




#编译安装libjpeg
#进入下载目录
if [ -d $1"/soft/jpeg" ];then 
   cd $1/soft/jpeg
else
   cd $1/soft
   tar xzvf jpeg.tar.gz
   cd $1/soft/jpeg
fi
mkdir $2/jpeg
mkdir $2/jpeg/include/
mkdir $2/jpeg/lib
mkdir $2/jpeg/bin
mkdir $2/jpeg/man
mkdir $2/jpeg/man/man1
\cp /usr/share/libtool/config/config.sub .
\cp /usr/share/libtool/config/config.guess .
./configure --prefix=$2/jpeg --enable-shared  --enable-static
make && make install


#编译安装libiconv
#进入下载目录
if [ -d $1"/soft/libiconv" ];then 
   cd $1/soft/libiconv
else
   cd $1/soft
   tar xzvf libiconv.tar.gz
   cd $1/soft/libiconv
fi
./configure  --prefix=$2/libiconv
make && make install

#编译安装GD2
#进入下载目录
if [ -d $1"/soft/libgd" ];then 
   cd $1/soft/libgd
else
   cd $1/soft
   tar xzvf libgd.tar.gz
   cd $1/soft/libgd
fi
./configure --prefix=$2/gd2 --with-jpeg=$2/jpeg/
make && make install

#编译安装LibXML2
#进入下载目录
if [ -d $1"/soft/libxml2" ];then 
   cd $1/soft/libxml2
else
   cd $1/soft
   tar xzvf libxml2.tar.gz
   cd $1/soft/libxml2
fi
./configure --prefix=$2/libxml2
make && make install


#编译安装PCRE
#进入下载目录
if [ -d $1"/soft/pcre" ];then 
   cd $1/soft/pcre
else
   cd $1/soft
   tar xvzf pcre.tar.gz
   cd $1/soft/pcre
fi
./configure --prefix=$2/pcre
make && make install

#懒人安装 mcrypt
#yum install libmcrypt libmcrypt-devel mcrypt mhash
#编译安装LibMcrypt
#进入下载目录
if [ -d $1"/soft/libmcrypt" ];then 
   cd $1/soft/libmcrypt
else
   cd $1/soft
   tar xzvf libmcrypt.tar.gz
   cd $1/soft/libmcrypt
fi
./configure
make && make install
/sbin/ldconfig

cd libltdl/
./configure --enable-ltdl-install
make && make install

ln -s $2/lib/libiconv.so.2 /usr/lib/libiconv.so.2
ln -s $2/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -s $2/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -s $2/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -s $2/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
ln -s $2/bin/libmcrypt-config /usr/bin/libmcrypt-config
ln -s $2/lib/libmhash.a /usr/lib/libmhash.a
ln -s $2/lib/libmhash.la /usr/lib/libmhash.la
ln -s $2/lib/libmhash.so /usr/lib/libmhash.so
ln -s $2/lib/libmhash.so.2 /usr/lib/libmhash.so.2
ln -s $2/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1


#编译安装mhash
#进入下载目录
if [ -d $1"/soft/mhash" ];then 
   cd $1/soft/mhash
else
   cd $1/soft
   tar zxvf mhash.tar.gz
   cd $1/soft/mhash
fi
./configure
make
make install

ln -s $2/lib/libmhash.a /usr/lib64/libmhash.a  
ln -s $2/lib/libmhash.la /usr/lib64/libmhash.la  
ln -s $2/lib/libmhash.so /usr/lib64/libmhash.so  
ln -s $2/lib/libmhash.so.2 /usr/lib64/libmhash.so.2  
ln -s $2/lib/libmhash.so.2.0.1 /usr/lib64/libmhash.so.2.0.1  


#编译安装mcrypt
#进入下载目录
if [ -d $1"/soft/mcrypt" ];then 
   cd $1/soft/mcrypt
else
   cd $1/soft
   tar zxvf mcrypt.tar.gz
   cd $1/soft/mcrypt
fi
/sbin/ldconfig
./configure
make
make install


#其它组建编译和设置
ln -s /usr/lib64/libpng.so /usr/lib/
yum -y install openldap openldap-devel curl-devel
cp -frp /usr/lib64/libldap* /usr/lib/
ln -s $2/mysql/lib/libmysqlclient.so.18 /usr/lib
ln -s $2/mysql/lib/libmysqlclient.so.18 /usr/lib64



#编译安装PHP
#进入下载目录
if [ -d $1"/soft/php" ];then 
   cd $1/soft/php
else
   cd $1/soft
   tar zxvf php.tar.gz
   cd $1/soft/php
fi
./configure --prefix=$2/php --with-config-file-path=$2/php/etc \
--with-mysql=$2/mysql --with-mysqli=$2/mysql/bin/mysql_config \
--with-iconv-dir=$2/lib --with-freetype-dir=$2/lib --with-jpeg-dir=$2/jpeg --with-png-dir --with-zlib \
--with-libxml-dir=/usr --enable-xml  --enable-safe-mode --enable-bcmath \
--enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers \
--enable-mbregex  --enable-fpm  --enable-mbstring --with-mcrypt --with-gd=$2/gd2/ --enable-gd-native-ttf \
--with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap --with-ldap-sasl --with-xmlrpc \
--enable-zip --enable-soap 
make && make install

#拷贝PHP-FPM配置文件
cat $cur_dir/php-fpm.conf > $2/php/etc/php-fpm.conf

#拷贝PHP.INI配置文件
cat $cur_dir/php.ini > $2/php/etc/php.ini

#拷贝执行脚本到服务目录
cat $cur_dir/php-fpm > /etc/init.d/php-fpm

#修改php-fpm权限
chmod 755 /etc/init.d/php-fpm

#开启php-fpm服务
chkconfig --add php-fpm
chkconfig --level 3 php-fpm on
service php-fpm start

$1/LNMP.sh











