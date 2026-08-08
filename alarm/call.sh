#!/bin/sh
FILE=$(mktemp -p /tmp XXXXXXXXXX)
cat <<EOF >$FILE
Channel: SIP/ses/4208
Callerid: 922
MaxRetries: 10000
RetryTime: 1
WaitTime: 10000
Application: Playback
Data: m200alarm&$1
EOF
mv $FILE /var/spool/asterisk/outgoing/
