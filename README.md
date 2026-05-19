# springcloud 配置仓库

各微服务配置文件命名：**`{服务名}-{环境/Profile}.yml`**

| 文件 | 说明 | 对应微服务启动 Profile |
|------|------|------------------------|
| `user-dev.yml` | 用户服务公共配置 | `dev` |
| `user-9001.yml` | 用户服务 9001 端口 | `dev,9001` |
| `user-9101.yml` | 用户服务 9101 端口 | `dev,9101` |
| `web-dev.yml` | Web 购票服务 | `dev` |
| `gateway-dev.yml` | API 网关 | `dev` |
| `eureka-dev.yml` | Eureka 公共配置 | `dev` |
| `eureka-8888.yml` | Eureka 节点 8888 | `dev,8888` |
| `eureka-9999.yml` | Eureka 节点 9999 | `dev,9999` |
| `admin-dev.yml` | Spring Boot Admin | `dev` |

## 推送到 GitHub

```bash
cd springcloud
git init
git add .
git commit -m "init: spring cloud config files"
git branch -M main
git remote add origin https://github.com/<你的用户名>/springcloud.git
git push -u origin main
```

推送后，在 **myshop-config** 的 `application.yml` 中将 `spring.cloud.config.server.git.uri` 改为你的 GitHub 地址。

## Config Server 拉取名称

各微服务 `bootstrap.yml` 中 `spring.cloud.config.name` 与上表「服务名」一致（如 `user`、`web`、`gateway`）。
