#!/usr/bin/env bash

# prep
# Requires sorted input
prep="in02_prep"
sorted="in02_sorted"
merged="in02_merged"
sed 's/,/\n/g' $1 > $prep
./util_ranges_sort.sh $prep $sorted
./util_ranges_merge.sh $sorted $merged
sed 's/\n/,/g' $merged > $prep
#

declare -a halves found

IFS=, read -a ranges < $1
for range in "${ranges[@]}"; do
    IFS=- read -r start end <<< $range
    slen=${#start}
    elen=${#end}
    half=$((elen / 2))

    echo "Range: $range, lengths: $slen-$elen"

    for r in $(seq $slen $elen); do 
        echo -n "  LENGTH: $r - "
        if [[ $r -eq 1 ]]; then 
            echo "skip - single digit"
            continue 
        fi
        rs=$start
        re=$end
        if [[ $r -gt $slen ]]; then
            rs=$(( 10 ** (r - 1) ))
        fi
        if [[ $r -lt $elen ]]; then
            re=$(( 10 ** r - 1 ))
        fi

        echo "checking range: $rs - $re"

        for i in $(seq 1 $half); do
            if [[ $((r % i)) -ne 0 ]]; then
                echo "      part $i - skip - does not fit"
                continue
            fi

            echo "      part $i - check"
            
            count=$((r / i))
            if [[ $count -eq 1 ]]; then 
                continue
            fi
            fch=${rs:0:$i}
            lch=${re:0:$i}

            for n in $(seq $fch $lch); do
                num=$(printf "$n%.0s" $(seq 1 $count))
                echo -n "           trying: $num"
                if [[ $num -lt $rs || $num -gt $re ]]; then
                    echo " - out of range"
                    continue
                fi
                if [[ $count -eq 2 ]]; then
                    echo -n " [also p1]"
                    halves+=($num)
                fi
                if [[ ${found[@]} =~ $num ]]; then
                    echo " - already counted"
                    continue
                fi
                found+=($num)
                echo " - found" 
            done
        done
    done
done 


hal=0
for ae in ${halves[@]}; do
    ((hal += ae))
done
sum=0
for ae in ${found[@]}; do
    ((sum += ae))
done
echo "====="
echo "Result first: $hal"
echo "Result second: $sum"
echo "====="

# cleanup
rm $prep $sorted $merged
