#!/bin/bash

ip_list=("1.1.1.1" "9.9.9.9" "149.112.112.112" "208.67.222.222")   


# --- Logic --- 
echo "Checking network Connectivity ....."

for i in "${ip_list[@]}";do
    echo "$i"
    ping -co 4 "$i"
    echo "pinged ip addresses to check internet connection"
done

