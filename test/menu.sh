#!/bin/bash
 
echo "1.查看剩余内存容量."
echo "2.查看根分区剩余容量."
echo "3.查看CPU十五分钟负载."
echo "4.查看系统进程数量."
echo "5.查看系统账户数量."
echo "6.退出."
 
while :
do
  read -p "请输入[1-6]:" key
  case $key in
1)
  free | awk '/Mem/{print $NF}';;
2)
  df | awk '/\/$/{print $4}';;
3) 
  uptime | awk '{print $NF}';;
4)
  ps aux | wc -l ;;
5)
  sed -n '$=' /etc/passwd ;;
6) exit
esac
done