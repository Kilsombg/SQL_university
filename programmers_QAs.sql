DROP DATABASE IF EXISTS  university;
CREATE DATABASE university;
USE university;

CREATE TABLE department(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL);

CREATE TABLE person(
id INT AUTO_INCREMENT PRIMARY KEY,
departmentID INT,
name VARCHAR(20) NOT NULL,
address VARCHAR(30) NOT NULL,
egn VARCHAR(10) UNIQUE NOT NULL,
CONSTRAINT FOREIGN KEY(departmentID) REFERENCES department(id));

CREATE TABLE qas(
person_id INT PRIMARY KEY,
isAutomation BIT(1) DEFAULT NULL,
CONSTRAINT FOREIGN KEY (person_id) REFERENCES person(id));

CREATE TABLE programmers(
person_id INT PRIMARY KEY,
front_back_end ENUM('front-end', 'back-end', 'full-stack'),
CONSTRAINT FOREIGN KEY (person_id) REFERENCES person(id));

CREATE TABLE langauges(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(20) NOT NULL);

CREATE TABLE prog_lang(
programmer_id INT PRIMARY KEY,
CONSTRAINT FOREIGN KEY (programmer_id) REFERENCES programmers(id),
language_id INT PRIMARY KEY,
CONSTRAINT FOREIGN KEY (language_id) REFERENCES langauges(id));