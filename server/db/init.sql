USE cineCult;   

CREATE TABLE IF NOT EXISTS directors(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(64) NOT NULL,
    image_url VARCHAR(256) NOT NULL,
    biography TEXT NOT NULL
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
    director_id INT NOT NULL
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

CREATE TABLE IF NOT EXISTS seen_movies(
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL
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
INSERT INTO directors(name, image_url, biography) VALUES
        ('Christopher Nolan', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Christopher_Nolan_Cannes_2018.jpg/220px-Christopher_Nolan_Cannes_2018.jpg', 'Christopher Edward Nolan CBE is a British-American film director, producer, and screenwriter. He is one of the highest-grossing directors in history, and among the most acclaimed and influential filmmakers of the 21st century. The acclaim garnered by his independent films gave Nolan the opportunity to make the big-budget thriller Insomnia (2002), the mystery drama The Prestige (2006), the action film The Dark Knight Trilogy (2005–2012), the science fiction thriller Inception (2010), and the science fiction film Interstellar (2014).'),
        ('Quentin Tarantino', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Quentin_Tarantino_by_Gage_Skidmore.jpg/220px-Quentin_Tarantino_by_Gage_Skidmore.jpg', "Quentin Jerome Tarantino is an American film director, screenwriter, producer, and actor. His films are characterized by nonlinear storylines, dark humor, stylized violence, extended dialogue, ensemble casts, references to popular culture, alternate history, and neo-noir. Tarantino's films have earned him various accolades, including two Academy Awards, a BAFTA Award, a Golden Globe Award, and the Palme d'Or, and he has been nominated for an Emmy and a Grammy."),
        ('Steven Spielberg', 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/MKr25402_Steven_Spielberg_%28Berlinale_2023%29.jpg/220px-MKr25402_Steven_Spielberg_%28Berlinale_2023%29.jpg', "Steven Allan Spielberg is an American film director, producer, and screenwriter. He is considered one of the founding pioneers of the New Hollywood era and one of the most popular directors and producers in film history. Spielberg started in Hollywood directing television and several minor theatrical releases. He became a household name as the director of Jaws (1975), which was critically and commercially successful and is considered the first summer blockbuster.");
    
INSERT INTO directors_categories(director_id, category_id) VALUES
        (1, 9),
        (2, 3),
        (3, 1);

INSERT INTO movies(title, year, image_url, director_id) VALUES
        ('Inception', 2010, 'https://upload.wikimedia.org/wikipedia/en/2/2e/Inception_%282010%29_theatrical_poster.jpg', 1),
        ('Pulp Fiction', 1994, 'https://upload.wikimedia.org/wikipedia/en/3/3b/Pulp_Fiction_%281994%29_poster.jpg', 2),
        ('Saving Private Ryan', 1998, 'https://upload.wikimedia.org/wikipedia/en/thumb/a/ac/Saving_Private_Ryan_poster.jpg/220px-Saving_Private_Ryan_poster.jpg', 3);
    
INSERT INTO movies_categories(movie_id, category_id) VALUES
        (1, 9),
        (2, 3),
        (3, 1);

INSERT INTO favorites(user_id, movie_id) VALUES
        (1, 1),
        (1, 2);

INSERT INTO seen_movies(user_id, movie_id) VALUES
        (1, 1),
        (1, 2);