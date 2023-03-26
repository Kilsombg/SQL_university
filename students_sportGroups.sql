DROP DATABASE IF EXISTS university;
CREATE DATABASE university;
USE university;

/* По даден проект училище трябва да организира извънучилищни спортни клубове. 
Спортните клубове могат да бъдат първоначално два типа– по футбол и по волейбол, 
а на следващ етап ще се добавят още.  За всеки клуб може да има много наброй групи, 
които тренират в различни дни и в различни часове. Учениците могат да се присъединят
към който и да е от двата типа клуба едновременно като се запишат в определена група 
в определен ден от седмицата и в определен час. За всяка от клубните групи има по един 
треньор, който тренира учениците. Всеки ученик може да се идентифицира с уникален номер – ид. 
Допълнете таблиците с необходима информация по ваш избор. */

CREATE TABLE students(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(30) NOT NULL,
egn VARCHAR(10) UNIQUE NOT NULL,
address VARCHAR(50) NOT NULL,
phone VARCHAR(10) NULL DEFAULT NULL,
class VARCHAR(10) NULL DEFAULT NULL);


CREATE TABLE sports(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(20) NOT NULL);

CREATE TABLE coaches(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
egn VARCHAR(10) UNIQUE NOT NULL,
name VARCHAR(30) NOT NULL);

CREATE TABLE sportGroups(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
sport_id INT NOT NULL,
coach_id INT NOT NULL,
location VARCHAR(40) NOT NULL,
time TIME NOT NULL,
day ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
UNIQUE KEY(location, time, day),
CONSTRAINT FOREIGN KEY (sport_id) REFERENCES sports(id),
CONSTRAINT FOREIGN KEY (coach_id) REFERENCES coaches(id)
);

CREATE TABLE student_sport(
student_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (student_id) REFERENCES students(id),
sportGroup_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (sportGroup_id) REFERENCES sportGroups(id),
PRIMARY KEY (student_id, sportGroup_id));



