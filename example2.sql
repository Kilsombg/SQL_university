DROP DATABASE IF EXISTS university;
CREATE DATABASE university;
USE university;

CREATE TABLE threatments(
id INT AUTO_INCREMENT PRIMARY KEY,
price DECIMAL(6,2) NOT NULL);

INSERT INTO threatments(price)
VALUES (5),(10),(15),(20),(25),(30),(35),(40),(45),(50),(55);

CREATE TABLE doctors(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(20) NOT NULL);

INSERT INTO doctors(name)
VALUES ('Ivan Ivanov'), ('Todor Todorov'), ('Natasha'), ('Feria');

INSERT INTO doctors(name)
VALUES ('Ivan Ivanov');

CREATE TABLE patients(
egn VARCHAR(10) NOT NULL PRIMARY KEY,
name VARCHAR(20) NOT NULL);

INSERT INTO patients(egn, name)
VALUES ('1234567890', 'Georgi Osven'),
	('0987654321', 'Peria Sockich'),
    ('1234554321', 'Nikolai Nikolov');

CREATE TABLE procedures(
room_no INT NOT NULL,
time DATETIME NOT NULL,
patient_egn VARCHAR(10) NOT NULL,
threatment_id INT NOT NULL,
doctor_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (patient_egn) REFERENCES patients(egn),
CONSTRAINT FOREIGN KEY (threatment_id) REFERENCES threatments(id),
CONSTRAINT FOREIGN KEY (doctor_id) REFERENCES doctors(id),
UNIQUE KEY(room_no, time, patient_egn, doctor_id),
CONSTRAINT PRIMARY KEY (room_no, time, patient_egn, doctor_id));

INSERT INTO procedures(room_no, time, patient_egn, threatment_id, doctor_id)
VALUES (103, '2023-05-04', '1234567890', 10, 1),
 (102, '2023-03-17', '0987654321', 3, 2),
 (110, '2022-12-23 09:30:20', '0987654321', 10, 5),
 (102, '2023-03-17', '1234554321', 7, 4);

# 2.1
SELECT patients.name as patientName, doctors.id as doctorID, room_no, time
FROM patients JOIN procedures ON patients.egn = procedures.patient_egn
	JOIN doctors ON doctors.id = procedures.doctor_id
    WHERE doctors.name = 'Ivan Ivanov' AND procedures.threatment_id = 10;
    

# 2.2
SELECT patients.name as patientName, SUM(threatments.price) as totalPrice
FROM patients JOIN procedures ON patients.egn = procedures.patient_egn
JOIN threatments ON threatments.id = procedures.threatment_id
WHERE procedures.doctor_id = 2 AND procedures.room_no = 102
GROUP BY patients.name;