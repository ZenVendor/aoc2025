#!/usr/bin/env bash

sum=0

while read line; do
    echo "NUMBERS: $line"
    declare -a bank
    for i in $(seq 0 $(( ${#line} - 1 )) ); do
        bank+=(${line:$i:1})
    done

    n=12

    range=$(( ${#bank[@]} - n ))
    max=0
    next=0

    for b in $(seq 0 $((n-1))); do
        bmax=0
        bi=0
        for i in $(seq $next $((b + range))); do
            # echo "Battery $b temp: Index: $i, Value: ${bank[$i]}"
            if [[ ${bank[$i]} -gt $bmax ]]; then
                bmax=${bank[$i]}
                bi=$i
            fi
        done
        echo "Battery $b final: Index: $bi, Value: $bmax"
        (( max += bmax * (10 ** (n - b - 1)) ))
        next=$((bi + 1))
    done
    echo "Total: $max"

    ((sum += max))

    unset bank
done < $1

echo "==="
echo "Result: $sum"
