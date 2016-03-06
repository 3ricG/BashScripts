#!/bin/sh

IFS=$'\n'
lines=`/sbin/pfctl -aminiupnpd -sn | grep -o '".*"' | sed 's/"//g'`
for line in $lines; do
  ip=`echo $line | sed 's/:/ /g' | awk '{ print $1 }'`
  nslookup=`drill -x $ip @127.0.0.1 | grep -i "ANSWER SECTION" -A 1 | grep -v ";;" | awk '{ print $NF }' | sed 's/\.$//g'`
  if [ -z $nslookup ]; then
    echo $line
  else
    echo $line | sed "s/"$ip"/"$nslookup"/g"
  fi
done