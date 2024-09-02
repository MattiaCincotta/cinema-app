CREATE DATABASE IF NOT EXISTS cineCult;

USE cineCult;

CREATE TABLE IF NOT EXISTS directors(
    id SERIAL PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    image_url VARCHAR(256) NOT NULL,
    categories VARCHAR(8) NOT NULL -- categories of the movies they direct
);

CREATE TABLE IF NOT EXISTS movies(
    id SERIAL PRIMARY KEY,
    title VARCHAR(64) NOT NULL,
    director_id INTEGER NOT NULL,
    year INTEGER NOT NULL,
    categories VARCHAR(8) NOT NULL,
    image_url VARCHAR(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS users(
    id SERIAL PRIMARY KEY,
    username VARCHAR(16) NOT NULL,
    password VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS seen_movies(
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    seen BIT(1)
);