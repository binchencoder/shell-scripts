#!/bin/bash

#!/bin/bash

while getopts ":s:n:i:d:p:" opt; do
    case $opt in
    n)
        echo "选项-$opt的值是$OPTARG"
        name=$OPTARG
        ;;
    s)
        echo "选项-$opt的值是$OPTARG"
        ;;
    d)
        echo "选项-$opt的值是$OPTARG"
        ;;
    i)
        echo "选项-$opt的值是$OPTARG"
        ;;
    p)
        echo "选项-$opt的值是$OPTARG"
        ;;
    :)
        echo "选项-$OPTARG后面需要一个参数值"
        exit 1
        ;;
    # ?)
    #     echo "无效的选项 -$OPTARG"
    #     exit 2
    #     ;;
    esac
done

echo $name