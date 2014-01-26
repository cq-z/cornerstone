#!/bin/bash
#MYSQL安装(源码编译安装)，基于Centos 6 64位
#将该脚本及相应的配置文件放至服务器执行即可
#安装环境
yum -y install bison gcc gcc-c++  autoconf automake zlib* libxml* ncurses-devel libtool-ltdl-devel* make cmake
echo "已完成环境更新"

#获取当前路径
cur_dir=$(pwd)





#设置系统用户
/usr/sbin/groupadd mysql
/usr/sbin/useradd -g mysql mysql

#建立数据存放目录，mysql程序则安装在 /usr/local/mysql 目录中
mkdir $3/mysql
chown -R mysql:mysql $3/mysql

#进入下载目录
if [ -d $1"/soft/mysql" ];then 
   cd $1/soft/mysql
else
   cd $1/soft
   #解压mysql安装包
   tar zxvf mysql.tar.gz
   cd $1/soft/mysql
fi
#编译安装MYSQL
cmake . -DCMAKE_INSTALL_PREFIX=$2/mysql -DMYSQL_DATADIR=$3/mysql -DSYSCONFDIR=/etc/
make && make install

#编辑/etc/my.cnf
cat $cur_dir/my.cnf > /etc/my.cnf

#建立数据库，64位系统必须指定目录
$2/mysql/scripts/mysql_install_db --user=mysql --basedir=$2/mysql --datadir=$3/mysql

#配置服务脚本
cat $cur_dir/mysqld > /etc/rc.d/init.d/mysqld
chmod 755 /etc/rc.d/init.d/mysqld
chkconfig --add mysqld
chkconfig --level 3 mysqld on

#启动服务，后续还需设置密码和安全优化，待处理
service mysqld start
$1/LNMP.sh







