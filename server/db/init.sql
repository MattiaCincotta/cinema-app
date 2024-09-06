USE cineCult;   

CREATE TABLE IF NOT EXISTS directors(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(64) NOT NULL,
    image_url VARCHAR(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS categories(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(16) NOT NULL
);

CREATE TABLE IF NOT EXISTS movies_categories(
    id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS  directors_categories(
    id INT PRIMARY KEY AUTO_INCREMENT,
    director_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS movies(
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(64) NOT NULL,
    year INTEGER NOT NULL,
    image_url VARCHAR(256) NOT NULL, -- image of the movie  
    director_id INT,
    FOREIGN KEY (director_id) REFERENCES directors(id)                                                                                                 
);

CREATE TABLE IF NOT EXISTS users(
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(16) NOT NULL,
    password VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS favorites(
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS sessions(
    user_id INTEGER PRIMARY KEY NOT NULL,
    token VARCHAR(64) NOT NULL  
);

CREATE TABLE IF NOT EXISTS to_see_movies(
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    seen BIT(1)
);

-- IF NOT EXISTS CANNOT BE USED OUTSIDE OF A FUNCTION OR PROCEDURE
DELIMITER $$
CREATE PROCEDURE insert_categories_if_empty()
BEGIN
    IF NOT EXISTS (SELECT 1 FROM categories) THEN
        INSERT INTO categories (name)
        VALUES
            ('Action'),
            ('Adventure'),
            ('Comedy'),
            ('Drama'),
            ('Fantasy'),
            ('Horror'),
            ('Mystery'),
            ('Romance'),
            ('Sci-Fi'),
            ('Thriller');
    END IF;
END$$

DELIMITER ;

CALL insert_categories_if_empty();
-- CALL THE PROCEDURE TO INSERT CATEGORIES

-- example data for testing
INSERT INTO directors(name, image_url) VALUES
        ('Christopher Nolan', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Christopher_Nolan_by_Gage_Skidmore.jpg/800px-Christopher_Nolan_by_Gage_Skidmore.jpg'),
        ('Quentin Tarantino', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Quentin_Tarantino_by_Gage_Skidmore.jpg/800px-Quentin_Tarantino_by_Gage_Skidmore.jpg'),
        ('Steven Spielberg', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Steven_Spielberg_by_Gage_Skidmore.jpg/800px-Steven_Spielberg_by_Gage_Skidmore.jpg');
    
INSERT INTO directors_categories(director_id, category_id) VALUES
        (1, 9),
        (2, 3),
        (3, 1);

INSERT INTO movies(title, year, image_url, director_id) VALUES
        ('Inception', 2010, 'https://upload.wikimedia.org/wikipedia/en/7/7f/Inception_ver3.jpg', 1),
        ('Pulp Fiction', 1994, 'https://upload.wikimedia.org/wikipedia/en/3/3b/Pulp_Fiction_%281994%29_poster.jpg', 2),
        ('Saving Private Ryan', 1998, 'https://upload.wikimedia.org/wikipedia/en/a/ac/Saving_Private_Ryan_poster.jpg', 3);
    
INSERT INTO movies_categories(movie_id, category_id) VALUES
        (1, 9),
        (2, 3),
        (3, 1);
