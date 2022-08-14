# kubepod.sh

`kubepod.sh` 基于`kubectl` 命令封装，操作k8s的脚本，可以安全高效的访问k8s。只提供对k8s的访问命令，不提供删除的操作

`kubepod.sh` 支持以下操作

### 查看Pod列表

```shell
sh kubepod.sh pods
```

> 等同于 kubectl get pods -A

### 查看Svc列表

```shell
sh kubepod.sh svcs
```

> 等同于 kubectl get svc -A

### 查看Deployment列表

```
```

