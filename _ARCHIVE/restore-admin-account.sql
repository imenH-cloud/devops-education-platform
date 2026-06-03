-- Restauration du compte admin original + données complètes
-- Admin account: admin@school.com / admin12345

-- 1. Restaurer le compte admin
DELETE FROM users WHERE email = 'admin@school.com';
INSERT INTO users (email, password, "firstName", "lastName", active) 
VALUES ('admin@school.com', '$2b$10$sUd5PNEIskHsdJdN0KY/WuCfa/UEQRNNJaMoicghz61GXvoX1K9Ri', 'Admin', 'School', true)
ON CONFLICT (email) DO NOTHING;

-- 2. Restaurer les PARENTS avec leurs données
DELETE FROM parent WHERE id IN (1, 2);
INSERT INTO parent (id, "firstName", "lastName", email, "phoneNumber", "NCIN", address, "typeInsurance", "Numeroinsurance", job) 
VALUES 
(1, 'Ahmed', 'Ben Salah', 'ahmed.bensalah@example.com', '22112233', '12345678', 'Rue de Tunis, Ariana', 'CNAM', 'INS123456789', 'Enseignant'),
(2, 'houda', 'rouissi', 'houdaR@gmail.com', '50987654', '7564534', 'TOZEUR', 'CNAM', '887654345678', 'enseignant');

-- 3. Restaurer les CLASSROOMS
DELETE FROM classroom WHERE id = 1;
INSERT INTO classroom (id, name, capacity, grade, description, "academicYear", "isActive", location, "Specialization") 
VALUES (1, 'educationSssspcial i sé', 8, '1', 'classe des autistes 1', '', true, 'classe1', 'autisme');

-- 4. Restaurer les STUDENTS
DELETE FROM student WHERE id = 1;
INSERT INTO student (id, "firstName", "numeroInscriptio", "lastName", email, "phoneNumber", address, "isActive", "parentId", "classroomId", "dateOfBirth", "enrollmentDate") 
VALUES (1, 'nada', '', 'salhi', '', '9054534343', 'hammet jarid', true, 2, NULL, '2025-06-02', '2025-06-03');

-- 5. Restaurer les ACTIVITIES
DELETE FROM activity WHERE id = 1;
INSERT INTO activity (id, name, type, description, location, date, duration, "isCompleted", metadata, "classroomId") 
VALUES (1, 'orthophonie:;;%c%ll', 'academic', 'seances d''orthophonie', 'utaim', '2025-06-10 00:00:00', 14, true, '{"resources":[""],"attachments":[""],"comments":""}', 1);

-- 6. Restaurer d'autres USERS si nécessaire
DELETE FROM users WHERE email IN ('hajerfahem@gmail.com', 'hajerfahem2024@gmail.com', 'admin@gmail.com');
INSERT INTO users (email, password, "firstName", "lastName", phone, picture, address, zipcode, active) 
VALUES 
('hajerfahem@gmail.com', '$2b$10$Umz...9Y6nm5z7eWqPLrDrO33FJT3CHf/Ls.o3JD7tgEAxnUsLGHnW', 'hajer', 'fahem', '75632634', 'image', 'medenine', '4100', true),
('hajerfahem2024@gmail.com', '$2b$10$4b4wtCze5aBJ6ufYCk9KJusWxzcVWhPaBQswaOwoI/2.JRQOV4SqK', 'hajer', 'fahem', '75632634', 'image', 'medenine', '4100', true),
('admin@gmail.com', '$2b$10$tcLcLfZt8Sqz3aB/uPZ30OrIi/8ngYbMXsteej4oQjxmTZO5NInnmDW', 'hajer', 'fahem', '654367', 'image', 'medenine', '4100', true);

-- Remise à zéro des séquences
SELECT setval('parent_id_seq', 3, false);
SELECT setval('classroom_id_seq', 2, true);
SELECT setval('student_id_seq', 2, false);
SELECT setval('activity_id_seq', 2, false);
SELECT setval('users_id_seq', 12, true);

-- Vérification: afficher le compte admin restauré
SELECT id, email, "firstName", "lastName", active FROM users WHERE email = 'admin@school.com';
SELECT id, "firstName", "lastName", email FROM parent;
SELECT id, name FROM classroom;
SELECT id, "firstName", email FROM student;
SELECT id, name FROM activity;
