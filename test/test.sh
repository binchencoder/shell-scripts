#!/bin/bash

POD_NAME=$(awk -F " " '{print $1 "," $2 "," $3 "," $4 "," $5 "," $6} ' k8s.txt)
echo ${POD_NAME}

if ( echo ${POD_NAME} | grep -q " " )
then
    echo "did contain space or single quote"
    select option in ${POD_NAME}
    do
        if [ "${option}" = "" ]; then
                # echo "请输入正确的选项"
                echo ''
        else
            pod=${option}
            break
        fi
    done
else
    echo "did not contain space or single quote"
fi