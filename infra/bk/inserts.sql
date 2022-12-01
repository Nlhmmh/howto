USE howto;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `users`;
TRUNCATE TABLE `content_categories`;
TRUNCATE TABLE `contents`;
TRUNCATE TABLE `content_childs`;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO `users` VALUES 
(1, 'admin',       'Admin',        '2008-09-10 15:00:00', NULL,          'admin@gmail.com',   '$2a$10$aLgsUMlEX.PhkhnW9o9RvePh.H/pKrUoKN8OlnKp1z5WxU8pAzxAW', 'creator', 'admin', 'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL),
(2, 'david2000',   'DavidViewer',  '2008-09-10 15:00:00', '08077778888', 'test@gmail.com',    '$2a$10$aLgsUMlEX.PhkhnW9o9RvePh.H/pKrUoKN8OlnKp1z5WxU8pAzxAW', 'viewer',  'user',  'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL),
(3, 'creator2000', 'DavidCreator', '2009-09-10 15:00:00', '08077778888', 'creator@gmail.com', '$2a$10$jpbNnmmqSoFdCHQyoa8Q7.Q.uzGqDLu9dhPK6rIsEjq7huKHh4IuC', 'creator', 'user',  'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL)
;

-- ===========================================
-- INSERT INTO contents(user_id, title, category, created_at, updated_at) VALUES
-- (1002, '3 Simple Ways To Grill Chicken', 'cooking', CURRENT_TIMESTAMP, NOW() - INTERVAL 1 MINUTE),
-- (1002, 'Making a Simple Handmade Box', 'handcrafts', CURRENT_TIMESTAMP, NOW() - INTERVAL 1 HOUR),
-- (1002, 'How to Drive a Truck', 'education', CURRENT_TIMESTAMP, NOW() - INTERVAL 1 DAY),
-- (1002, 'The History of Bagan Kingdom', 'knowledge', CURRENT_TIMESTAMP, NOW() - INTERVAL 1 MONTH),
-- (1002, 'How to Read Spanish', 'education', CURRENT_TIMESTAMP, NOW() - INTERVAL 2 MONTH),
-- (1002, 'Modern Home Decoration', 'knowledge', CURRENT_TIMESTAMP, NOW() - INTERVAL 1 YEAR);