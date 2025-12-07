#!/bin/bash

# Calculating trees without trees...

declare -a beams
declare -A paths
ln=0
splits=0
len=0
while read line; do
    echo "Line $ln: "

    if [[ $ln -eq 0 ]]; then
        start=${line%%S*}
        echo "Start: ${#start}"
        beams+=(${#start})
        paths[${#start}]=1
        len=${#line}
        ((ln += 1))
        continue
    fi
    
    declare -a temp
    declare -A ptemp
    for b in ${beams[@]}; do
        
        if [[ ${line:$b:1} == "^" ]]; then
            (( splits += 1 ))
            b1=$((b-1))
            b2=$((b+1))
            echo "  Beam $b is split into $b1 and $b2"
            
            # Don't add multiples
            if ! [[ ${temp[@]} =~ $b1 ]]; then
                temp+=($b1)
            fi
            if ! [[ ${temp[@]} =~ $b2 ]]; then
                temp+=($b2)
            fi
            
            # add path counts to the new beams
            (( ptemp[$b1] += paths[$b] ))
            (( ptemp[$b2] += paths[$b] ))

        else
            echo "   Beam $b continues"
            # Don't add multiples
            if ! [[ ${temp[@]} =~ $b ]]; then
                temp+=($b)
            fi
            (( ptemp[$b] += paths[$b] ))
        fi
    done

    beams=(${temp[@]})
    echo "  Current beams: ${beams[@]}"
    
    # New paths
    unset paths
    echo -n "  Current paths:"
    for key in ${!ptemp[@]}; do
        paths[$key]=${ptemp[$key]}
        echo -n " [$key:${paths[$key]}]"
    done
    echo ""

    # cleanup temp variables
    unset temp ptemp
    ((ln += 1))
done <$1

echo "Total splits: $splits"
sum=0
for val in ${paths[@]}; do
    (( sum += val )) 
done
echo "Total paths: $sum"
