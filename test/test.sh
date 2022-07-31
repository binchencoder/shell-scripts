#!/bin/bash

ARGS=`getopt -o hvab:c:: --long help,version,along,blong:,clong:: -n 'test.sh' -- "$@"`
if [ $? -ne 0 ]; then 
    echo "Terminating..."
    exit 1
fi

#将规范化后的命令行参数分配至位置参数($1,$2...)
eval set -- "${ARGS}"

while true
do
    case "$1" in
        -a|--along)
            echo "Option a";
            shift
            ;;
        -b|--blong)
            echo "Option b, argument $2";
            shift 2
            ;;
        -c|--clong)
            case "$2" in
                "")
                    echo "Option c, no argument";
                    shift 2
                    ;;
                *)
                    echo "Option c, argument $2";
                    shift 2
                    ;;
            esac
            ;;
        -v|--version)
            echo "-v | --version";
            shift
            ;;
        -h|--help)
            echo "-h | --help";
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error"
            exit 1
            ;;
    esac
done

#处理剩余的参数
for arg in $@
do
    echo "processing ${arg}";
done