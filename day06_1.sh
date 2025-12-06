#!/bin/bash

declare -a var0 var1 var2 var3 oper
ln=0
while read line; do
    line=$(sed 's/\s\+/ /g' <<< $line)
    if [[ ${line:0:1} == [+*] ]]; then
        echo "operations"
        IFS=' ' read -a oper <<< $line
        continue
    fi
    if [[ ln -eq 0 ]]; then
        IFS=' ' read -a var0 <<< $line
    fi
    if [[ ln -eq 1 ]]; then
        IFS=' ' read -a var1 <<< $line
    fi
    if [[ ln -eq 2 ]]; then
        IFS=' ' read -a var2 <<< $line
    fi
    if [[ ln -eq 3 ]]; then
        IFS=' ' read -a var3 <<< $line
    fi
    (( ln += 1 ))
done < $1

len=${#oper[@]}

use=0
if [[ ${#var3[@]} -eq $len ]]; then
    use=1
fi

for i in $(seq 0 $((len - 1))); do
    op=${oper[$i]}
    a=${var0[$i]}
    b=${var1[$i]}
    c=${var2[$i]}
    if [[ $op == '+' ]]; then
        res=$((a + b + c))
        echo -n "$a + $b + $c"
    else
        res=$((a * b * c))
        echo -n "$a * $b * $c"
    fi
    if [[ $use -eq 1 ]]; then
        d=${var3[$i]}
        if [[ $op == '+' ]]; then
            (( res += d ))
            echo -n " + $d"
        else
            (( res *= d ))
            echo -n " * $d"
        fi
    fi
    (( sum += res ))
    echo " = $res"
done

echo "Result: $sum"





