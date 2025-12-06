#!/usr/bin/env bash

sum=0

while read line; do
    echo "NUMBERS: $line"
    declare -a bat
    for i in $(seq 0 $(( ${#line} - 1 )) ); do
        bat+=(${line:$i:1})
    done

    max=0
    for num in $(seq 9 -1 1); do
        echo "Number: $num, Max: $max"
        if [[ $((num * 10)) -lt $max ]]; then
            echo "Completed - higher number already found"
            break
        fi
        for i in $(seq 0 $((${#bat[@]} - 2))); do 
            if [[ ${bat[$i]} -eq $num ]]; then 
                for j in $(seq $((i+1)) $((${#bat[@]} - 1))); do
                    curr="${bat[$i]}${bat[$j]}"
                    echo "Current: $curr"
                    if [[ $curr -gt $max ]]; then
                        max=$curr
                    fi
                    if [[ $max -eq 99 ]]; then 
                        echo "Completed - max number"
                        break 3
                    fi
                done
            fi
        done
    done

    ((sum += max))

    unset bat
done < $1

echo "Result: $sum"

