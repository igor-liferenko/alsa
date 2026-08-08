#!/bin/sh
logger -p local0.alert -t alarm `echo "$*" | iconv -f cp1251`
sudo -u asterisk /etc/asterisk/call.sh $1
