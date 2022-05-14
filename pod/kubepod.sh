#!/bin/bash
#author:chenbin

set -e

###
### 根据不同输入, 执行kubectl命令.
###
### Usage:
###   ./kubepod.sh <input>
###
### Options:
###   exec  进入容器(Default).
###   logs  查看日志.
###   svc   查看服务部署的端口
###   desc  查看当前pod的状态日志
###   
###   -h | -help    Show help message.

help() {
    sed -rn 's/^### ?//;T;p;' "$0"
}

if [[ "$1" == "-help" ]] || [[ "$1" == "-h" ]]; then
    help
    exit 1
fi

APP_NAME="knowledge-build-server"

ACTION="exec"
if [ ! -n "$1" ]; then
    # echo "you have not input a word!"
    echo ""
else
    # echo "you input: $1"
    ACTION=$1
fi

# 查看部署的服务pod name
#kubectl get pod -A | grep $APP_NAME
POD_NAME=$(kubectl get pod -A | grep $APP_NAME | awk -F " " '{print $1 " " $2}')
echo $POD_NAME

# 查看日志
Logs(){
    kubectl logs -f -n $POD_NAME
}

# 进入容器
Exec(){
    kubectl exec -it -n $POD_NAME /bin/bash
}

# 查看服务部署的端口
Svc(){
    kubectl get svc -A | grep $APP_NAME
}

# 查看当前pod的状态日志
Desc(){
    kubectl describe pod -n $POD_NAME
}

if [ "$ACTION" = "logs" ]; then
    Logs
elif [ "$ACTION" = "exec" ]; then
    Exec
elif [ "$ACTION" = "svc" ]; then
    Svc
elif [ "$ACTION" = "desc" ]; then
    Desc
else
    echo ""
fi
