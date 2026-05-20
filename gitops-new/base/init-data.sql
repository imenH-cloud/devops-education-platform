-- ============================================
-- DONNÉES INITIALES POUR LA PLATEFORME ÉDUCATIVE
-- ============================================

-- 1. UTILISATEUR ADMIN
INSERT INTO users (email, password, "firstName", "lastName", active, "createdAt") 
VALUES ('admin@education.com', '\\\', 'Admin', 'System', true, NOW());

-- 2. ENSEIGNANTS
INSERT INTO teacher ("indexNumber", cin, "firstName", surname, gender, address, telephone, email, password, specialization, "profileImage", "dateOfMandate") 
VALUES 
('TCH001', '12345678', 'Imen', 'Hamada', 'F', 'Tozeur', '01234567', 'imen.hamada@school.com', 'password123', 'Mathématiques', 'default.jpg', NOW()),
('TCH002', '87654321', 'Marie', 'Curie', 'F', 'Paris', '01234568', 'marie.curie@school.com', 'password123', 'Physique', 'default.jpg', NOW()),
('TCH003', '98765432', 'Albert', 'Einstein', 'M', 'Berlin', '01234569', 'albert.einstein@school.com', 'password123', 'Physique', 'default.jpg', NOW()),
('TCH004', '11223344', 'Ada', 'Lovelace', 'F', 'Londres', '01234570', 'ada.lovelace@school.com', 'password123', 'Informatique', 'default.jpg', NOW());

-- 3. PARENTS
INSERT INTO parent ("firstName", "lastName", email, "phoneNumber", "NCIN", address, "typeInsurance", "Numeroinsurance", job) 
VALUES 
('Jean', 'Martin', 'jean.martin@email.com', '0612345678', 12345678, '15 rue des Écoles, Paris', 'Mutuelle', 'MUT123456', 'Ingénieur'),
('Sophie', 'Bernard', 'sophie.bernard@email.com', '0623456789', 23456789, '8 avenue de la République, Lyon', 'Sécurité Sociale', 'SS234567', 'Enseignante'),
('Michel', 'Durand', 'michel.durand@email.com', '0634567890', 34567890, '25 boulevard Victor Hugo, Marseille', 'Mutuelle', 'MUT345678', 'Médecin'),
('Isabelle', 'Petit', 'isabelle.petit@email.com', '0645678901', 45678901, '12 place de la Liberté, Toulouse', 'Sécurité Sociale', 'SS456789', 'Avocate');

-- 4. ÉTUDIANTS
INSERT INTO student ("firstName", "numeroInscriptio", "lastName", email, "dateOfBirth", "phoneNumber", address, "isActive", "enrollmentDate", "parentId") 
VALUES 
('Lucas', 'INS001', 'Martin', 'lucas.martin@student.com', '2012-05-15', '0612345678', '15 rue des Écoles, Paris', true, '2024-09-01', 1),
('Emma', 'INS002', 'Martin', 'emma.martin@student.com', '2014-08-22', '0612345679', '15 rue des Écoles, Paris', true, '2024-09-01', 1),
('Thomas', 'INS003', 'Bernard', 'thomas.bernard@student.com', '2011-03-10', '0623456789', '8 avenue de la République, Lyon', true, '2024-09-01', 2),
('Julie', 'INS004', 'Bernard', 'julie.bernard@student.com', '2013-11-30', '0623456790', '8 avenue de la République, Lyon', true, '2024-09-01', 2),
('Camille', 'INS005', 'Durand', 'camille.durand@student.com', '2010-09-12', '0634567890', '25 boulevard Victor Hugo, Marseille', true, '2024-09-01', 3),
('Nathan', 'INS006', 'Durand', 'nathan.durand@student.com', '2015-01-25', '0634567891', '25 boulevard Victor Hugo, Marseille', true, '2024-09-01', 3),
('Chloé', 'INS007', 'Petit', 'chloe.petit@student.com', '2012-07-18', '0645678901', '12 place de la Liberté, Toulouse', true, '2024-09-01', 4);

-- 5. ACTIVITÉS (adaptées pour enfants autistes)
INSERT INTO activity (name, type, description, location, date, duration, classroom, metadata) 
VALUES 
('Sensibilisation sensorielle', 'other', 'Exploration des textures et sons pour développer les sens', 'Salle sensorielle', NOW(), 45, 1, '{"objectif": "développer les sens", "adaptation": "autisme"}'),
('Jeu de rôle social', 'club', 'Apprentissage des interactions sociales à travers des jeux', 'Salle de jeux', NOW(), 60, 2, '{"competences": "sociales", "adaptation": "petits groupes"}'),
('Relaxation Yoga', 'sports', 'Exercices de respiration et postures douces', 'Salle calme', NOW(), 30, 1, '{"bien-être": "relaxation", "adaptation": "autisme"}'),
('Atelier de communication', 'club', 'Apprentissage des émotions et de l\'expression', 'Salle de classe', NOW(), 45, 3, '{"objectif": "communication", "adaptation": "pictogrammes"}'),
('Puzzle et logique', 'academic', 'Développement de la logique et de la concentration', 'Salle de classe', NOW(), 30, 1, '{"compétences": "cognitives", "adaptation": "visuel"}'),
('Communication PECS', 'other', 'Utilisation des pictogrammes pour la communication', 'Salle de classe', NOW(), 45, 3, '{"methode": "PECS", "adaptation": "communication alternative"}'),
('Musique et rythme', 'cultural', 'Exploration des instruments et du rythme', 'Salle de musique', NOW(), 45, 2, '{"therapie": "musicothérapie", "adaptation": "autisme"}'),
('Atelier dessin', 'cultural', 'Expression artistique libre', 'Salle art', NOW(), 40, 2, '{"objectif": "expression", "adaptation": "sensoriel"}'),
('Parcours moteur', 'sports', 'Parcours obstacles adapté pour développer la motricité', 'Gymnase', NOW(), 50, 2, '{"objectif": "motricité globale", "adaptation": "structure"}'),
('Jeux de ballon', 'sports', 'Activités de coordination et équilibre', 'Cour recreation', NOW(), 35, 2, '{"objectif": "coordination", "adaptation": "regles simples"}');

-- 6. VÉRIFICATION
SELECT 'Utilisateurs' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'Enseignants', COUNT(*) FROM teacher
UNION ALL
SELECT 'Parents', COUNT(*) FROM parent
UNION ALL
SELECT 'Étudiants', COUNT(*) FROM student
UNION ALL
SELECT 'Activités', COUNT(*) FROM activity;

