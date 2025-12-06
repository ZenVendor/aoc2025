#!/bin/bash

declare -a ranges rangee
while read line; do
    if [[ ${#line} -eq 0 ]]; then
        break
    fi
    s=$(cut -d- -f1 <<< $line)
    e=$(cut -d- -f2 <<< $line)
    ranges+=($s)
    rangee+=($e)
done < $1

len=${#ranges[@]}
last=$((len - 1))

printf "" > $2
declare -a merged

i=0
while [[ $i -lt $last ]]; do
    s=${ranges[$i]}
    e=${rangee[$i]}
    next=$(( i + 1 ))
    
    for j in $(seq $((i+1)) $last); do
        sn=${ranges[$j]}
        en=${rangee[$j]}
        if [[ $sn -gt $(( e + 1)) ]]; then
            break
        fi
        if [[ $en -le $e ]]; then
            echo "range $sn-$en is contained in $s-$e"
            next=$(( j + 1 ))
            continue
        fi
        echo "range $sn-$en extends $s-$e"
        e=$en
        next=$(( j + 1 ))
    done
    printf "$s-$e\n" >> $2
    i=$next
done
