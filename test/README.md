# Linux shell test samples

## awk

[linux-comm-awk](https://www.runoob.com/linux/linux-comm-awk.html)

```shell
chenbin@chenbin:~/github_workspace/shell-scripts/test$ awk -F, '{print $1,$2}'   log.txt
2 this is a test 
3 Do you like awk 
This's a test 
10 There are orange apple

chenbin@chenbin:~/github_workspace/shell-scripts/test$ awk 'BEGIN{FS=","} {print $1,$2}'     log.txt
2 this is a test 
3 Do you like awk 
This's a test 
10 There are orange apple
```

## Select

[Bash技巧：详解用select复合命令的用法，可提供选择菜单项](https://segmentfault.com/a/1190000021187291)

```shell
$ IFS=/
$ animal_list="big lion/small tiger"
$ select animal in $animal_list; do echo "Choose: $animal"; break; done
1) big lion
2) small tiger
#? 1
Choose: big lion
$ select animal in big lion/small tiger; do echo "Choose: $animal"; break; done
1) big
2) lion/small
3) tiger
#? 2
Choose: lion/small
```

