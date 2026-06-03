UPDATE users 
SET password = '$2b$10$b6ESAnq3vOl.yXuBpmwm.eJwCbJ4L6RXr4jTPHscAWxIe04USh7nu'
WHERE email = 'admin@school.com';
SELECT email, password FROM users WHERE email = 'admin@school.com';
