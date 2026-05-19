# 实验：修改 Git 配置并使其生效

## 1. 准备 3307 数据库（Ubuntu Docker + centos/mysql-57-centos7）

该镜像**不能**只写 `MYSQL_ROOT_PASSWORD` + `MYSQL_DATABASE`，需**同时**提供 `MYSQL_USER`、`MYSQL_PASSWORD`、`MYSQL_DATABASE`：

```bash
docker rm -f mysql-3307

docker run -d \
  --name mysql-3307 \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -e MYSQL_USER=myshop \
  -e MYSQL_PASSWORD=123456 \
  -e MYSQL_DATABASE=myshop_user_db \
  -v mysql3307_data:/var/lib/mysql \
  centos/mysql-57-centos7

docker ps
docker logs mysql-3307 --tail 10
```

微服务仍用 **root / 123456** 连接即可（与 `user-dev.yml` 一致）。再执行 `sql/init-3307-different-data.sql` 写入与 3306 不同的数据。

## 2. 修改配置并提交 Git

已修改 `user-dev.yml` 中数据源端口：`3306` → **`3307`**。

```bash
cd D:\learn\myshop-parent\springcloud
git add user-dev.yml sql/
git commit -m "feat: user datasource switch to MySQL 3307"
git push origin main
```

## 3. 在 Config 服务端查看是否生效

1. 启动 **myshop-config**（12000）。
2. 浏览器访问（拉取的是 Git 上**最新**配置）：

   `http://localhost:12000/user/dev`

3. 在返回 JSON 中搜索 `3307`，应能看到：

   `jdbc:mysql://...:3307/myshop_user_db...`

说明 **Config Server 已从 Git 读到新配置**（若仍是 3306，执行 `git push` 后重启 myshop-config，或等待 Git 后端刷新）。

## 4. 思考：运行中的用户微服务如何使新配置生效？

| 方式 | 说明 |
|------|------|
| **重启 myshop-user** | 最简单；启动时重新从 Config Server 拉取 `user-dev.yml`，数据源指向 3307。 |
| **`POST /actuator/refresh`** | 需引入 `spring-boot-starter-actuator`，并暴露 `refresh`；**仅对带 `@RefreshScope` 的 Bean 有效**，**数据源连接池一般仍需重启**才能换库。 |
| **Spring Cloud Bus** | Config 变更后向消息总线发送刷新事件，各客户端监听后批量 `/refresh`；生产常用 RabbitMQ/Kafka + `spring-cloud-starter-bus-amqp`。 |

**本实验验证换库**：修改 Git 并 push → 确认 `12000/user/dev` 已为 3307 → **重启 myshop-user** → 访问 `http://localhost:9001/user`，数据应与 3306 库不同。

## 5. 对比测试

| 步骤 | 操作 |
|------|------|
| A | `user-dev.yml` 为 **3306**，重启 user，记录 `GET /user` 结果 |
| B | 改为 **3307** 并 push，确认 Config Server JSON 已变，重启 user，再 `GET /user` |
| C | 两次结果不同 → 证明配置来自远程且已切换数据源 |
