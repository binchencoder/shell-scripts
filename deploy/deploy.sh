#!/bin/bash
#author:chenbin

set -e
# 永不超时  set time  10  执行10秒
set timeout -1

APP_VERSION="1.0.0"
APP_NAME="knowledge-build-server"
APP="$APP_NAME-$APP_VERSION"

# 远程服务部署目录
REMOTE_DEPLOY_DIR="/home/svn/cloudtest/bpaas/knowledge-build-test"
REMOTE_IP="120.46.152.174"
REMOTE_PWD="Htht@cce-dev-bpaas"
REMOTE_USER="root"

cd `dirname $0`
BIN_DIR=`pwd`
cd ../../

DEPLOY_DIR=`pwd`
TARGET_DIR=$DEPLOY_DIR/$APP_NAME/target

# 定义该脚本的临时文件的名字
TmpFileName=/tmp/sp_sh_tmp

# 先把原来的这个脚本的临时文件删除
rm -rf ${TmpFileName}*

# 获取当前时间
Time=`date +"%Y%m%d%H%M%S"`
PKG_LOG=${TmpFileName}${Time}

echo "[Start maven package...]"
# 把mvn命令的结果在屏幕显示的同时写入到文件中, 文件名为:上面定义的文件名+当前时间
mvn clean package -Dmaven.test.skip -P test | tee ${PKG_LOG}

# 文件中查找 "BUILD SUCCESS" 关键字
result=`grep 'BUILD SUCCESS' ${PKG_LOG}`

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

# 提示用户输入用户名
read -p "输入您的登录用户名: " INPUT_USER
if  [ ! -n "$INPUT_USER" ];
then
    echo "you have not input a login user!"
else
    echo "the login user you input is: $INPUT_USER"
    REMOTE_USER=${INPUT_USER}
fi

# 如果本地安装了sshpass, 则提示输入密码
if [ -x "$(command -v sshpass)" ];
then
  read -p "输入您的登录密码: " INPUT_PWD

  if  [ -n "$INPUT_PWD" ]; then
    echo "the login user's password you input is: $INPUT_PWD"
    REMOTE_PWD=$INPUT_PWD
  fi
fi
REMOTE_HOST="$REMOTE_USER@$REMOTE_IP"

chown 777 $TARGET_DIR/$APP.jar
# 远程拷贝文件
echo "开始拷贝文件到远程服务器($REMOTE_HOST),如果未安装sshpass,需要输入宿主机密码"
if ! [ -x "$(command -v sshpass)" ];
then
  echo 'WARN: sshpass is not installed.' >&2

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
  echo 'WARN: sshpass is not installed.' >&2

ssh $REMOTE_HOST << remotessh
  cd $REMOTE_DEPLOY_DIR
  chown -R 777 *
  ./install.sh
remotessh
else
sshpass -p $REMOTE_PWD ssh $REMOTE_HOST << remotessh
  cd $REMOTE_DEPLOY_DIR
  chown -R 777 *
  ./install.sh
remotessh
fi

echo "部署成功!!!"