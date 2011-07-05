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

MainLogFile=`getconfvar MainLogFile`
if [ ! -f $MainLogFile ]; then
  logmess "Missing main logfile creating now" "10"
  touch $MainLogFile
fi

ModLogFile=`getconfvar ModLogFile`
if [ ! -f $ModLogFile ]; then
  logmess "Missing mod logfile creating now" "10"
  touch $ModLogFile
fi

