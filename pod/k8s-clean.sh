#!/bin/sh

podstat="CrashLoopBackOff Completed Error Terminating Evicted"
namespaces="default native-system pie-engine-ai pie-engine-bpaas pie-engine-computing pie-engine-common piecloud-business piecloud-image-search piecloud-infra piecloud-system pie-engine-ai pie-engine-bpaas pie-engine-common pie-engine-infra pie-engine-job-ai pie-engine-server"

for s in ${podstat}
do
    #kubectl delete po -n default `kubectl get po -n default | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n native-system `kubectl get po -n native-system | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n pie-engine-ai `kubectl get po -n pie-engine-ai | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n pie-engine-bpaas `kubectl get po -n pie-engine-bpaas | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n pie-engine-computing `kubectl get po -n pie-engine-computing | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n pie-engine-common `kubectl get po -n pie-engine-ai | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n piecloud-business `kubectl get po -n piecloud-business | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n piecloud-image-search `kubectl get po -n piecloud-image-search | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n piecloud-infra `kubectl get po -n piecloud-infra | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n piecloud-system `kubectl get po -n piecloud-system | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n pie-engine-ai `kubectl get po -n pie-engine-ai | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n pie-engine-bpaas `kubectl get po -n pie-engine-bpaas | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n pie-engine-common `kubectl get po -n pie-engine-common | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n pie-engine-infra `kubectl get po -n pie-engine-infra | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n pie-engine-job-ai `kubectl get po -n pie-engine-job-ai | grep ${s} | awk '{ print $1 }'`
    #kubectl delete po -n pie-engine-server `kubectl get po -n pie-engine-server | grep ${s} | awk '{ print $1 }'`
    for n in ${namespaces}
    do
        kubectl get pods -n ${n} | grep ${s} | awk '{print $1}' | xargs kubectl delete pods  -n ${n}
    done
done
