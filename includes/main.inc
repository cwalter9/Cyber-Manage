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

loglevel=`more $configfile | grep LogLevel | gawk -F= '{ print $2 }'`
export DBQ loglevel

function logmess () {
  if [ "$2" -le "$loglevel" ]; then
    echo "$1"
  fi
}

if [ ! -d $LogDir ]; then
  logmess "Root log dir missing exiting" "1"
  exit 2
fi

if [ ! -d $LogDir$LogDirSub ]; then
  logmess "Log sub dir missing creating new" "4"
  mkdir $LogDir$LogDirSub
  if [ ! -d $LogDir$LogDirSub ]; then
    logmess "Log sub dir still missing exiting" "1"
    exit 2
  fi
fi


#LogDirSub=cmanage
#MainLogFile=$LogDir$LogDirSub/cmanage.log
#ModLogFile=$LogDir$LogDirSub/modules.log

