#!/bin/bash
#author:chenbin

set -e

NPM_BUILD_ZIP="dist.tar.gz"

# 远程服务部署目录
REMOTE_DEPLOY_DIR="/data/resources/knowledge-build-test"
REMOTE_IP="120.46.152.174"
REMOTE_PWD="Htht@cce-dev-bpaas"
REMOTE_USER="root"

cd `dirname $0`
BIN_DIR=`pwd`
#cd ../

DEPLOY_DIR=`pwd`
TARGET_DIR=$DEPLOY_DIR/dist

# 定义该脚本的临时文件的名字
TmpFileName=/tmp/sp_sh_tmp

# 先把原来的这个脚本的临时文件删除
rm -rf ${TmpFileName}*

# 获取当前时间
Time=`date +"%Y%m%d%H%M%S"`

# 判断TARGET目录是否存在, 不存在则创建
if [ ! -d "$TARGET_DIR" ];then
    mkdir $TARGET_DIR
else
    echo "$TARGET_DIR 目录已经存在"
fi

echo "[Start npm build...]"
rm -rf $TARGET_DIR/*

# 把npm run命令的结果在屏幕显示的同时写入到文件中, 文件名为:上面定义的文件名+当前时间
npm run build-dev | tee ${TmpFileName}${Time}

# 文件中查找 "Build complete" 关键字
result=`grep 'Build complete' ${TmpFileName}${Time}`

# 如果结果为空那就是失败, 否则就成功了
if [ -z "$result" ];
then
  echo "[npm build ERROR!] "
  echo "[ ------------------------ script exit!! ------------------- ] "
  exit 1
else
  echo "[npm build SUCCESS] "
  echo ""
fi

# 将npm build的文件进行打包
echo "当前目录: `pwd`"
rm -rf $TARGET_DIR/$NPM_BUILD_ZIP

cd $TARGET_DIR
echo "开始打包: tar czvf $NPM_BUILD_ZIP *"
tar czvf $NPM_BUILD_ZIP *
chown 777 $NPM_BUILD_ZIP
echo "打包完成"
echo ""

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

# 远程拷贝文件
echo "开始拷贝文件到远程服务器($REMOTE_HOST),如果未安装sshpass,需要输入宿主机密码"
if ! [ -x "$(command -v sshpass)" ];
then
  echo 'Error: sshpass is not installed.' >&2

  echo "拷贝文件: scp $TARGET_DIR/$NPM_BUILD_ZIP $REMOTE_HOST:$REMOTE_DEPLOY_DIR"
  scp $TARGET_DIR/$NPM_BUILD_ZIP $REMOTE_HOST:$REMOTE_DEPLOY_DIR
else
  echo "拷贝文件: sshpass -p $REMOTE_PWD scp $TARGET_DIR/$NPM_BUILD_ZIP $REMOTE_HOST:$REMOTE_DEPLOY_DIR"
  sshpass -p $REMOTE_PWD scp $TARGET_DIR/$NPM_BUILD_ZIP $REMOTE_HOST:$REMOTE_DEPLOY_DIR
fi

# 登录远程机器操作命令
echo ""
echo "登录$REMOTE_HOST部署服务,如果未安装sshpass,需要再次输入宿主机密码"

if ! [ -x "$(command -v sshpass)" ];
then
  echo 'Error: sshpass is not installed.' >&2

ssh $REMOTE_HOST << remotessh
  cd $REMOTE_DEPLOY_DIR
  ls | grep -v $NPM_BUILD_ZIP | xargs rm -rf
  tar zxvf $NPM_BUILD_ZIP
  chmod -R 777 *
remotessh
else
sshpass -p $REMOTE_PWD ssh $REMOTE_HOST << remotessh
  cd $REMOTE_DEPLOY_DIR
  ls | grep -v $NPM_BUILD_ZIP | xargs rm -rf
  tar zxvf $NPM_BUILD_ZIP
  chmod -R 777 *
remotessh
fi

echo "部署成功!!!"
