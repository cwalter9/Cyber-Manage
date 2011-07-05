#!/bin/bash

function getswid () {
  swid=`echo "select id from swVersions where shortname='$1'" | $DBQ`
  if [ -z "$swid" ]; then
    echo "swid is null"
    echo "insert into swVersions set shortname='$1'" | $DBQ
    swid=`echo "select id from swVersions where shortname='$1'" | $DBQ`
    echo "swid is $swid"
  else
    echo "$1 swid is $swid"
  fi
  export swid
}

function getpath () {
  lpath=`which $1`
  export lpath
}

function getbashver () {
  swver=`$1 --version | grep version | grep -v License`
  export swver
}

function procsw () {
  getswid $1
  getpath $1
  getbashver $1
  datesecs=`date +%s`
  echo "update swVersions set location='$lpath',version='$swver',lastchecked='$datesecs' where id='$swid'" | $DBQ
}

procsw bash
