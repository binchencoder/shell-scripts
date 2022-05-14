#!/bin/bash
#author:chenbin

set -e

APP_VERSION="1.0.0"
APP="knowledge-build-server-$APP_VERSION"

# 远程服务部署目录
REMOTE_DEPLOY_DIR="/home/svn/cloudtest/bpaas/knowledge-build"
REMOTE_PWD="Htht@cce-dev-bpaas"
REMOTE_HOST="root@120.46.152.174"

cd `dirname $0`
BIN_DIR=`pwd`
cd ../../

DEPLOY_DIR=`pwd`
TARGET_DIR=$DEPLOY_DIR/knowledge-build-server/target

# 定义该脚本的临时文件的名字
TmpFileName=/tmp/sp_sh_tmp

# 先把原来的这个脚本的临时文件删除
rm -rf ${TmpFileName}*

# 获取当前时间
Time=`date +"%Y%m%d%H%M%S"`

echo "[Start maven package...]"
# 把mvn命令的结果在屏幕显示的同时写入到文件中, 文件名为:上面定义的文件名+当前时间
mvn clean package -Dmaven.test.skip -P test | tee ${TmpFileName}${Time}

# 文件中查找 "BUILD SUCCESS" 关键字
result=`grep 'BUILD SUCCESS' ${TmpFileName}${Time}`

# 如果结果为空那就是失败, 否则就成功了
if [ -z "$result" ];
then
  echo "[maven package ERROR!] "
  echo "[ ------------------------ script exit!! ------------------- ] "
  exit 1
else
  echo "[maven package SUCCESS] "
  echo ""
fi

# 远程拷贝文件
echo "开始拷贝文件到远程服务器($REMOTE_HOST),如果未安装sshpass,需要输入宿主机密码"
if ! [ -x "$(command -v sshpass)" ];
then
  echo 'Error: sshpass is not installed.' >&2

  echo "拷贝文件: scp $TARGET_DIR/$APP.jar $REMOTE_HOST:$REMOTE_DEPLOY_DIR"
  scp $TARGET_DIR/$APP.jar $REMOTE_HOST:$REMOTE_DEPLOY_DIR
else
  echo "拷贝文件: sshpass -p $REMOTE_PWD scp $TARGET_DIR/$APP.jar $REMOTE_HOST:$REMOTE_DEPLOY_DIR"
  sshpass -p $REMOTE_PWD scp $TARGET_DIR/$APP.jar $REMOTE_HOST:$REMOTE_DEPLOY_DIR
fi

# 登录远程机器操作命令
echo ""
echo "登录$REMOTE_HOST部署服务,如果未安装sshpass,需要再次输入宿主机密码"

if ! [ -x "$(command -v sshpass)" ];
then
  echo 'Error: sshpass is not installed.' >&2

ssh $REMOTE_HOST << remotessh
  cd $REMOTE_DEPLOY_DIR
  ./install.sh
remotessh
else
sshpass -p $REMOTE_PWD ssh $REMOTE_HOST << remotessh
  cd $REMOTE_DEPLOY_DIR
  ./install.sh
remotessh
fi

echo "部署成功!!!"

