#!/bin/bash
for i in client-configs/*.conf
do
  echo "-------- ${i} --------"
  cat ${i} | qrencode -t ansiutf8 -l L
done
