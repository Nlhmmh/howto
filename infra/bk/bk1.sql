-- Main SQL
-- Written by NLH
-- howto
DROP DATABASE IF EXISTS howto;

CREATE DATABASE IF NOT EXISTS howto CHARACTER SET UTF8mb4 COLLATE utf8mb4_bin;

USE howto;

-- System Users
DROP TABLE IF EXISTS system_users;

CREATE TABLE system_users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  login_name VARCHAR(30) NOT NULL,
  password VARCHAR(200) NOT NULL,
  role ENUM('admin', 'staff') NOT NULL DEFAULT 'staff',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

ALTER TABLE
  system_users AUTO_INCREMENT = 1;

-- Users
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  display_name VARCHAR(30) NOT NULL,
  name VARCHAR(30) NOT NULL,
  birth_date TIMESTAMP,
  phone VARCHAR(30),
  email VARCHAR(50),
  password VARCHAR(200) NOT NULL,
  is_admin BOOL NOT NULL DEFAULT FALSE,
  account_type ENUM('creator', 'viewer') NOT NULL DEFAULT 'viewer',
  account_status ENUM(
    'temporary',
    'active',
    'suspended',
    'deactivated'
  ) NOT NULL DEFAULT 'temporary',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

ALTER TABLE
  users AUTO_INCREMENT = 1001;

-- Contents
DROP TABLE IF EXISTS contents;

CREATE TABLE contents (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  title VARCHAR(30) NOT NULL,
  category ENUM(
    'cooking',
    'handcrafts',
    'education',
    'knowledge'
  ) NOT NULL,
  view_count INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

ALTER TABLE
  contents AUTO_INCREMENT = 1;

-- Images
DROP TABLE IF EXISTS images;

CREATE TABLE images (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  content_id INT UNSIGNED NOT NULL,
  order_no SMALLINT NOT NULL,
  file_type VARCHAR(20) NOT NULL,
  data LONGBLOB NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (content_id) REFERENCES contents(id) ON DELETE CASCADE
);

ALTER TABLE
  images AUTO_INCREMENT = 1;

-- Texts
DROP TABLE IF EXISTS texts;

CREATE TABLE texts (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  content_id INT UNSIGNED NOT NULL,
  order_no SMALLINT NOT NULL,
  text VARCHAR(300) NOT NULL,
  font_size TINYINT NOT NULL DEFAULT 14,
  is_bold BOOL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  FOREIGN KEY (content_id) REFERENCES contents(id) ON DELETE CASCADE
);

ALTER TABLE
  texts AUTO_INCREMENT = 1;