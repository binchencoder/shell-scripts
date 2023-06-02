#!/bin/sh

# 在 shell 脚本中，可以使用 -z 选项来判断一个字符串是否为空。如果字符串为空，则该条件返回 true，否则返回 false。例如，以下代码片段演示了如何检查一个字符串是否为空：

if [ -z "$my_string" ]; then
   echo "my_string is empty"
else
   echo "my_string is not empty"
fi

# 在上面的代码中，$my_string 是一个变量，我们使用 -z 选项来检查它是否为空。如果 $my_string 为空，则输出 my_string is empty，否则输出 my_string is not empty。
# 另外，如果你想判断一个字符串是否非空，可以使用 -n 选项。例如：


if [ -n "$my_string" ]; then
   echo "my_string is not empty"
else
   echo "my_string is empty"
fi

# 这样就可以判断 $my_string 是否非空了。