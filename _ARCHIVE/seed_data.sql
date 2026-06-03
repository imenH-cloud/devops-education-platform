-- Insert Parents
INSERT INTO parent (firstName, lastName, email, phoneNumber, NCIN, address, typeInsurance, Numeroinsurance, job)
VALUES 
  ('Ahmed', 'Ben Ali', 'ahmed.benali@email.com', '21612345678', 12345678, '123 Rue Mohamed V', 'CNSS', 'CNSS001', 'Ingénieur'),
  ('Fatima', 'Khalil', 'fatima.khalil@email.com', '21698765432', 87654321, '456 Avenue Bourguiba', 'CNAM', 'CNAM001', 'Médecin'),
  ('Mohamed', 'Saïd', 'mohamed.said@email.com', '21622334455', 11111111, '789 Rue Tahar Ben Achour', 'CNSS', 'CNSS002', 'Professeur');

-- Insert Classrooms
INSERT INTO classroom (name, level, capacity)
VALUES 
  ('Classe A1', 'Niveau 1', 25),
  ('Classe B2', 'Niveau 2', 30),
  ('Classe C3', 'Niveau 3', 20);

-- Insert Teachers
INSERT INTO teacher (firstName, lastName, email, phoneNumber, specialization, experience)
VALUES 
  ('Rania', 'Ghorbel', 'rania.ghorbel@school.com', '21612111111', 'Mathématiques', 5),
  ('Hassan', 'Maamouri', 'hassan.maamouri@school.com', '21612222222', 'Français', 8),
  ('Leila', 'Ben Salah', 'leila.bensalah@school.com', '21612333333', 'Sciences', 3);

-- Insert Students
INSERT INTO student (firstName, lastName, email, age, classroomId, parentId)
VALUES 
  ('Karim', 'Ben Ali', 'karim.benali@school.com', 10, 1, 1),
  ('Noor', 'Khalil', 'noor.khalil@school.com', 11, 1, 2),
  ('Zainab', 'Saïd', 'zainab.said@school.com', 9, 2, 3),
  ('Amira', 'Ben Ali', 'amira.benali@school.com', 12, 2, 1);

-- Insert Activities
INSERT INTO activity (title, description, date, classroomId, teacherId, studentId)
VALUES 
  ('Cours de Mathématiques', 'Algèbre et Géométrie', '2026-05-25 09:00:00', 1, 1, 1),
  ('Activité Scientifique', 'Expérience sur l''énergie', '2026-05-26 14:00:00', 2, 3, 3),
  ('Lecture Française', 'Analyse de texte littéraire', '2026-05-27 10:30:00', 1, 2, 2),
  ('Projet Groupe', 'Présentation projet final', '2026-05-28 15:00:00', 2, 1, 4);
