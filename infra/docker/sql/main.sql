-- Main SQL
-- Written by NLH
-- howto

DROP DATABASE IF EXISTS howto;

CREATE DATABASE IF NOT EXISTS howto CHARACTER SET UTF8mb4 COLLATE utf8mb4_bin;

USE howto;

-- Users ----------------------------------
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id VARCHAR(36) PRIMARY KEY,
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

-- User Profiles ----------------------------------
DROP TABLE IF EXISTS user_profiles;

CREATE TABLE user_profiles (
  user_id VARCHAR(36) PRIMARY KEY,
  display_name VARCHAR(100) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  birth_date DATE,
  phone VARCHAR(30),
  image_url VARCHAR(512),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- User OTPs ----------------------------------
DROP TABLE IF EXISTS user_otps;

CREATE TABLE user_otps (
  id VARCHAR(36) PRIMARY KEY,
  email VARCHAR(50) NOT NULL,
  otp VARCHAR(10) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME
);

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
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  category_id INT UNSIGNED NOT NULL,
  title VARCHAR(30) UNIQUE NOT NULL,
  image_url VARCHAR(512),
  view_count INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES content_categories(id)
);

-- Content Htmls ----------------------------------
DROP TABLE IF EXISTS content_htmls;

CREATE TABLE content_htmls (
  content_id VARCHAR(36) NOT NULL,
  order_no SMALLINT NOT NULL,
  html TEXT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  PRIMARY KEY(content_id, order_no),
  FOREIGN KEY (content_id) REFERENCES contents(id) ON DELETE CASCADE
);

-- -- Content images ----------------------------------
-- DROP TABLE IF EXISTS content_images;

-- CREATE TABLE content_images (
--   content_id VARCHAR(36) NOT NULL,
--   order_no SMALLINT NOT NULL,
--   image_url VARCHAR(512) NOT NULL,
--   created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
--   updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
--   deleted_at DATETIME,
--   PRIMARY KEY(content_id, order_no),
--   FOREIGN KEY (content_id) REFERENCES contents(id) ON DELETE CASCADE
-- );

-- User Favourites ----------------------------------
DROP TABLE IF EXISTS user_favourites;

CREATE TABLE user_favourites (
  user_id VARCHAR(36) NOT NULL,
  content_id VARCHAR(36) NOT NULL,
  is_favourite BOOLEAN NOT NULL DEFAULT false,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  PRIMARY KEY(user_id, content_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (content_id) REFERENCES contents(id)
);

-- Inserts

INSERT INTO users VALUES 
  ('1', 'admin@gmail.com',   '$2a$10$iQi3rBDCcdeXsUIH3NqJUunv9DpAiR3AQGRLbeBfo3OASpRqfCIta', 'creator', 'admin', 'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL),
  ('2', 'test@gmail.com',    '$2a$10$iQi3rBDCcdeXsUIH3NqJUunv9DpAiR3AQGRLbeBfo3OASpRqfCIta', 'viewer',  'user',  'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL),
  ('3', 'creator@gmail.com', '$2a$10$iQi3rBDCcdeXsUIH3NqJUunv9DpAiR3AQGRLbeBfo3OASpRqfCIta', 'creator', 'user',  'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL)
;

INSERT INTO user_profiles VALUES 
  ('1', 'admin',       'Admin',        '2008-09-10 15:00:00', NULL,          '/api/file/media/1669997499-jaws.jpg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL),
  ('2', 'david2000',   'DavidViewer',  '2008-09-10 15:00:00', '08077778888', '/api/file/media/1669997499-jaws.jpg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL),
  ('3', 'creator2000', 'DavidCreator', '2009-09-10 15:00:00', '08077778888', '/api/file/media/1669997499-jaws.jpg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL)
;

INSERT INTO content_categories VALUES 
  (1, 'cooking',    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL),
  (2, 'traveling',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL),
  (3, 'technology', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL),
  (4, 'knowledge',  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL),
  (5, 'religion',   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL),
  (6, 'history',    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL)
;