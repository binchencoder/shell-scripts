shell函数的返回值，仅支持return返回整数，尝试返回字符串：

```
#!/bin/sh

get_str()
{
	return "string"
}

get_str
echo $?
```

输出如下：
```
./test.sh: line 5: return: string: numeric argument required
255
```

可以看到已经提示要求return 整数类型，真实返回值是255。


https://blog.csdn.net/zycamym/article/details/45191093