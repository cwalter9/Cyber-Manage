#!/bin/bash

# Set DB Username, password and database

dbuser=cmanage
dbpass=cmanagepass
dbname=cmanage
dbtype=mysql

# Set MySQL query
if [ $dbtype = "mysql" ]; then
  DBQ="mysql -u$dbuser -p$dbpass -D$dbname -s"
fi

