-- Bcrypt hash for 'admin12345' with 10 salt rounds
-- Generated using: bcryptjs.hash('admin12345', 10)
UPDATE users 
SET password = '$2a$10$WB/pZpLZkLQhvHV89VDPCuP1R.4cj1ZPLP1D8dOVqvg5xQqhZPSWq'
WHERE email = 'admin@school.com';
