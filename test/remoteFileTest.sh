#/bin/bash
# 使用此脚本前必须在本机运行 【ssh-keygen】生成公私密钥文件，然后用【ssh-copy-id -i 本机公钥文件 远程用户名@远程IP】将本机公钥给远程主机
#

REMOTE_HOST="root@120.46.152.174"
REMOTE_DIR="/home/svn/cloudtest/bpaas/knowledge-build-test"

echo "入参1：${REMOTE_HOST}"
echo "入参2：${REMOTE_DIR}"

# if (ssh ${REMOTE_IP} test -e ${REMOTE_DIR});then
# if [[ `ssh $REMOTE_HOST test -d $REMOTE_DIR && echo exists` ]]; then
if [[ `ssh $REMOTE_HOST test -d $REMOTE_DIR` ]]; then
  echo "存在文件$REMOTE_DIR在远程主机$REMOTE_HOST中"
else
  echo "不存在文件$REMOTE_DIR在远程主机$REMOTE_HOST中"
fi
