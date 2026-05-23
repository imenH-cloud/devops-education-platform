-- Insert Parents
INSERT INTO parent ("firstName", "lastName", email, "phoneNumber", "NCIN", address, "typeInsurance", "Numeroinsurance", job)
VALUES 
  ('Ahmed', 'Ben Ali', 'ahmed@email.com', '21612345678', 12345678, '123 Rue Mohamed V', 'CNSS', 'CNSS001', 'Ingénieur'),
  ('Fatima', 'Khalil', 'fatima@email.com', '21698765432', 87654321, '456 Avenue Bourguiba', 'CNAM', 'CNAM001', 'Médecin'),
  ('Mohamed', 'Saïd', 'mohamed@email.com', '21622334455', 11111111, '789 Rue Tahar', 'CNSS', 'CNSS002', 'Professeur');

-- Insert Classrooms
INSERT INTO classroom (name, capacity, grade, academicYear)
VALUES 
  ('Classe A1', 25, 'L1', '2025-2026'),
  ('Classe B2', 30, 'L2', '2025-2026'),
  ('Classe C3', 20, 'L3', '2025-2026');

-- Insert Teachers  
INSERT INTO teacher ("indexNumber", cin, "firstName", surname, gender, address, telephone, email, specialization)
VALUES 
  ('T001', 1111111, 'Rania', 'Ghorbel', 'F', '123 Rue', '21612111111', 'rania@school.com', 'Mathématiques'),
  ('T002', 2222222, 'Hassan', 'Maamouri', 'M', '456 Ave', '21612222222', 'hassan@school.com', 'Français'),
  ('T003', 3333333, 'Leila', 'Ben Salah', 'F', '789 Rue', '21612333333', 'leila@school.com', 'Sciences');

-- Insert Students
INSERT INTO student ("firstName", "numeroInscriptio", "lastName", email, "dateOfBirth", "phoneNumber", address, "enrollmentDate", "parentId", "classroomId")
VALUES 
  ('Karim', 'S001', 'Ben Ali', 'karim@school.com', '2016-01-15', '21612111111', '123 Rue', '2025-09-01', 1, 1),
  ('Noor', 'S002', 'Khalil', 'noor@school.com', '2015-06-20', '21612222222', '456 Ave', '2025-09-01', 2, 1),
  ('Zainab', 'S003', 'Saïd', 'zainab@school.com', '2016-03-10', '21612333333', '789 Rue', '2025-09-01', 3, 2),
  ('Amira', 'S004', 'Ben Ali', 'amira@school.com', '2015-12-05', '21612444444', '123 Rue', '2025-09-01', 1, 2);

-- Insert Activities
INSERT INTO activity (name, location, date, classroom)
VALUES 
  ('Cours Mathématiques', 'Classe A1', '2026-05-25', 1),
  ('Activité Scientifique', 'Labo', '2026-05-26', 2),
  ('Lecture Française', 'Classe A1', '2026-05-27', 1),
  ('Projet Groupe', 'Classe B2', '2026-05-28', 2);

-- Verify inserts
SELECT COUNT(*) as total_parents FROM parent;
SELECT COUNT(*) as total_students FROM student;
SELECT COUNT(*) as total_classrooms FROM classroom;
SELECT COUNT(*) as total_teachers FROM teacher;
SELECT COUNT(*) as total_activities FROM activity;
