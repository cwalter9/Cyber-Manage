#!/bin/bash

source includes/main.inc

echo "delete from sensatronic_em1" | $DBQ
echo "delete from scn_address" | $DBQ
