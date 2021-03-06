#!/bin/bash

configfile="/etc/cmanage.conf"

# Set DB Username, password and database

dbuser=cmanage
dbpass=cmanagepass
dbname=cmanage
dbtype=mysql

# Set ciscocmd options

ccuser=ciscocmd
ccpass=ciscocmd

# Set MySQL query
if [ $dbtype = "mysql" ]; then
  DBQ="mysql -u$dbuser -p$dbpass -D$dbname -s"
fi

function getconfvar () {
  more $configfile | grep $1 | gawk -F= '{ print $2 }'
}

function ccommand () {
  echo "Running ciscocmd -u $ccuser -p $ccpass -t $1 -c $2"
  ciscocmd -u $ccuser -p $ccpass -t $1 -c "$2"
}

loglevel=`getconfvar LogLevel`
export DBQ loglevel

function logmess () {
  if [ "$2" -le "$loglevel" ]; then
    echo "$1"
  fi
}

function dblog () {
  echo "insert into sys_log set system='$1',message='$2'" | $DBQ
}

function setdnow () {
  dnow=`date +%s`
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

function setalert () {
  echo "insert into alerts set userid='$1',message='$2'" | $DBQ
}

function getvarint () {
  echo "select varint from configs where varname='$1'" | $DBQ
}

function setvarint () {
  echo "select varint from configs where varname='$1'" | $DBQ
}
