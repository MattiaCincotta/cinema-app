CREATE DATABASE IF NOT EXISTS cineCult;

USE cineCult;

CREATE TABLE IF NOT EXISTS directors(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(64) NOT NULL,
    image_url VARCHAR(256) NOT NULL,
    categories VARCHAR(8) NOT NULL -- categories of the movies they direct
);

CREATE TABLE IF NOT EXISTS movies(
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(64) NOT NULL,
    year INTEGER NOT NULL,
    categories VARCHAR(8) NOT NULL,
    image_url VARCHAR(256) NOT NULL, -- image of the movie  
    director_id INT,
    FOREIGN KEY (director_id) REFERENCES directors(id)                                                                                                 
);

CREATE TABLE IF NOT EXISTS users(
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(16) NOT NULL,
    password VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS seen_movies(
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    seen BIT(1)
);

-- example data for testing

INSERT INTO directors(name, image_url, categories) VALUES
    ('Christopher Nolan', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Christopher_Nolan_by_Gage_Skidmore.jpg/800px-Christopher_Nolan_by_Gage_Skidmore.jpg', 'D'),
    ('Quentin Tarantino', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Quentin_Tarantino_by_Gage_Skidmore.jpg/800px-Quentin_Tarantino_by_Gage_Skidmore.jpg', 'A'),
    ('Steven Spielberg', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Steven_Spielberg_by_Gage_Skidmore.jpg/800px-Steven_Spielberg_by_Gage_Skidmore.jpg', 'A');

INSERT INTO movies(title, year, categories, image_url, director_id) VALUES
    ('Inception', 2010, 'D', 'https://upload.wikimedia.org/wikipedia/en/7/7f/Inception_ver3.jpg', 1),
    ('Pulp Fiction', 1994, 'A', 'https://upload.wikimedia.org/wikipedia/en/3/3b/Pulp_Fiction_%281994%29_poster.jpg', 2),
    ('Saving Private Ryan', 1998, 'A', 'https://upload.wikimedia.org/wikipedia/en/a/ac/Saving_Private_Ryan_poster.jpg', 3);