## User Authentication & Authorization

副本集开启内部认证后会自动开启用户访问控制（User Access Control），所以需要创建用户，主要需要创建三种用户：

- Administrator：有权限创建其他用户
- Cluster Administrator：有权限操作副本集和Shard
- Additional User：客户端用户

### Administrator

#### 创建

```javascript
db.getSiblingDB("admin").createUser(
    {
        user: "admin",
        pwd: "123",
        roles: [{role: "userAdminAnyDatabase", db: "admin"}]
    }
)

// OR
use admin
db.createUser(
    {
        user: "admin",
        pwd: "123",
        roles: [{role: "userAdminAnyDatabase", db: "admin"}]
    }
)
```

#### 登录

```javascript
db.getSiblingDB("admin").auth("admin", "123")
```

OR by shell

```shell
mongo -u "admin" -p "123" --authenticationDatabase "admin"
```

### Cluster Administrator

```javascript
db.getSiblingDB("admin").createUser(
    {
        "user": "cadmin",
        "pwd": "123",
        roles: [{"role": "clusterAdmin", "db": "admin"}]
    }
)
```

### Additional User

```javascript
 db.getSiblingDB("test_db").createUser(
    {
        "user": "user",
        "pwd": "123",
        roles: [{"role": "readWrite", "db": "test_db"}]
    }
)
```

- [Add User](https://www.mongodb.com/docs/v4.0/tutorial/create-users/)
- [Deploy New Replica Set With Keyfile Access Control](https://www.mongodb.com/docs/v4.0/tutorial/deploy-replica-set-with-keyfile-access-control/#deploy-repl-set-with-auth)