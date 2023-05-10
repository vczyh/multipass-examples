## 创建

### 启动虚拟机

1. 执行`render.py`生成`cloud-init`文件
2. 启动数据节点
```shell
 mp launch bionic -n mongodb-rs-1  -c 1 -m 2G -d 10G --cloud-init datanode-1-install.yaml
 mp launch bionic -n mongodb-rs-2  -c 1 -m 2G -d 10G --cloud-init datanode-2-install.yaml
 mp launch bionic -n mongodb-rs-3  -c 1 -m 2G -d 10G --cloud-init datanode-3-install.yaml
```


### 创建副本集

```js
rs.initiate( {
   _id : "rs0",
   members: [
      { _id: 1, host: "192.168.64.42:27017" },
      { _id: 2, host: "192.168.64.43:27017" },
      { _id: 3, host: "192.168.64.44:27017" }
   ]
})
```

### 查看配置

```js
rs.conf()
```

### 查看状态

```js
rs.status()
```

### 插入数据

```js
use test_db
db.foo.insert({"name":"test1"})
```

## 测试

### 切换和数据同步

- node-1（Primary）插入数据
- 关闭node-1，node-2会成为Primary
- 启动node-1,此时node-1作为Secondary加入副本集
- 在node-2上插入数据，在node-1和node-3上查看


