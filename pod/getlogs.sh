#!/bin/bash

APP_NAME="knowledge-build-server"

# 查看部署的服务pod name
#kubectl get pod -A | grep $APP_NAME
POD_NAME=$(kubectl get pod -A | grep $APP_NAME | awk -F " " '{print $1 " " $2}')
echo $POD_NAME

# 查看日志
kubectl logs -f -n $POD_NAME