from flask import Flask, current_app, g
import mysql.connector
from db_utils.db import DB_utils

######### USER PART ##############################################################################################

class User:
    def __init__(self, username: str, password: str) -> None:
        self.username = username
        self.password = password
    
class UserManager:
    def __init__(self) -> None:
        pass
    
    @staticmethod
    def get_user(username: str) -> User:
        """
        Get a user from the database.
        Args:
            name: The name of the user to get.
        Returns:
            The user object if found, None otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
            result = cursor.fetchone()
            cursor.close()
            if result:
                return User(result['username'], result['password'])
            return None
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return None
    
    @staticmethod
    def add_user(user: User) -> bool:
        """
        Add a user to the database.
        Args:
            user: The user object to add.
        Returns:
            True if the user was added successfully, False otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (user.username, user.password))
            g.db.commit()
            return True
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return False
        
    @staticmethod
    def verify_user(username:str, password: str) -> bool:
        """
        Verify a user's credentials.
        Args:
            name: The name of the user.
            password: The password of the user.
        Returns:
            True if the user's credentials are valid, False otherwise.
        """
        
        user = UserManager.get_user(username)
        if user and user.password == password:
            return True
        return False
    
###################################################################################################################

######### DIRECTOR PART ###########################################################################################

class Director:
    def __init__(self, id:int, name: str, categories: str, image_url: str) -> None:
        self.id = id
        self.name = name
        self.categories = categories
        self.image_url = image_url
    
class DirectorManager:
    def __init__(self) -> None:
        pass
    
    @staticmethod
    def get_directors() -> list:
        """
        Get all directors from the database.
        Returns:
            A list of director objects.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT * FROM directors")
            result = cursor.fetchall()
            cursor.close()
            return [Director(director['id'], director['name'], director['categories'], director['image_url']) for director in result]
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return []
    
    @staticmethod
    def get_director(name: str) -> Director:
        """
        Get a director from the database.
        Args:
            name: The name of the director to get.
        Returns:
            The director object if found, None otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT * FROM directors WHERE name = %s LIMIT 1", (name,))
            result = cursor.fetchone()
            cursor.close()
            if result:
                return Director(result['id'], result['name'], result['categories'], result['image_url'])
            return None
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return None
        
###################################################################################################################

######### MOVIE PART ##############################################################################################

class Movie:
    def __init__(self, title: str, director: str, year: int, categories: str, image_url: str) -> None:
        self.title = title
        self.director = director
        self.year = year
        self.categories = categories
        self.image_url = image_url
    
class MovieManager:
    def __init__(self) -> None:
        pass
    
    @staticmethod
    def get_movies() -> list:
        """
        Get all movies from the database.
        Returns:
            A list of movie objects.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT * FROM movies")
            result = cursor.fetchall()
            cursor.close()
            return [Movie(movie['title'], movie['director_id    '], movie['year'], movie['categories'], movie['image_url']) for movie in result]
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return []
    
    @staticmethod
    def get_movie(title: str) -> Movie:
        """
        Get a movie from the database.
        Args:
            title: The title of the movie to get.
        Returns:
            The movie object if found, None otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT * FROM movies WHERE title = %s", (title,))
            result = cursor.fetchone()
            cursor.close()
            if result:
                return Movie(result['title'], result['director'], result['year'], result['categories'], result['image_url'])
            return None
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return None
        
    @staticmethod
    def get_movies_from_director(director: Director) -> list:
        """
        Get all movies from a director.
        Args:
            director: The director object.
        Returns:
            A list of movie objects.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
            
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT * FROM movies WHERE director_id = %s", (director.id,))
            result = cursor.fetchall()
            cursor.close()
            return [Movie(movie['title'], movie['director_id'], movie['year'], movie['categories'], movie['image_url']) for movie in result]
        except mysql.connector.Error as e:      
            print(f"Error: {e}")
            return []
    
    @staticmethod
    def add_movie(movie: Movie) -> bool:
        """
        Add a movie to the database.
        Args:
            movie: The movie object to add.
        Returns:
            True if the movie was added successfully, False otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("INSERT INTO movies (title, director, year, categories) VALUES (%s, %s, %s, %s, %s)", (movie.title, movie.director, movie.year, movie.categories, movie.image_url))
            g.db.commit()
            return True
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return False

###################################################################################################################

