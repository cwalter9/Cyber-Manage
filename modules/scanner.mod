#!/bin/bash
source includes/main.inc

rescant='600'

loopc=0
function addaddr () {
# newip=`echo 10.1.$((RANDOM%256)).$((RANDOM%256))`
 newip=`echo 10.1.1.$((RANDOM%256))`
 newip=`echo 10.2.128.$((RANDOM%256))`
 ipid=`echo "select id from scn_address where ipaddr='$newip'" | $DBQ`
 if [ -z $ipid ]; then
   echo "insert into scn_address set ipaddr='$newip'" | $DBQ
 fi
}

while [ $loopc -le 10 ] ; do
  addaddr
  loopc=`echo $loopc+1 | bc`
done

# Scan and process addresses with status of 0

for i in `echo "select id from scn_address where status='0'" | $DBQ`; do
  ipaddr=`echo "select ipaddr from scn_address where id='$i'" | $DBQ`
  ping -c 1 -w 1 $ipaddr > /dev/null
  status="$?"
  dnow=`date +%s`
  if [ $status = 1 ]; then
    echo "update scn_address set status='2',lastcheck='$dnow' where id='$i'" | $DBQ
  elif [ $status = 0 ]; then
    echo "update scn_address set status='1',lastcheck='$dnow' where id='$i'" | $DBQ
  fi
done

# Scan for and process addresses that are older that rescant seconds

dnow=`date +%s`
ctime=`echo $dnow-$rescant | bc`
for i in `echo "select id from scn_address where status!='0'" | $DBQ`; do
  stime=`echo "select lastcheck from scn_address where id='$i'" | $DBQ`
  if [ $ctime -gt $stime ]; then
    ipaddr=`echo "select ipaddr from scn_address where id='$i'" | $DBQ`
    ping -c 1 -w 1 $ipaddr > /dev/null
    status="$?"
    dnow=`date +%s`
    if [ $status = 1 ]; then
      echo "update scn_address set status='2',lastcheck='$dnow' where id='$i'" | $DBQ
    elif [ $status = 0 ]; then
      echo "update scn_address set status='1',lastcheck='$dnow' where id='$i'" | $DBQ
    fi
  fi
done
