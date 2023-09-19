#!/bin/bash
#author:chenbin

set -e

###
### 根据不同输入, 执行kubectl命令.
###
### Usage:
###   kubepod [command] [appname]
###
### Options:
###   jobs      查看Job列表
###   pods      查看Pod列表
###   svcs      查看Svc列表
###   deploys   查看Deployment列表
###   exec      进入容器(Default)
###   logs      查看日志
###   job       查看Job信息
###   pod       查看pod信息
###   svc       查看svc信息
###   desc      查看当前pod的状态日志
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

# namespace
NS="pie-gpt"

# Default action
ACTION="exec"
APP_NAME="knowledge-build-server"
if [ "$#" -eq 1 ]; then
    if [[ "$1" == "pods" ]] || [[ "$1" == "svcs" ]] || [[ "$1" == "deploys" ]] || [[ "$1" == "jobs" ]]; then
        ACTION=$1
    else
        APP_NAME=$1
    fi
else
    if [ ! -n "$1" ]; then
        # echo "you have not input a word!"
        echo ""
    else
        # echo "you input: $1"
        ACTION=$1
    fi

    if [ ! -n "$2" ]; then
        # echo "you have not input a word!"
        echo ""
    else
        # echo "you input: $2"
        APP_NAME=$2
    fi
fi

# 查看部署的服务pod name
POD_NAMES=$(kubectl get pod -n $NS | grep $APP_NAME | awk -F " " '{print "pie-gpt" "," $1 "," $2 "," $3 "," $4 "," $5 "," $6}')
# echo "kubectl get pod -A | grep $APP_NAME"
# echo -e "$POD_NAMES \n"

#查看Jobs
Jobs(){
    Print_green "kubectl get jobs -n $NS"
    kubectl get jobs -n $NS
}

# 查看Pods
Pods(){
    Print_green "kubectl get pods -n $NS"
    kubectl get pods -n $NS
}

# 查看Svcs
Svcs(){
    Print_green "kubectl get svc -n $NS"
    kubectl get svc -n $NS
}

# 查看Deployments
Deployments(){
    Print_green "kubectl get deployments -n $NS"
    kubectl get deployments -n $NS
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

# 查看job信息
Job(){
    Print_green "kubectl get job -n $NS | grep $APP_NAME"
    kubectl get job -n $NS | grep $APP_NAME
}

# 查看pod信息
Pod(){
    Print_green "kubectl get pod -n $NS | grep $APP_NAME"
    kubectl get pod -n $NS | grep $APP_NAME
}

# 查看svc信息
Svc(){
    Print_green "kubectl get svc -n $NS | grep $APP_NAME"
    kubectl get svc -n $NS | grep $APP_NAME
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
        # IFS=" "
        PS3="Enjoy your choose:> "
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
    # echo $pod | sed 's/\// /g'
    echo $pod | awk -F "," '{print $1 " " $2}'
}

# 根据不同输入执行不同操作
case "$ACTION" in
    jobs)
        Jobs
        ;;

    pods)
        Pods
        ;;

    svcs)
        Svcs
        ;;

    deploys)
        Deployments
        ;;

    logs)
        Logs "`choose`"
        ;;

    exec)
        Exec "`choose`"
        ;;

    job)
       Job
       ;;

    pod)
       Pod
       ;;

    svc)
       Svc
       ;;

    desc)
        Desc "`choose`"
        ;;
    *)

        echo "Internal error"
        exit 1
        ;;
esac