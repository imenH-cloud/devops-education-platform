#!/bin/bash
export PGPASSWORD=postgres

psql -h postgres-deployment -U postgres -d education_db << 'ENDSQL'
INSERT INTO teacher (indexNumber, cin, firstName, surname, gender, address, telephone, email, specialization) 
VALUES ('T001', 1111, 'Imen', 'Hamada', 'F', 'Tozeur', '01234567', 'imen@school.com', 'Math');
INSERT INTO teacher (indexNumber, cin, firstName, surname, gender, address, telephone, email, specialization) 
VALUES ('T002', 2222, 'Marie', 'Curie', 'F', 'Paris', '01234568', 'marie@school.com', 'Physics');
INSERT INTO teacher (indexNumber, cin, firstName, surname, gender, address, telephone, email, specialization) 
VALUES ('T003', 3333, 'Albert', 'Einstein', 'M', 'Berlin', '01234569', 'albert@school.com', 'Physics');
INSERT INTO teacher (indexNumber, cin, firstName, surname, gender, address, telephone, email, specialization) 
VALUES ('T004', 4444, 'Ada', 'Lovelace', 'F', 'London', '01234570', 'ada@school.com', 'IT');

INSERT INTO parent (firstName, lastName, email, phoneNumber, NCIN, address, typeInsurance, Numeroinsurance, job) 
VALUES ('Jean', 'Martin', 'jean.martin@email.com', '0612345678', 12345678, 'rue Paris', 'Mutuelle', 'M123', 'Engineer');
INSERT INTO parent (firstName, lastName, email, phoneNumber, NCIN, address, typeInsurance, Numeroinsurance, job) 
VALUES ('Sophie', 'Bernard', 'sophie.bernard@email.com', '0623456789', 23456789, 'avenue Lyon', 'SS', 'S234', 'Teacher');
INSERT INTO parent (firstName, lastName, email, phoneNumber, NCIN, address, typeInsurance, Numeroinsurance, job) 
VALUES ('Michel', 'Durand', 'michel.durand@email.com', '0634567890', 34567890, 'boulevard Marseille', 'Mutuelle', 'M345', 'Doctor');
INSERT INTO parent (firstName, lastName, email, phoneNumber, NCIN, address, typeInsurance, Numeroinsurance, job) 
VALUES ('Isabelle', 'Petit', 'isabelle.petit@email.com', '0645678901', 45678901, 'place Toulouse', 'SS', 'S456', 'Lawyer');

INSERT INTO classroom (name, capacity, grade, academicYear, location, Specialization) 
VALUES ('Classe A', 15, 'L1', '2024-2025', 'Batiment A', 'General');
INSERT INTO classroom (name, capacity, grade, academicYear, location, Specialization) 
VALUES ('Classe B', 16, 'L2', '2024-2025', 'Batiment B', 'General');
INSERT INTO classroom (name, capacity, grade, academicYear, location, Specialization) 
VALUES ('Classe C', 18, 'L3', '2024-2025', 'Batiment C', 'General');

INSERT INTO student (firstName, numeroInscriptio, lastName, email, dateOfBirth, phoneNumber, address, enrollmentDate, parentId, classroomId) 
VALUES ('Lucas', 'INS001', 'Martin', 'lucas@student.com', '2012-05-15', '0612345678', 'rue Paris', '2024-09-01', 1, 1);
INSERT INTO student (firstName, numeroInscriptio, lastName, email, dateOfBirth, phoneNumber, address, enrollmentDate, parentId, classroomId) 
VALUES ('Emma', 'INS002', 'Martin', 'emma@student.com', '2014-08-22', '0612345679', 'rue Paris', '2024-09-01', 1, 1);
INSERT INTO student (firstName, numeroInscriptio, lastName, email, dateOfBirth, phoneNumber, address, enrollmentDate, parentId, classroomId) 
VALUES ('Thomas', 'INS003', 'Bernard', 'thomas@student.com', '2011-03-10', '0623456789', 'avenue Lyon', '2024-09-01', 2, 2);
INSERT INTO student (firstName, numeroInscriptio, lastName, email, dateOfBirth, phoneNumber, address, enrollmentDate, parentId, classroomId) 
VALUES ('Julie', 'INS004', 'Bernard', 'julie@student.com', '2013-11-30', '0623456790', 'avenue Lyon', '2024-09-01', 2, 2);
INSERT INTO student (firstName, numeroInscriptio, lastName, email, dateOfBirth, phoneNumber, address, enrollmentDate, parentId, classroomId) 
VALUES ('Camille', 'INS005', 'Durand', 'camille@student.com', '2010-09-12', '0634567890', 'boulevard Marseille', '2024-09-01', 3, 3);
INSERT INTO student (firstName, numeroInscriptio, lastName, email, dateOfBirth, phoneNumber, address, enrollmentDate, parentId, classroomId) 
VALUES ('Nathan', 'INS006', 'Durand', 'nathan@student.com', '2015-01-25', '0634567891', 'boulevard Marseille', '2024-09-01', 3, 3);
INSERT INTO student (firstName, numeroInscriptio, lastName, email, dateOfBirth, phoneNumber, address, enrollmentDate, parentId, classroomId) 
VALUES ('Chloe', 'INS007', 'Petit', 'chloe@student.com', '2012-07-18', '0645678901', 'place Toulouse', '2024-09-01', 4, 1);

INSERT INTO activity (name, location, date, classroom) VALUES ('Sensibilisation sensorielle', 'Salle sensorielle', '2026-05-25 10:00', 1);
INSERT INTO activity (name, location, date, classroom) VALUES ('Jeu de role social', 'Salle de jeux', '2026-05-26 14:00', 2);
INSERT INTO activity (name, location, date, classroom) VALUES ('Relaxation Yoga', 'Salle calme', '2026-05-27 09:00', 1);
INSERT INTO activity (name, location, date, classroom) VALUES ('Atelier communication', 'Salle classe', '2026-05-28 15:00', 3);
INSERT INTO activity (name, location, date, classroom) VALUES ('Puzzle et logique', 'Salle classe', '2026-05-29 11:00', 1);
INSERT INTO activity (name, location, date, classroom) VALUES ('Communication PECS', 'Salle classe', '2026-05-30 10:30', 3);
INSERT INTO activity (name, location, date, classroom) VALUES ('Musique et rythme', 'Salle musique', '2026-05-31 14:30', 2);
INSERT INTO activity (name, location, date, classroom) VALUES ('Atelier dessin', 'Salle art', '2026-06-01 13:00', 2);
INSERT INTO activity (name, location, date, classroom) VALUES ('Parcours moteur', 'Gymnase', '2026-06-02 10:00', 2);
INSERT INTO activity (name, location, date, classroom) VALUES ('Jeux de ballon', 'Cour recreation', '2026-06-03 15:30', 2);

SELECT 'TEACHERS' as data_type, COUNT(*) as count FROM teacher
UNION ALL
SELECT 'PARENTS', COUNT(*) FROM parent
UNION ALL
SELECT 'STUDENTS', COUNT(*) FROM student
UNION ALL
SELECT 'CLASSROOMS', COUNT(*) FROM classroom
UNION ALL
SELECT 'ACTIVITIES', COUNT(*) FROM activity;
ENDSQL
