#!/bin/bash
wpctl status | awk '/Sinks:/{flag=1; next} /├─/{if(flag) flag=0} flag && /[0-9]+\./ {
  is_def = index($0, "*") > 0 ? "1" : "0"
  match($0, /([0-9]+)\./, id_arr)
  id = id_arr[1]
  sub(/.*[0-9]+\.[ \t]+/, "", $0)
  sub(/[ \t]+\[.*/, "", $0)
  print id "|" is_def "|" $0
}'
