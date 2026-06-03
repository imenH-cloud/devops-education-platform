UPDATE users 
SET password = '$2b$10$VfNH7ywsXGo0wvr5D3r9b.kFiDuQGQJ0qGZM8pIAYJL6dN5qJ.8nC'
WHERE email = 'admin@school.com';
SELECT email, password FROM users WHERE email = 'admin@school.com';
