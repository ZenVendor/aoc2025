#!/bin/bash

declare -a beams
ln=0
splits=0
len=0
while read line; do
    echo -n "Line $ln: "

    if [[ $ln -eq 0 ]]; then
        start=${line%%S*}
        echo "Start: ${#start}"
        beams+=(${#start})
        len=${#line}
        ((ln += 1))
        continue
    fi
    
    echo "${#beams[@]} beams to check"

    declare -a temp
    for b in ${beams[@]}; do
        if [[ ${line:$b:1} == "^" ]]; then
            (( splits += 1 ))
            b1=$((b-1))
            b2=$((b+1))
            echo "Beam $b is split: $b1 $b2"
            if ! [[ $b1 -lt 0 || ${temp[@]} =~ $b1 ]]; then
                temp+=($b1)
            fi
            if ! [[ $b2 -ge len || ${temp[@]} =~ $b2 ]]; then
                temp+=($b2)
            fi
        else
            echo "Beam $b continues"
            if ! [[ ${temp[@]} =~ $b ]]; then
                temp+=($b)
            fi
        fi
    done
    if [[ ${#temp[@]} -gt 0 ]]; then
        beams=(${temp[@]})
    fi
    unset temp
    echo "Current beams: ${beams[@]}"
    ((ln += 1))
done <$1

echo "Total splits: $splits"
