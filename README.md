LNMP安装脚本
（如有需要替换软件版本直接替换soft文件夹下的tar.gz格式源码包或是文件夹，注意:确保解压后路径不带版本号，例如php解压后的文件夹名称就是php） 
版本信息：  
nginx 1.6.0				http://nginx.org/en/download.html  
  
  
php 5.5.14	 			http://cn2.php.net/downloads.php  
	--php扩展			http://pecl.php.net/packages.php   
                  libjpeg:v9a		http://www.ijg.org/  
		  libiconv:1.14		http://www.gnu.org/software/libiconv/#downloading  
		  GD2:2.1.0		http://libgd.bitbucket.org/  
		  LibXML2:2.7.2		http://xmlsoft.org/downloads.html  
		  LibMcrypt:2.5.7	http://mcrypt.hellug.gr/#_libmcrypt  
		  mcrypt:2.6.4		http://mcrypt.hellug.gr/#_mcrypt  
		  PCRE:8.34		http://www.pcre.org/  
		  mhash:0.9.9.9		http://mhash.sourceforge.net/  
  
mysql 5.6.15				http://dev.mysql.com/downloads/mysql/  
APC 3.1.13  
  
  
系统目录  
全部软件全部安装到/data目录  
  
优化方向：  
LINUX用noexec,nodev,nosuid挂载独立分区用于chroot目录运行Nginx  