DELETE FROM users WHERE email='admin@school.com';
INSERT INTO users (email, "firstName", "lastName", password, "saltRounds", active, "createdAt", "updatedAt")
VALUES ('admin@school.com', 'Admin', 'User', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86xNDj4Ew.2', 10, true, NOW(), NOW());
SELECT email, password FROM users WHERE email='admin@school.com';
