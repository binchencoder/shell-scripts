#!/bin/bash
#author:chenbin

set -e

###
### 根据不同输入, 执行kubectl命令.
###
### Usage:
###   sh kubepod.sh [command] [podname]
###
### Options:
###   pods      查看Pod列表
###   svcs      查看Svc列表
###   deploys   查看Deployment列表
###   exec  进入容器(Default)
###   logs  查看日志
###   svc   查看服务部署的端口
###   desc  查看当前pod的状态日志
###   
###   -h | -help    Show help message.

help() {
    sed -rn 's/^### ?//;T;p;' "$0"
}

Print_green() {
    echo -e "\033[32m$1\033[0m"
}

Print_red() {
    echo -e "\033[31m$1\033[0m"
}

if [[ "$1" == "-help" ]] || [[ "$1" == "-h" ]]; then
    help
    exit 1
fi

ACTION="exec"
if [ ! -n "$1" ]; then
    # echo "you have not input a word!"
    echo ""
else
    # echo "you input: $1"
    ACTION=$1
fi

APP_NAME="knowledge-build-server"
if [ ! -n "$2" ]; then
    # echo "you have not input a word!"
    echo ""
else
    # echo "you input: $2"
    APP_NAME=$2
fi

# 查看部署的服务pod name
#kubectl get pod -A | grep $APP_NAME
POD_NAMES=$(kubectl get pod -A | grep $APP_NAME | awk -F " " '{print $1 "/" $2}')
echo $POD_NAMES

# 查看Pods
Pods(){
    kubectl get pods -A
}

# 查看Svcs
Svcs(){
    kubectl get svc -A
}

# 查看Deployments
Deployments(){
    kubectl get deployments -A
}


# 查看日志
Logs(){
    Print_green "kubectl logs -f -n $1"
    kubectl logs -f -n $1
}

# 进入容器
Exec(){
    Print_green "kubectl exec -it -n $1 /bin/bash"
    kubectl exec -it -n $1 /bin/bash
}

# 查看服务部署的端口
Svc(){
    kubectl get svc -A | grep $APP_NAME
}

# 查看当前pod的状态日志
Desc(){
    Print_green "kubectl describe pod -n $1"
    kubectl describe pod -n $1
}

function choose {
    pod=${POD_NAMES}
    # 存在多个选项
    if ( echo ${POD_NAMES} | grep -q " " )
    then
        select option in ${POD_NAMES}
        do
            if [ "${option}" = "" ]; then
                # echo "请输入正确的选项"
                echo ''
            else
                pod=${option}
                break
            fi
        done
    fi
    echo $pod | sed 's/\// /g'
}

# 根据不同输入执行不同内容
if [ "$ACTION" = "pods" ]; then
	Pods
elif [ "$ACTION" = "svcs" ]; then
    Svcs
elif [ "$ACTION" = "deploys" ]; then
    Deployments
elif [ "$ACTION" = "logs" ]; then
    Logs "`choose`"
elif [ "$ACTION" = "exec" ]; then
    Exec "`choose`"
elif [ "$ACTION" = "svc" ]; then
    Svc
elif [ "$ACTION" = "desc" ]; then
    Desc "`choose`"
else
    echo ""
fi
