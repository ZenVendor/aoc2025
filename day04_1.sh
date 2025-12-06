#!/usr/bin/env bash


sum=0

declare -a lines digits current

while read -r line; do
    lines+=($line)
done < $1

lcount=${#lines[@]}
llen=${#lines[1]}

for l in ${lines[@]}; do
    ld=""
    cld=""
    ll=${#l}
    # echo "LINE: $l"
    for c in $(seq 0 $((ll - 1))); do
        start=$((c - 1))
        if [[ $start -lt 0 ]]; then
            start=0
        fi
        end=$((c + 1))
        if [[ $end -ge ${#l} ]]; then
            end=$c
        fi
        # for all lines
        len=$((end - start + 1))
        part=$(sed 's/\.//g'<<< ${l:$start:$len})
        cnt=${#part}
        ld="$ld$cnt"
        
        # for current lines
        cstr=""
        if [[ $start -ne $c ]]; then
            cstr="$cstr${l:$start:1}"
        fi
        if [[ $end -ne $c ]]; then
            cstr="$cstr${l:$end:1}"
        fi
        cpart=$(sed 's/\.//g'<<< $cstr)
        ccnt=${#cpart}
        cld="$cld$ccnt"
        # echo "$c: $start-$end; $len - $part, $cnt : $ld"
        # echo "$c: $start-$end; $cpart, $ccnt : $cld"
    done
    # echo "$l : $ld : $cld"
    digits+=($ld)
    current+=($cld)
done


for l in $(seq 0 $((lcount - 1))); do
    fl=""
    for c in $(seq 0 $((llen - 1))); do
        # Check character from map
        lchar=${lines[$l]}
        lc=${lchar:$c:1}

        if [[ $lc != "@" ]]; then
            fl="$fl$lc"
            continue
        fi

        cl=${current[$l]}
        cur=${cl:$c:1}

        up=0
        if [[ $l -gt 0 ]]; then
            ul=${digits[$((l - 1))]}
            up=${ul:$c:1}
        fi
        dn=0
        if [[ $l -lt $((lcount - 1)) ]]; then
            dl=${digits[$((l + 1))]}
            dn=${dl:$c:1}
        fi
        roll=$(( up + cur + dn ))
        if [[ $roll -lt 4 ]]; then
            ((sum += 1)) 
            lc="x"
        fi
        fl="$fl$lc"
    done
    # echo $fl
done

echo "==="
echo "Result: $sum"
