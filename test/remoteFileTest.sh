#/bin/bash
# 使用此脚本前必须在本机运行 【ssh-keygen】生成公私密钥文件，然后用【ssh-copy-id -i 本机公钥文件 远程用户名@远程IP】将本机公钥给远程主机
#

remoteIp=""
remoteFile=$2

echo "入参1：${remoteIp}"
echo "入参2：${remoteFile}"

if [[ -n ${remoteIp} && -n ${remoteFile} ]]; then
        if (ssh root@${remoteIp} test -e ${remoteFile});then
                echo "存在文件${remoteFile}在远程主机${remoteIp}中"
        else
                echo "不存在文件${remoteFile}在远程主机${remoteIp}中"
        fi
else
        echo "用法: sh $0 远程主机IP 远程主机文件的绝对路径"
fi