#!/bin/bash

APP_NAME="knowledge-build-server"

POD_NAME=$(kubectl get pod -A | grep $APP_NAME | awk -F " " '{print $1 "," $2}')
echo "POD_NAME" $POD_NAME

if ( echo ${POD_NAME} | grep -q " " )
then
    echo "did contain space or single quote"
    select option in ${POD_NAME}
    do
        echo ${option}
    done
else
    echo "did not contain space or single quote"
fi


# do
#     case $variable in
#     "Exit menu")
#         break ;;
#     "Display disk space")
#         diskapace  ;;
#     "Display logged on users")
#             whoseon ;;
#     "Display memory usage")
#             menusage ;;
#     *)
#         clear
#         echo "sorry,wrong selection" ;;
#     esac
# done