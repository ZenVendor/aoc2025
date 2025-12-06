#!/bin/bash

## First parameter must be file, second is output file, third is optional "test"

# load ranges into arrays

if [[ $3 == "test" ]]; then
    echo "Original:"
fi

declare -a ranges rangee
while read line; do
    if [[ ${#line} -eq 0 ]]; then
        break
    fi
    s=$(cut -d- -f1 <<< $line)
    e=$(cut -d- -f2 <<< $line)
    ranges+=($s)
    rangee+=($e)

    if [[ $3 == "test" ]]; then
        echo "$s - $e"
    fi

done < $1



# Sort
while true; do
    swaps=0
    for i in $(seq 0 $(( ${#ranges[@]} - 2 )) ); do
        swap=0
        s1=${ranges[$i]}
        e1=${rangee[$i]}
        s2=${ranges[$(($i+1))]}
        e2=${rangee[$(($i+1))]}

        if [[ $s1 -gt $s2 ]]; then
            swap=1
        fi 
        if [[ $s1 -eq $s2 && $e1 -gt $e2 ]] then
            swap=1
        fi 
        if [[ swap -eq 1 ]]; then
            ranges[$i]=$s2
            rangee[$i]=$e2
            ranges[$(($i+1))]=$s1
            rangee[$(($i+1))]=$e1
        fi
        ((swaps += swap))
    done
    if [[ $swaps -eq 0 ]]; then
        break
    fi
done

if [[ $3 == "test" ]]; then
    echo "Sorted:"
fi

# Save to a file
printf "" > $2
for i in ${!ranges[@]}; do
    printf "${ranges[$i]} - ${rangee[$i]}\n" >> $2
    if [[ $3 == "test" ]]; then
        echo "${ranges[$i]} - ${rangee[$i]}"
    fi
done


