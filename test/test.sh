#!/bin/bash
#author:chenbin

set -e

ACTION="exec"
if [ ! -n "$1" ]; then
    echo "you have not input a word!"
else
    echo "you input: $1"
    ACTION=$1
fi

if [ $ACTION = "logs" ]; then
    echo "执行logs"
else
    echo "执行$ACTION"
fi

# 获取当前时间
Time=`date +"%Y%m%d%H%M%S"`
MD=`date +"%m%d"`

echo "Time=$Time"
echo "MD=$MD"
