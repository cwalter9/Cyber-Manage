#!/bin/bash
source includes/main.inc

iprescant=`echo "select varint from configs where varname='scn-iprescan'" | $DBQ`
netrescant=`echo "select varint from configs where varname='scn-netrescan'" | $DBQ`
addraddcount=`echo "select varint from configs where varname='scn-addcnt'" | $DBQ`

function dbevent () {
  echo "insert into scn_events set ipid='$1',pstat='$2'" | $DBQ
}

loopc=0
function addaddr () {
# newip=`echo 10.1.$((RANDOM%256)).$((RANDOM%256))`
 newip=`echo $1.$((RANDOM%256))`
 ipid=`echo "select id from scn_address where ipaddr='$newip'" | $DBQ`
 if [ -z $ipid ]; then
   echo "insert into scn_address set ipaddr='$newip'" | $DBQ
   ipid=`echo "select id from scn_address where ipaddr='$newip'" | $DBQ`
   dbevent $ipid 0
 fi
}

while [ $loopc -le $addraddcount ] ; do
  for i in `echo "select subnet from vw_scn_netstoproc" | $DBQ`; do
    addaddr $i
  done
  loopc=`echo $loopc+1 | bc`
done

# Scan and process addresses with status of 0

dnow=`date +%s`
for i in `echo "select id from scn_address where status='0'" | $DBQ`; do
  ipaddr=`echo "select ipaddr from scn_address where id='$i'" | $DBQ`
  ping -c 1 -w 1 $ipaddr > /dev/null
  status="$?"
  if [ $status = 1 ]; then
    echo "update scn_address set status='2',lastcheck='$dnow' where id='$i'" | $DBQ
    dbevent $i 2
  elif [ $status = 0 ]; then
    echo "update scn_address set status='1',lastcheck='$dnow' where id='$i'" | $DBQ
    dbevent $i 1
  fi
done

# Scan for and process addresses that are older than iprescant seconds

ctime=`echo $dnow-$iprescant | bc`
currmin=`date +%M`
for i in `echo "select id from scn_address where status!='0'" | $DBQ`; do
  dnow=`date +%s`
  if [ $currmin -lt 30 ]; then
    hstat=`echo "select status from scn_address where id='$i'" | $DBQ`
    if [ $hstat -eq 2 ]; then
      ctime='1'
    fi
  fi
  stime=`echo "select lastcheck from scn_address where id='$i'" | $DBQ`
  if [ $ctime -gt $stime ]; then
    ipaddr=`echo "select ipaddr from scn_address where id='$i'" | $DBQ`
    ping -c 1 -w 1 $ipaddr > /dev/null
    status="$?"
    cstatus=`echo "select status from scn_address where id='$i'" | $DBQ`
    dnow=`date +%s`
    if [ $status = 1 ]; then
      echo "update scn_address set status='2',lastcheck='$dnow' where id='$i'" | $DBQ
      if [ $cstatus -eq 1 ]; then
        dbevent $i 2
## Alert goes here for change from good to bad IP
        ahname=`echo "select hostname from scn_address where id='$i'" | $DBQ`
        setalert 1 "$ahname changed to unavailable"
      fi
    elif [ $status = 0 ]; then
      echo "update scn_address set status='1',lastcheck='$dnow' where id='$i'" | $DBQ
      if [ $cstatus -eq 2 ]; then
        dbevent $i 1
      fi
    fi
  fi
  ctime=`echo $dnow-$iprescant | bc`
done

# Count addresses for each subnet and update subnet count

for i in `echo "select subnet from scn_networks" | $DBQ`; do
  dnow=`date +%s`
  nctime=`echo $dnow-$netrescant | bc`
  lcheck=`echo "select lastcheck from scn_networks where subnet='$i'" | $DBQ`
  if [ $nctime -gt $lcheck ]; then
    addrcount=`echo "select count(*) from scn_address where ipaddr like '$i.%'" | $DBQ`
    dnow=`date +%s`
    echo "update scn_networks set addrcount='$addrcount',lastcheck='$dnow' where subnet='$i'" | $DBQ
  fi
done
