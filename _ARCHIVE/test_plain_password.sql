-- First, let's check what data format is expected
-- Update with plain password temporarily to see what happens
UPDATE users 
SET password = 'admin12345', "saltRounds" = ''
WHERE email = 'admin@school.com';
