#!/usr/bin/env bash

result=0

IFS=, read -a ranges < $1
for range in "${ranges[@]}"; do
    IFS=- read -r start end <<< $range
    len=${#start}
    lastlen=${#end}
    numranges=$((lastlen - len))
    firsteven=$((len % 2))
    
    if [ $numranges -gt 1 ]; then
#        echo "more ranges"
        (( countranges += 1))
        continue
    fi
    if [[ $numranges -eq 0 && $firsteven -ne 0 ]]; then
#        echo "range $range is odd - skipping"
        continue
    fi
#    if [[ $numranges -eq 0 && $firsteven -eq 0 ]]; then
#        echo "range $range is even"
#    fi
    if [[ $numranges -eq 1 && $firsteven -ne 0 ]]; then
        start=$((10 ** (lastlen - 1) ))
        len=$lastlen
#        echo "range $range: First is odd, range is $start - $end"
    fi
    if [[ $numranges -eq 1 && $firsteven -eq 0 ]]; then
        end=$((10 ** (lastlen - 1) - 1))
#        echo "range $range: First is even, range is $start - $end"
    fi
    
    half=$((len / 2))
    fhs=${start:0:$half}
    fhe=${end:0:$half}
    
    for n in $(seq $fhs $fhe); do
        num="$n$n"
        if [[ $num -ge $start && $num -le $end ]]; then
            ((result += num))
            echo "Halves: $num"
        fi
    done
done 
echo "Result: $result"
