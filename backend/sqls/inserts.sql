INSERT INTO
  `howto`.`system_users` (
    `id`,
    `login_name`,
    `password`,
    `role`,
    `created_at`,
    `updated_at`,
    `deleted_at`
  )
VALUES
  (
    0,
    'howto',
    'admin',
    'admin',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    null
  );
-- ===========================================
INSERT INTO
  `howto`.`users` (
    `display_name`,
    `first_name`,
    `last_name`,
    `email`,
    `password`,
    `is_admin`,
    `account_type`,
    `account_status`
  )
VALUES
  (
    'test',
    'test',
    'test',
    'test@gmail.com',
    '1111',
    TRUE,
    'creater',
    'active'
  );
-- ===========================================
INSERT INTO
  contents(user_id, title, category)
VALUES(1, 'A Nice Way To Chill', 'cooking');