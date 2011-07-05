#!/bin/bash
source includes/main.inc

function updatentpservers () {
  for i in `ccommand $1 "sh run" | grep "ntp server"`; do
    echo ${i[@]:1:2}
  done
}

updatentpservers col1-neta-4506a
