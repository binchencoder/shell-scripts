#!/bin/sh

# shell函数的返回值，仅支持return返回整数，尝试返回字符串:

get_str(){
	echo "string"
}

#写法一
echo `get_str`

#写法二
echo $(get_str)