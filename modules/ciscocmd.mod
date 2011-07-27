#!/bin/bash

# ccmdexec='ciscocmd -u ciscocmd -p ciscocmd -t 10.2.128.125 -c "sh ver"'

ccmduser='ciscocmd'
ccmdpass='ciscocmd'
ccmd='ciscocmd -u $ccmduser -p $ccmdpass'

for i in `echo "select id from ccmd_hosts" | $DBQ`; do
  ipaddr=`echo "select ipaddr from ccmd_hosts where id='$i'" | $DBQ`
  cpu5sec=`ciscocmd -u $ccmduser -p $ccmdpass -t $ipaddr -c "sh proc" | grep CPU | gawk '{ print $6 }' | gawk -F\% '{ print $1 }'`
  cpu1min=`ciscocmd -u $ccmduser -p $ccmdpass -t $ipaddr -c "sh proc" | grep CPU | gawk '{ print $9 }' | gawk -F\% '{ print $1 }'`
  cpu5min=`ciscocmd -u $ccmduser -p $ccmdpass -t $ipaddr -c "sh proc" | grep CPU | gawk '{ print $12 }' | gawk -F\% '{ print $1 }'`
  cdate=`date +%s`
  echo "update ccmd_hosts set lastchecked='$cdate'" | $DBQ
  echo "insert into ccmd_cpustats set hostid='$i',cpu5sec='$cpu5sec',cpu1min='$cpu1min',cpu5min='$cpu5min'" | $DBQ
done



