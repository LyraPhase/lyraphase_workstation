#!/bin/bash

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  SUDO=sudo
else
  SUDO=''
fi

SEP='------------------------------------------------------------'
echo -ne "$SEP\n$(date)\nBad McAfee! STOP eating my RAM!\n$SEP" | $SUDO tee -a /var/log/kill_misbehaving_mcafee.log

$SUDO ps auxww | grep -i 'VShieldScanner\|VShieldScanManager\|masvc\|McAfee\|dataloss' | grep -v grep | $SUDO tee -a /var/log/kill_misbehaving_mcafee.log
$SUDO ps auxww | grep -i 'VShieldScanner\|VShieldScanManager\|masvc\|McAfee\|dataloss' | grep -v grep   | awk '{ print $2 }'  | $SUDO xargs kill -9

kextstat  | grep -i mcafee | awk '{ print $6 }'  | $SUDO xargs -n1 -I{} kextunload -verbose 2 -bundle-id '{}'

