#!/bin/bash
export PGPASSWORD=postgres

psql -h postgres-deployment -U postgres -d education_db -c \
"INSERT INTO parent (firstName, lastName, email, phoneNumber, NCIN, address, typeInsurance, Numeroinsurance, job) VALUES ('Ahmed', 'Ben Ali', 'ahmed@email.com', '21612345678', 12345678, '123 Rue Mohamed V', 'CNSS', 'CNSS001', 'Ingénieur');"

psql -h postgres-deployment -U postgres -d education_db -c \
"INSERT INTO parent (firstName, lastName, email, phoneNumber, NCIN, address, typeInsurance, Numeroinsurance, job) VALUES ('Fatima', 'Khalil', 'fatima@email.com', '21698765432', 87654321, '456 Avenue Bourguiba', 'CNAM', 'CNAM001', 'Médecin');"

psql -h postgres-deployment -U postgres -d education_db -c \
"INSERT INTO classroom (name, capacity, grade, academicYear) VALUES ('Classe A1', 25, 'L1', '2025-2026');"

psql -h postgres-development -U postgres -d education_db -c \
"INSERT INTO classroom (name, capacity, grade, academicYear) VALUES ('Classe B2', 30, 'L2', '2025-2026');"

psql -h postgres-deployment -U postgres -d education_db -c \
"INSERT INTO student (firstName, numeroInscriptio, lastName, email, dateOfBirth, phoneNumber, address, enrollmentDate, parentId, classroomId) VALUES ('Karim', 'S001', 'Ben Ali', 'karim@school.com', '2016-01-15', '21612111111', '123 Rue', '2025-09-01', 1, 1);"

psql -h postgres-deployment -U postgres -d education_db -c \
"INSERT INTO teacher (indexNumber, cin, firstName, surname, gender, address, telephone, email, specialization) VALUES ('T001', 1111111, 'Rania', 'Ghorbel', 'F', '123 Rue', '21612111111', 'rania@school.com', 'Mathématiques');"

psql -h postgres-deployment -U postgres -d education_db -c \
"INSERT INTO activity (name, location, date, classroom) VALUES ('Cours Mathématiques', 'Classe A1', '2026-05-25', 1);"

echo "✅ Data inserted successfully!"

psql -h postgres-deployment -U postgres -d education_db -c "SELECT COUNT(*) as total_parents FROM parent; SELECT COUNT(*) as total_students FROM student; SELECT COUNT(*) as total_classrooms FROM classroom;"
