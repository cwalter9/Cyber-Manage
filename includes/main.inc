#!/bin/bash

configfile="/etc/cmanage.conf"

# Set DB Username, password and database

dbuser=cmanage
dbpass=cmanagepass
dbname=cmanage
dbtype=mysql

# Set MySQL query
if [ $dbtype = "mysql" ]; then
  DBQ="mysql -u$dbuser -p$dbpass -D$dbname -s"
fi

function getconfvar () {
  more $configfile | grep $1 | gawk -F= '{ print $2 }'
}

loglevel=`getconfvar LogLevel`
export DBQ loglevel

function logmess () {
  if [ "$2" -le "$loglevel" ]; then
    echo "$1"
  fi
}

LogDir=`getconfvar LogDirRoot`
if [ ! -d "$LogDir" ]; then
  logmess "Root log dir missing exiting" "1"
  exit 2
fi

LogDirSub=`getconfvar LogDirSub`
RealLogDir="$LogDir$LogDirSub"
logmess "RealLogDir is $RealLogDir" "10"
if [ ! -d $RealLogDir ]; then
  logmess "Log sub dir missing creating new" "4"
  mkdir $RealLogDir
fi


#LogDirSub=cmanage
#MainLogFile=$LogDir$LogDirSub/cmanage.log
#ModLogFile=$LogDir$LogDirSub/modules.log

