-- Main SQL
-- Written by NLH
-- howto

DROP DATABASE IF EXISTS howto;

CREATE DATABASE IF NOT EXISTS howto CHARACTER SET UTF8mb4 COLLATE utf8mb4_bin;

USE howto;

-- Users ----------------------------------
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  display_name VARCHAR(100) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  birth_date DATE,
  phone VARCHAR(30),
  email VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(200) NOT NULL,
  type ENUM('creator', 'viewer') NOT NULL DEFAULT 'viewer',
  role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
  status ENUM(
    'temporary',
    'active',
    'suspended',
    'deactivated'
  ) NOT NULL DEFAULT 'temporary',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME
);

ALTER TABLE users AUTO_INCREMENT = 1;

-- Content Categories ----------------------------------
DROP TABLE IF EXISTS content_categories;

CREATE TABLE content_categories (
  id INT UNSIGNED PRIMARY KEY,
  name VARCHAR(30) UNIQUE NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME
);

-- Contents ----------------------------------
DROP TABLE IF EXISTS contents;

CREATE TABLE contents (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  category_id INT UNSIGNED NOT NULL,
  title VARCHAR(30) NOT NULL,
  view_count INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES content_categories(id)
);

ALTER TABLE contents AUTO_INCREMENT = 1;

-- Content Childs ----------------------------------
DROP TABLE IF EXISTS content_childs;

CREATE TABLE content_childs (
  content_id INT UNSIGNED NOT NULL,
  order_no SMALLINT NOT NULL,
  html TEXT NOT NULL,
  image_url VARCHAR(512) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  PRIMARY KEY(content_id, order_no),
  FOREIGN KEY (content_id) REFERENCES contents(id) ON DELETE CASCADE
);
