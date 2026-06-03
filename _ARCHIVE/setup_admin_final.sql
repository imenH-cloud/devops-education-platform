SELECT setval('users_id_seq', 10);
DELETE FROM users WHERE email = 'admin@school.com';
INSERT INTO users (email, password, "firstName", "lastName", active) 
VALUES ('admin@school.com', 'admin12345', 'Admin', 'School', true);
SELECT id, email, password FROM users WHERE email = 'admin@school.com';
