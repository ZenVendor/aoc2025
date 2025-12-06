#!/bin/bash

# setup
prep="in06_prep"
sed 's/ /0/g' $1 > $prep

declare -a lines
while read line; do
    lines+=($line)
done < $prep

len=${#lines[0]}
result=0

echo "$len"
for i in $( seq 0 $((len - 1)) ); do

    op=${lines[4]:$i:1}
    if [[ $op == [+*] ]]; then 
        opr=$op
        echo -n "Operation: $opr "
    fi

    v1=${lines[0]:$i:1}
    v2=${lines[1]:$i:1}
    v3=${lines[2]:$i:1}
    v4=${lines[3]:$i:1}
    num=$(sed 's/0//g' <<< "$v1$v2$v3$v4")
    echo -n "$num "

    if [[ $num -ne 0 ]]; then
        vars+=($num)
    fi

    if [[ $num -eq 0 || $i -eq $((len - 1)) ]]; then
        vn=${#vars[@]}
        if [[ $opr == '+' ]]; then
            t=0
            for n in $(seq 0 $((vn - 1))); do
                x=${vars[$n]}
                (( t += x ))
            done
        else
            t=1
            for n in $(seq 0 $((vn - 1))); do
                x=${vars[$n]}
                (( t *= x ))
            done
        fi
        (( result += t ))
        echo "Total: $t"

        vn=0
        unset vars
        unset opr
        continue
    fi
done

echo "Result: $result"

# cleanup
rm $prep
