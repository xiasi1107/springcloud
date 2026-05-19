-- 3307 库：同名 myshop_user_db，表结构与 3306 一致，数据不同
-- Navicat 连接 192.168.150.128:3307 后，选中 myshop_user_db 执行本脚本

CREATE DATABASE IF NOT EXISTS myshop_user_db
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE myshop_user_db;

-- 与 JPA 实体 @Table(name = "orbit_user_account") 对应（必须先建表再 INSERT）
CREATE TABLE IF NOT EXISTS orbit_user_account (
  id INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(255) DEFAULT NULL,
  password VARCHAR(255) DEFAULT NULL,
  sex VARCHAR(255) DEFAULT NULL,
  money DOUBLE DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3307 差异化数据（与 3306 区分）
DELETE FROM orbit_user_account;

INSERT INTO orbit_user_account (username, password, sex, money) VALUES
('user3307_a', 'pwd', '男', 100.0),
('user3307_b', 'pwd', '女', 200.0);
