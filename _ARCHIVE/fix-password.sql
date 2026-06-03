-- Update password to match what the gateway expects
-- Password hash for: admin12345 (bcrypt with 10 salt rounds)
UPDATE users 
SET password = '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86xNDj4Ew.2'
WHERE email = 'admin@school.com';
SELECT email, password FROM users WHERE email = 'admin@school.com';
