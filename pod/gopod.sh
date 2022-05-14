#!/bin/bash

APP_NAME="knowledge-build-server"
#POD_NAME="knowledge-build-server"

# 查看部署的服务pod name
#kubectl get pod -A | grep $APP_NAME
POD_NAME=$(kubectl get pod -A | grep $APP_NAME | awk -F " " '{print $1 " " $2}')
echo $POD_NAME

#echo $(kubectl get pod -A | grep $APP_NAME | awk -F " " '{print $1 " " $2}')

#echo $(kubectl get pod -A | grep $APP_NAME | tail -n 2 | cut -d "=" -f 2 | awk -F " " '{print $1 " " $2}')

#echo $(kubectl get pod -A | grep $APP_NAME | tail -n 2 | cut -d "=" -f 2 | awk '{print $1}' | awk '{print $2}')

# 进入容器
kubectl exec -it -n $POD_NAME /bin/bash