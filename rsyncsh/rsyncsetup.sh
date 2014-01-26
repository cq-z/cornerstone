#ͬ�������Ŀ���ն�����
yum -y install telnet xinetd rsync

#����/etc/xinetd.d/rsync
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

#���÷���˵�conf
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

#���÷���˵ķ������룬�û�������auth users
echo "root:pbawebbak2012" >  /etc/update.pwd

#����������ļ�����ָ��������Ȩ�ޣ�������600
chown root:root /etc/update.pwd
chmod 600 /etc/update.pwd


#������Ӧ����
service xinetd restart








