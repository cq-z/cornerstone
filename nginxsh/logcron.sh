#!/bin/bash
# This script run at 00:00

# The Nginx logs path
log_dir="/data/logs"

#The path for Nginx logs path by cuted
date=`date -d "yesterday" +"%Y%m%d"`

#Change logformat as combined and cut Nginx logs
                /bin/mv  ${log_dir}/access.log ${log_dir}/access${date}.log
                /bin/mv  ${log_dir}/$i/error.log ${log_dir}/error${date}.log
for i in test
        do
                /bin/mv  ${log_dir}/$i/access.log ${log_dir}/$i/access${date}.log
                /bin/mv  ${log_dir}/$i/error.log ${log_dir}/$i/error${date}.log
        done

#Reopen Nginx logs file
kill -USR1 `cat  /usr/local/nginx/var/nginx.pid`
#删除60天前的访问日志文�?find /data/logs/*/access*.log -mtime +60 |xargs rm -f
#删除120天前的错误日志文�?find /data/logs/*/error*.log -mtime +120 |xargs rm -f
