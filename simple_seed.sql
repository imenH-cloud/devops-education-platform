INSERT INTO parent (id, "firstName", "lastName", email, "phoneNumber", "NCIN", address, "typeInsurance", "Numeroinsurance", job) 
VALUES (1, 'Ahmed', 'Ben Ali', 'ahmed@test.com', '21612345678', 12345678, '123 Rue', 'CNSS', 'CNSS001', 'Ingénieur');

INSERT INTO classroom (id, name, level, capacity) 
VALUES (1, 'Classe A', 'L1', 25);

INSERT INTO teacher (id, "firstName", "lastName", email, "phoneNumber", specialization, experience) 
VALUES (1, 'Rania', 'Ghorbel', 'rania@test.com', '21612111111', 'Math', 5);

INSERT INTO student (id, "firstName", "lastName", email, age, "classroomId", "parentId") 
VALUES (1, 'Karim', 'Ben Ali', 'karim@test.com', 10, 1, 1);

INSERT INTO activity (id, title, description, date, "classroomId", "teacherId", "studentId") 
VALUES (1, 'Math Lesson', 'Algebra', '2026-05-25 09:00', 1, 1, 1);
