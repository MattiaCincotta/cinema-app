from flask import current_app, g
import mysql.connector
from db.db import DB_utils
import uuid
from hashlib import sha256

# may god help us writing less shitty code

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
    
    @staticmethod
    def verify_token(token: str, boolean_response = False) -> User | bool | None:
        """
        Verifies a token.
        Args:
            token: The token to verify;
            boolean_response: if true the return value will be a boolean, if false it will be a user object.
        Returns:
            The user object if the token is valid and boolean_response is false, if it is true the boolean result of the query, None otherwise.
        """
        
        if not 'db' in g:
            g.db = DB_utils.get_db_connection()
        
        cursor = g.db.cursor(dictionary=True)
        cursor.execute("SELECT user_id FROM sessions WHERE token = %s", (token,))
        result = cursor.fetchone()
        
        if result:
            if boolean_response:
                return True
            cursor.execute("SELECT * FROM users WHERE id = %s", (result['user_id'],))
            user = cursor.fetchone()
            return User(user['id'], user['username'], user['password'])
        
        else:
            if boolean_response:
                return False
            return None
    
    @staticmethod
    def get_user_by_token(token: str) -> User:
        """
        get a user by token.
        Args:
            token: The token of the user.
        Returns:
            The user object if found, None otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT user_id FROM sessions WHERE token = %s", (token,))
            result = cursor.fetchone()
            if result:
                cursor.execute("SELECT * FROM users WHERE id = %s", (result['user_id'],))
                user = cursor.fetchone()
                cursor.close()
                return User(user['id'], user['username'], user['password'])
            return None
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return None
    
###################################################################################################################

######### DIRECTOR PART ###########################################################################################

class Director:
    def __init__(self, id:int, name: str, image_url: str) -> None:
        self.id = id
        self.name = name
        self.image_url = image_url

    def get_biography(self) -> str | None:
        """
        Get the biography of a director.
        Returns:
            The biography of the director.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT biography FROM directors WHERE id = %s", (self.id,))
            result = cursor.fetchone()
            cursor.close()
            return result
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return None
    
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
    
    @staticmethod
    def get_director_by_id(id: int) -> Director | None:
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
    def get_directors_from_category(category: list):
        """
        Get all directors from a category.
        Args:
            category: The category of the directors.
        Returns:
            A list of director objects.
        """
                
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            placeholders = ','.join(['%s'] * len(category))
            cursor.execute(f"SELECT director_id FROM directors_categories WHERE category_id IN ({placeholders})", category)
            result = cursor.fetchall()
            
            if result:
                director_ids = [entry['director_id'] for entry in result]
                placeholders = ','.join(['%s'] * len(director_ids))
                cursor.execute(f"SELECT * FROM directors WHERE id IN ({placeholders})", director_ids)
                result = cursor.fetchall()

                return [Director(director['id'], director['name'], director['image_url']) for director in result]
            
            cursor.close()
            return []
        
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
    def __init__(self, id: int, title: str, director_id: str, year: int, image_url: str) -> None:
        self.id = id
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
            return [Movie(movie['id'], movie['title'], movie['director_id'], movie['year'], movie['image_url']) for movie in result]
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
                return Movie(result['id'], result['title'], result['director_id'], result['year'], result['image_url'])
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
            return [Movie(movie['id'], movie['title'], movie['director_id'], movie['year'], movie['image_url']) for movie in result]
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
                    l.append(Movie(movie['id'], movie['title'], movie['director_id'], movie['year'], movie['image_url']))
            
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
            return [Movie(movie['id'], movie['title'], movie['director_id'], movie['year'], movie['image_url']) for movie in result]
        except mysql.connector.Error as e:      
            print(f"Error: {e}")
            return []
    
    @staticmethod
    def is_favorite(user: User, movie_id: int) -> bool:
        """
        Check if a movie is in the favorites of a user.
        Args:
            user: The user object.
            movie_id: The movie id.
        Returns:
            True if the movie is in the favorites, False otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT COUNT(*) FROM favorites WHERE user_id = %s AND movie_id = %s", (user.id, movie_id))
            result = cursor.fetchone()
            cursor.close()
            return True if result == 1 else False
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return False
    
    @staticmethod
    def get_favorites(user: User) -> list:
        """
        Get all favorite movies from a user.
        Args:
            user: The user object.
        Returns:
            A list of movie objects.
        """
        
        if'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT movie_id FROM favorites WHERE user_id = %s", (user.id,))
            result = cursor.fetchall()
            l = []
            for link in result:
                cursor.execute("SELECT * FROM movies WHERE id = %s", (link['movie_id'],))
                movie = cursor.fetchone()
                l.append(Movie(movie['id'], movie['title'], movie['director_id'], movie['year'], movie['image_url']))
            cursor.close()
            return l
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return []
    
    @staticmethod
    def is_seen(user: User, movie_id: int) -> bool:
        """
        Check if a movie is in the seen of a user.
        Args:
            user: The user object.
            movie_id: The movie id.
        Returns:
            True if the movie is in the favorites, False otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT COUNT(*) FROM seen WHERE user_id = %s AND movie_id = %s", (user.id, movie_id))
            result = cursor.fetchone()
            cursor.close()
            return True if result == 1 else False
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return False
    
    @staticmethod
    def get_seen_movies(user: User) -> list:
        """
        Get all seen movies from a user.
        Args:
            user: The user object.
        Returns:
            A list of movie objects.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("SELECT movie_id FROM seen WHERE user_id = %s", (user.id,))
            result = cursor.fetchall()
            l = []
            for link in result:
                cursor.execute("SELECT * FROM movies WHERE id = %s", (link['movie_id'],))
                movie = cursor.fetchone()
                l.append(Movie(movie['id'], movie['title'], movie['director_id'], movie['year'], movie['image_url']))
            cursor.close()
            return l
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
        
################################ FAVORITE AND SEEN MOVIES ##########################################
    
    @staticmethod
    def add_favorite(user: User, movie: Movie) -> bool:
        """
        Add a movie to the favorites of a user.
        Args:
            user: The user object.
            movie: The movie object.
        Returns:
            True if the movie was added successfully, False otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("INSERT INTO favorites (user_id, movie_id) VALUES (%s, %s)", (user.id, movie.id))
            g.db.commit()
            return True
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return False
    
    @staticmethod
    def remove_favorite(user: User, movie: Movie) -> bool:
        """
        Remove a movie from the favorites of a user.
        Args:
            user: The user object.
            movie: The movie object.
        Returns:
            True if the movie was removed successfully, False otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("DELETE FROM favorites WHERE user_id = %s AND movie_id = %s", (user.id, movie.id))
            g.db.commit()
            return True
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return False
    
    @staticmethod
    def add_seen_movie(user: User, movie: Movie) -> bool:
        """
        Add a movie to the seen movies of a user.
        Args:
            user: The user object.
            movie: The movie object.
        Returns:
            True if the movie was added successfully, False otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("INSERT INTO seen_movies (user_id, movie_id) VALUES (%s, %s)", (user.id, movie.id))
            g.db.commit()
            return True
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return False
    
    @staticmethod
    def remove_seen_movie(user: User, movie: Movie) -> bool:
        """
        Remove a movie from the seen movies of a user.
        Args:
            user: The user object.
            movie: The movie object.
        Returns:
            True if the movie was removed successfully, False otherwise.
        """
        
        if 'db' not in g:
            g.db = DB_utils.get_db_connection()
        
        try:
            cursor = g.db.cursor(dictionary=True)
            cursor.execute("DELETE FROM seen_movies WHERE user_id = %s AND movie_id = %s", (user.id, movie.id))
            g.db.commit()
            return True
        except mysql.connector.Error as e:
            print(f"Error: {e}")
            return False

###################################################################################################################

