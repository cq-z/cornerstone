#!/bin/bash
#基于64位最小化版Centos 6.2安装
#必须先配置好网络
#拷贝当前目录的所有文件到服务器上
#直接在当前目录运行
#由于中文会产生乱码，该脚本尽量另外复制到服务器

#脚本存放路径
LNMP_dir=/data/LNMP
#软件安装路径
install_dir=/usr/local
#数据存放地址
data_dir=/data

#输出提示框
echo "###########################################"
echo "手动安装LNMP环境请安装Nginx->Mysql->PHP顺序安装"
echo "0、更新YUM源为163.com"
echo "1、仅安装Nginx"
echo "2、仅安装Mysql"
echo "3、仅安装PHP"
echo "4、安全优化设置"
echo "99、需手动步骤的说明"

echo "###########################################"
echo " "
echo "请输入要选择项目的数字:"
read num
echo "您所选的项目是$num"

#条件分支
case $num in
	0)
	chmod +x $LNMP_dir/yum163/yum163.sh
	cd $LNMP_dir/yum163
	./yum163.sh
	echo "更新YUM源为163.com完成"
	;;

	1)
	chmod +x $LNMP_dir/nginxsh/nginxsetup.sh
	cd $LNMP_dir/nginxsh
	./nginxsetup.sh $LNMP_dir $install_dir $data_dir
	echo "Nginx安装完成"
	;;

	2)
	chmod +x $LNMP_dir/mysqlsh/mysqlsetup.sh
	cd $LNMP_dir/mysqlsh
	./mysqlsetup.sh $LNMP_dir $install_dir $data_dir
	echo "Mysql安装完成"
	;;

	3)
	chmod +x $LNMP_dir/phpsh/phpsetup.sh
	cd $LNMP_dir/phpsh
	./phpsetup.sh $LNMP_dir $install_dir $data_dir
	echo "PHP安装完成"
	;;

	4)
	chmod +x $LNMP_dir/advancesh/advance.sh
	chmod +x $LNMP_dir/advancesh/advance.sh
	cd $LNMP_dir/advancesh
	./advance.sh
	echo "安全优化设置完成"
	;;

	
	99)
	echo "###########################################################################"
	echo "脚本配置完后，仍需根据实际情况手动配置站点信息，具体如下："
	echo "1、ftp账号和密码，添加用户、密码，详见命令范例"
	echo "   cd /usr/local/pureftpd/bin/"
	echo "   ./pure-pw useradd testuser -u webuser -d /data/www/test/"
	echo "   ./pure-pw mkdb"
	echo "2、手动清理MYSQL空密码空用户名的账户，删除ROOT用户，根据需要建立数据库"
	echo "   /usr/local/mysql/bin/mysql -u root -p"
	echo "   GRANT ALL PRIVILEGES ON *.* TO pba@"localhost" IDENTIFIED BY '123456' WITH GRANT OPTION;"
	echo "   flush privileges;"
	echo "   delete from user where user='root' or user='';"
	echo "									"
	echo "###########################################################################"
	;;
esac


