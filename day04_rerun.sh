#!/bin/bash

sum=0
count=1

while true; do 
    echo "Run #$count"
    ./day04_2.sh in04_result 
    read -r result < out04_result
    echo "Result: $result"
    if [[ $result -eq 0 ]]; then
        echo "No more rolls removed"
        break
    fi
    (( sum += result ))
done
echo "Total: $sum"

