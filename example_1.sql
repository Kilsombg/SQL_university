DROP DATABASE IF EXISTS university;
CREATE DATABASE university;
USE university;

CREATE TABLE producers(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(30) NOT NULL,
address VARCHAR(50) NOT NULL,
bullstat VARCHAR(10) NOT NULL UNIQUE);

CREATE TABLE studios(
id INT NOT NULl AUTO_INCREMENT PRIMARY KEY,
address VARCHAR(50) NOT NULL,
bullstat VARCHAR(10) NOT NULL UNIQUE);

CREATE TABLE movies(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
budget DOUBLE NOT NULL,
title VARCHAR(30) NOT NULL,
year YEAR NOT NULL,
length TIME NOT NULL,
studio_id INT NOT NULL,
producer_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (studio_id) REFERENCES studios(id),
CONSTRAINT FOREIGN KEY (producer_id) REFERENCES producers(id));

INSERT INTO movies(budget, title, year, length, studio_id, producer_id)
VALUES (15000.30, 'Free star', '1993', '02:30:00', 1, 1),
	(10432.40, 'Darutea', '1995', '01:50:23', 2, 2),
    (9500, 'Wrecked', '1999', '02:10:00', 1, 1),
    (18800, 'Kick it', '1998', '02:00:00', 1, 1),
    (21000, 'Kick it II', '2001', '02:05:00', 2, 1),
    (10000.2, 'Dasne', '2004', '01:42:10', 2, 2);

CREATE TABLE actors(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
address VARCHAR(50) NOT NULL,
name VARCHAR(20) NOT NULL,
sex ENUM('F', 'M', 'Other') NOT NULL,
dateBirth DATE NULL DEFAULT NULL);

CREATE TABLE movie_actor(
movie_id INT NOT NULL,
actor_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (movie_id) REFERENCES movies(id),
CONSTRAINT FOREIGN KEY (actor_id) REFERENCES actors(id));


INSERT INTO actors(address, name, sex, dateBirth)
VALUES ('Benedit 3, Sofia', 'Teodora', 'F', '2000-3-1'),
	('Plovdiv', 'Debora', 'F', '2002-11-20'),
	('Sedalishte 43, Pernik', 'Dobril', 'M', '1973-10-19'),
    ('Oneart 8, Sofia', 'Sa', 'M', '2005-06-15'),
	('Wazarishte', 'Drenan', 'Other', '1965-01-01');


INSERT INTO producers (bullstat, address, name)
VALUES ('123456789', "Studentski grad, Sofia", "John Smith"),
('987654321', "First street, Veliko Tyrnovo", "Sam Donovan");

INSERT INTO studios (bullstat, address)
VALUES ('425136789', "Plovdiv"),
('471528693', "Varna");

INSERT INTO movie_actor(movie_id, actor_id)
VALUES (1,1), (2, 2), (3, 3), (4, 3), (4, 4), (5, 5);

# 1.2
SELECT name
FROM actors
WHERE sex = 'M' OR address LIKE '%Sofia%';

# 1.3
SELECT * 
FROM movies
WHERE year BETWEEN 1990 AND 2000
ORDER BY budget DESC
LIMIT 3;

# 1.4
SELECT movies.title as movieName, actors.name as actorName
FROM movies JOIN actors
ON movies.id IN (
SELECT movie_actor.movie_id
FROM movie_actor
WHERE movie_actor.actor_id = actors.id)
WHERE movies.producer_id IN (
SELECT producers.id
FROM producers
WHERE producers.name = 'John Smith');


# 1.5
SELECT actors.name, AVG(movies.length) as avgLength
FROM movies JOIN actors ON actors.id IN( SELECT actors.id
						FROM movie_actor
                        WHERE movies.id = movie_actor.movie_id)
			WHERE movies.length > (SELECT AVG(movies.length)
            FROM movies
            WHERE year < 2000)
            GROUP BY name;