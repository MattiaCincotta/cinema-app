from flask import Flask, current_app, g
import mysql.connector
from db.db import DB_utils
import uuid
from hashlib import sha256

######### USER PART ##############################################################################################

class User:
    def __init__(self, id: int, username: str, password: str) -> None:
        self.id = id
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
                return User(result['id'], result['username'], result['password'])
            return None
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return None
    
    @staticmethod
    def register(data: dict) -> tuple:
        """
        Register a user.
        Args:
            data: The data of the user to register.
        Returns:
            A tuple containing a boolean and a token.
        """
        
        user = UserManager.get_user(data['username'])
        if user:
            return False, None  
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (data['username'], sha256(data['password'].encode()).hexdigest())) 
            cursor.execute("SELECT id FROM users WHERE username = %s", (data['username'],))
            user_id = int(cursor.fetchone()['id'])               
            token = uuid.uuid4().hex
            cursor.execute("INSERT INTO sessions (user_id, token) VALUES (%s, %s)", (user_id, token))
            g.db.commit()
            cursor.close()
            return True, token
        except mysql.connector.Error as e:
            current_app.logger.error(f"Error: {e}")
            return False, None
        
    @staticmethod
    def login(data: dict) -> tuple:
        """
        Login a user.
        Args:
            data: The data of the user to login.
        Returns:
            A tuple containing a boolean and a token.
        """
        
        user = UserManager.get_user(data['username'])
        if user and user.password == sha256(data['password'].encode()).hexdigest():
            if 'db' not in g:
                g.db = DB_utils.get_db_connection()
            
            try:
                cursor = g.db.cursor(dictionary=True)
                cursor.execute("SELECT token FROM sessions WHERE user_id = %s", (user.id,))
                token = cursor.fetchone()
                if token:
                    return True, token['token']
                token = uuid.uuid4().hex
                cursor.execute("INSERT INTO sessions (user_id, token) VALUES (%s, %s)", (user.id, token))
                g.db.commit()
                cursor.close()
                return True, token
            except mysql.connector.Error as e:
                current_app.logger.error(f"Error: {e}")
                return False, None
        return False, None
    
###################################################################################################################

######### DIRECTOR PART ###########################################################################################

class Director:
    def __init__(self, id:int, name: str, image_url: str) -> None:
        self.id = id
        self.name = name
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
            return [Director(director['id'], director['name'], director['image_url']) for director in result]
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return []
        
    def get_director_by_id(id: int) -> Director:
        """
        Get a director from the database.
        Args:
            id: The id of the director to get.
        Returns:
            The director object if found, None otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT * FROM directors WHERE id = %s", (id,))
            result = cursor.fetchone()
            cursor.close()
            if result:
                return Director(result['id'], result['name'], result['image_url'])
            return None
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return None
    
    @staticmethod
    def get_directors_from_category(category: str):
        """
        Get all directors from a category.
        Args:
            category: The category of the directors.
        Returns:
            A list of director objects.
        """
        
        l = []
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT id FROM categories WHERE name = %s", (category,))
            result = cursor.fetchone()
            
            if result:
                cursor.execute("SELECT * FROM directors_categories WHERE category_id = %s", (result['id'],))
                result = cursor.fetchall()
                
                for link in result:
                    cursor.execute("SELECT * FROM directors WHERE id = %s", (link['director_id'],))
                    director = cursor.fetchone()
                    l.append(Director(director['id'], director['name'], director['image_url']))
            
            cursor.close()
            return l
        
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
                return Director(result['id'], result['name'], result['image_url'])
            return None
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return None
        
    @staticmethod
    def search_director(name: str) -> list:
        """
        Search for a director in the database.
        Args:
            name: The name of the director to search for.
        Returns:
            The director object list if found, [] otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT * FROM directors WHERE name = %s", (f"%{name}%",))
            result = cursor.fetchall()
            cursor.close()
            return [Director(director['id'], director['name'], director['image_url']) for director in result]
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return []
        
###################################################################################################################

######### MOVIE PART ##############################################################################################

class Movie:
    def __init__(self, title: str, director_id: str, year: int, image_url: str) -> None:
        self.title = title
        self.director_id = director_id
        self.year = year
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
            return [Movie(movie['title'], movie['director_id'], movie['year'], movie['image_url']) for movie in result]
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
                return Movie(result['title'], result['director_id'], result['year'], result['image_url'])
            return None
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return None
    
    @staticmethod
    def search_movie(title: str) -> list:
        """
        Search for a movie in the database.
        Args:
            title: The title of the movie to search for.
        Returns:
            The movie object list if found, [] otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT * FROM movies WHERE title LIKE %s", (f"%{title}%",))
            result = cursor.fetchall()
            cursor.close()  
            return [Movie(movie['title'], movie['director_id'], movie['year'], movie['image_url']) for movie in result]
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return []
    
    @staticmethod
    def get_movies_from_category(category: str) -> list:
        """
        Get all movies from a category.
        Args:
            category: The category of the movies.
        Returns:
            A list of movie objects.
        """
        
        l = []
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT id FROM categories WHERE name = %s", (category,))
            result = cursor.fetchone()
            
            if result:
                cursor.execute("SELECT * FROM movies_categories WHERE category_id = %s", (result['id'],))
                result = cursor.fetchall()
                
                for link in result:
                    cursor.execute("SELECT * FROM movies WHERE id = %s", (link['movie_id'],))
                    movie = cursor.fetchone()
                    l.append(Movie(movie['title'], movie['director_id'], movie['year'], movie['image_url']))
            
            cursor.close()
            return l
        
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return []
            
        
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
            return [Movie(movie['title'], movie['director_id'], movie['year'], movie['image_url']) for movie in result]
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
            cursor.execute("INSERT INTO movies (title, director, year) VALUES (%s, %s, %s, %s)", (movie.title, movie.director, movie.year, movie.image_url))
            g.db.commit()
            return True
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return False

###################################################################################################################

