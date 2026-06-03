-- Hash bcrypt pour admin12345 (salt rounds 10)
UPDATE users 
SET password = '$2b$10$3b.r4PaJr6a5zHPVNRiJNO.wPqJQ6rY5ZjK9c3N2mL1qN8pQ7sK9e'
WHERE email = 'admin@school.com';
SELECT id, email, password FROM users WHERE email = 'admin@school.com';
