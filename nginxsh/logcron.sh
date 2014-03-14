#!/bin/bash
# This script run at 00:00

# The Nginx logs path
log_dir="/data/logs"

#The path for Nginx logs path by cuted
date=`date -d "yesterday" +"%Y%m%d"`

remove=30

ls ${log_dir}> filename
for file in `cat filename`
do
if [ -d $file ]
then
  if [ -s ${log_dir}/$file/access.log ]
  then
    /bin/mv  ${log_dir}/$file/access.log ${log_dir}/$file/access${date}.log
  fi
  if [ -s ${log_dir}/$file/error.log ]
  then
    /bin/mv  ${log_dir}/$file/error.log ${log_dir}/$file/error${date}.log
  fi
fi
done
find /data/logs/ -name '*.log'  -mtime +${remove} | xargs rm -f

#Reopen Nginx logs file
kill -USR1 `cat  /usr/local/nginx/var/nginx.pid`f
