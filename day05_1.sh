#!/usr/bin/env bash

sum=0

mode=0
declare -a ranges rangee ids
while read line; do
    if [[ ${#line} -eq 0 ]]; then
        mode=1
        echo "Ranges: ${#ranges[@]}"
        echo "Start processing IDs"
    fi
    if [[ $mode -eq 0 ]]; then
        s=$(cut -d- -f1 <<< $line)
        e=$(cut -d- -f2 <<< $line)
        ranges+=($s)
        rangee+=($e)
        continue
    fi

    ids+=($line)

done < $file
cids=${#ids[@]}
echo "IDs: $cids"
echo "Processing"

count=1
for id in ${ids[@]}; do    
    printf "\r$count out of $cids"
    for i in ${!ranges[@]}; do
        if [[ $id -ge ${ranges[$i]} && $id -le ${rangee[$i]} ]]; then
            ((sum += 1))
            break
        fi
    done
    ((count += 1))
done
printf "\n"


echo "==="
echo "Result: $sum"
