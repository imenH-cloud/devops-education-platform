DELETE FROM users;
INSERT INTO users (email, password, "firstName", "lastName", active) 
VALUES ('admin@school.com', '$2b$10$VfNH7ywsXGo0wvr5D3r9b.kFiDuQGQJ0qGZM8pIAYJL6dN5qJ..nC', 'Admin', 'User', true);
SELECT email, password FROM users;
