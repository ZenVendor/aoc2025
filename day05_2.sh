#!/bin/bash

./util_ranges_sort.sh in05 in05_sorted
./util_ranges_merge.sh in05_sorted in05_merged

sum=0
while read line; do
    s=$(cut -d- -f1 <<< $line)
    e=$(cut -d- -f2 <<< $line)
    items=$(( e - s + 1 ))
    (( sum += items ))
done < in05_merged

echo "Result: $sum"

rm in05_{sorted,merged}
