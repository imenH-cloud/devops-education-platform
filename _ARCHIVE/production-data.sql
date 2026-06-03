-- Données initiales trouvées dans backup.sql
-- PARENTS
INSERT INTO parent (id, firstName, lastName, email, phoneNumber, NCIN, address, typeInsurance, Numeroinsurance, job) VALUES 
(1, 'Ahmed', 'Ben Salah', 'ahmed.bensalah@example.com', '22112233', 12345678, 'Rue de Tunis, Ariana', 'CNAM', 'INS123456789', 'Enseignant');

INSERT INTO parent (id, firstName, lastName, email, phoneNumber, NCIN, address, typeInsurance, Numeroinsurance, job) VALUES
(2, 'houda', 'rouissi', 'houdaR@gmail.com', '50987654', 7564534, 'TOZEUR', 'CNAM', '887654345678', 'enseignant');

-- CLASSROOM
INSERT INTO classroom (id, name, capacity, grade, description, academicYear, isActive, location, Specialization) VALUES
(1, 'educationSssspcial i sé', 8, '1', 'classe des autistes 1', '', true, 'classe1', 'autisme');

-- STUDENTS
INSERT INTO student (id, firstName, numeroInscriptio, lastName, email, phoneNumber, address, isActive, parentId, classroomId, dateOfBirth, enrollmentDate) VALUES
(1, 'nada', '', 'salhi', '', '9054534343', 'hammet jarid', true, 2, NULL, '2025-06-02', '2025-06-03');

-- ACTIVITIES  
INSERT INTO activity (id, name, type, description, location, date, duration, isCompleted, metadata, classroom) VALUES
(1, 'orthophonie:;;%c%ll', 'academic', 'seances d''orthophonie', 'utaim', '2025-06-10 00:00:00', 14, true, '{"resources":[""],"attachments":[""],"comments":""}', 1);

-- USERS/ADMINS
INSERT INTO users (id, email, firstName, lastName, phone, picture, address, zipcode, password, saltRounds, token, active, createdAt, createdBy, updatedAt, updatedBy, deletedAt) VALUES
(2, 'hajerfahem@gmail.com', 'hajer', 'fahem', '75632634', 'image', 'medenine', '4100', '$2b$10$Umz...9Y6nm5z7eWqPLrDrO33FJT3CHf/Ls.o3JD7tgEAxnUsLGHnW', '$2b$10$Umz...9Y6nm5z7eWqPLrDrO', NULL, true, '2025-06-07 21:56:40.016+02', NULL, NULL, NULL, NULL);

INSERT INTO users (id, email, firstName, lastName, phone, picture, address, zipcode, password, saltRounds, token, active, createdAt, createdBy, updatedAt, updatedBy, deletedAt) VALUES
(4, 'hajerfahem2024@gmail.com', 'hajer', 'fahem', '75632634', 'image', 'medenine', '4100', '$2b$10$4b4wtCze5aBJ6ufYCk9KJusWxzcVWhPaBQswaOwoI/2.JRQOV4SqK', '$2b$10$4b4wtCze5aBJ6ufYCk9KJu', NULL, true, '2025-06-07 21:57:55.286+02', NULL, NULL, NULL, NULL);

INSERT INTO users (id, email, firstName, lastName, phone, picture, address, zipcode, password, saltRounds, token, active, createdAt, createdBy, updatedAt, updatedBy, deletedAt) VALUES
(5, 'admin@gmail.com', 'hajer', 'fahem', '654367', 'image', 'medenine ', '4100', '$2b$10$tcLcLfZt8Sqz3aB/uPZ30OrIi/8ngYbMXsteej4oQjxmTZO5NInnmDW', '$2b$10$tcLcLfZt8Sqz3aB/uPZ30Or', NULL, true, '2025-06-07 22:49:58.385+02', NULL, NULL, NULL, NULL);

INSERT INTO users (id, email, firstName, lastName, phone, picture, address, zipcode, password, saltRounds, token, active, createdAt, createdBy, updatedAt, updatedBy, deletedAt) VALUES
(1, 'imenhamada17@gmail.com', 'imen', 'Doe', '+33612345678', 'https://example.com/images/john.jpg', '123 rue de Paris', '75001', '$2b$10$r.NQjIWEqcUXP9GlrgK4MO/v.yHhMaJtjtO8QYy3t3UdZLAsQz', '$2b$10$r.NQjIWEqcUXP9GlrgK4MO', 'eyJhbGc', true, '2024-01-01 11:00:00+01', 1, '2025-06-14 11:51:19.695+02', 2, NULL);

INSERT INTO users (id, email, firstName, lastName, phone, picture, address, zipcode, password, saltRounds, token, active, createdAt, createdBy, updatedAt, updatedBy, deletedAt) VALUES
(11, 'elinee@gmail.com', 'eline', 'souli', '50555555', 'hyyyyy', 'TOZEUR', '2200', '$2b$10$8MuumHmQN7QyBan5543wN5.75VV04TZecmj48Cg87h8h6it2InV0KsU', '$2b$10$8MuumHmQN7QyBan5543wN5.', NULL, true, '2025-06-14 16:58:55.524+02', NULL, NULL, NULL, NULL);

-- Admin user for authentication (from init.sql)
INSERT INTO users (email, password, "firstName", "lastName", active) 
VALUES ('admin@tsa.com', '$2b$10$M9/lS5sUZRNva0/GDpP5GO3vxWALVO5GfoklngUvzxagMwPfm2JTS', 'Admin', 'System', true)
ON CONFLICT (email) DO NOTHING;
