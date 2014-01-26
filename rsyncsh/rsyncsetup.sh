#同步服务的目的终端配置
yum -y install telnet xinetd rsync

#配置/etc/xinetd.d/rsync
cat > /etc/xinetd.d/rsync << "EOF"
# default: off
# description: The rsync server is a good addition to an ftp server, as it \
#       allows crc checksumming etc.
service rsync
{
        disable = no
        flags           = IPv6
        socket_type     = stream
        wait            = no
        user            = root
        server          = /usr/bin/rsync
        server_args     = --daemon
        log_on_failure  += USERID
}
EOF

#配置服务端的conf
cat > /etc/rsyncd.conf << "EOF"
uid = root
gid = root
use chroot = no
max connections = 100
timeout = 600
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsyncd.lock
log file = /var/log/rsyncd.log

[up]
path = /data/www/
ignore errors
read only = no
list = true
#hosts allow = 110.80.17.242
auth users = root
secrets file = /etc/update.pwd
EOF

#设置服务端的访问密码，用户必须是auth users
echo "root:pbawebbak2012" >  /etc/update.pwd

#服务端密码文件必须指定属主和权限，必须是600
chown root:root /etc/update.pwd
chmod 600 /etc/update.pwd


#重启相应服务
service xinetd restart








