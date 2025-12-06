#!/usr/bin/env bash

count=0
curr=50
prev=50

while read -r line; do
    prev=$curr
    dir=${line:0:1}
    onum=${line:1}
    
    cadd=$(( onum / 100 ))
    num=$(( onum % 100 ))
    
    case $dir in
        R)
            (( curr += num ))
            if [ $curr -gt 99 ]; then
                (( curr %= 100 ))
                if [[ $prev -ne 0 && $curr -ne 0 ]]; then
                    (( cadd += 1 ))
                fi
            fi
            ;;
        L)
            (( curr -= num ))
            if [ $curr -lt 0 ]; then
                (( curr += 100 )) 
                if [ $prev -ne 0 ]; then
                    (( cadd += 1 ))
                fi
            fi
            ;;
    esac
    if [ $curr -eq 0 ]; then
        (( cadd += 1 ))
    fi

    (( count += cadd ))

    echo "start at $prev, turn $dir $onum ending at $curr. pointed at zero $cadd times." 
done < $1
echo "Zero count: $count"
