from flask import Flask, request, g
from flask.json import jsonify
from utils.models import *

api = Flask(__name__, '/api')   

@api.route('/register', methods=['POST'])
def register():
    data = request.json
    success, token = UserManager.register(data)
    if success:
        return jsonify({"token":token}), 200      
    else:
        return jsonify("username already exists"), 400

@api.route('/login', methods=['POST'])
def login():
    data = request.json
    success, token = UserManager.login(data)
    if success:
        return jsonify({"token":token}), 200
    else:
        return jsonify("invalid username or password"), 400

@api.route('/director/movies', methods=['GET'])
def director_movies():
    if UserManager.verify_token(request.headers.get('token'), True):
        director_name = request.args.get('director')
        director = DirectorManager.get_director(director_name)
        if director:    
            result = MovieManager.get_movies_from_director(director)
            
            return jsonify([movie.__dict__ for movie in result]), 200
        
        else:   
            return jsonify([]), 400
    else:
            return jsonify("invalid token"), 401

@api.route('/search/movie', methods=['GET'])
def search_movie():
    if UserManager.verify_token(request.headers.get('token'), True):
        title = request.args.get('title')
        result = MovieManager.search_movie(title)
        if result:
            return jsonify([movie.__dict__ for movie in result]), 200
        else:
            return jsonify({}), 404
    else:
        return jsonify("invalid token"), 401

@api.route('/search/director', methods=['GET'])
def search_director():
    if UserManager.verify_token(request.headers.get('token'), True):
        name = request.args.get('name')
        result = DirectorManager.search_director(name)
        if result:
            return jsonify([director.__dict__ for director in result]), 200
        else:
            return jsonify([]), 404
    else:
        return jsonify("invalid token"), 401

@api.route('/movies/category', methods=['GET'])
def movies_category():
    if UserManager.verify_token(request.headers.get('token'), True):
        category = request.args.get('category')
        result = MovieManager.get_movies_from_category(category)
        if result:
            return jsonify([movie.__dict__ for movie in result]), 200
        else:
            return jsonify([]), 400
    else:
        return jsonify("invalid token"), 401

@api.route('/directors/category', methods=['POST'])
def directors_category():
    if UserManager.verify_token(request.headers.get('token'), True):
        data = request.json
        if data and isinstance(data["category"], list):
            result = DirectorManager.get_directors_from_category(data['category'])
            if result:
                return jsonify({"directors": [director.__dict__ for director in result]}), 200
        return jsonify([]), 400
    return jsonify("invalid token"), 401

@api.route('/directors', methods=['GET'])
def directors():
    if UserManager.verify_token(request.headers.get('token'), True):
        result = DirectorManager.get_directors()
        if result:
            return jsonify({"count": len(result), "directors": [director.__dict__ for director in result]}), 200
        else:
            return jsonify([]), 400
    else:
        return jsonify("invalid token"), 401

@api.route('/director', methods=['GET'])
def director():
    if UserManager.verify_token(request.headers.get('token'), True):
        director_name = request.args.get('director')
        result = DirectorManager.get_director(director_name)
        if result:
            return jsonify(result.__dict__), 200
        else:
            return jsonify({}), 400
    else:
        return jsonify("invalid token"), 401

@api.route('/favorites', methods=['GET'])
def getFavorites():
    if UserManager.verify_token(request.headers.get('token'), True):
        user = UserManager.get_user_by_token(request.headers.get('token'))
        movie_id = request.args.get('id')

        if movie_id:
            result = MovieManager.is_favorite(user, int(movie_id))
            return jsonify("true" if result else "false"), 200
            
        result = MovieManager.get_favorites(user)
        if result:
            return jsonify([movie.__dict__ for movie in result]), 200
        else:
            return jsonify([]), 400
    else:
        return jsonify("invalid token"), 401
        
@api.route('/remove_favorite', methods=['POST'])
def remove_favorite():
    if UserManager.verify_token(request.headers.get('token'), True):
        data = request.json
        movie = MovieManager.get_movie(data['title'])
        user = UserManager.get_user_by_token(request.headers.get('token'))
        
        success = MovieManager.remove_favorite(user, movie)
        if success:
            return jsonify("favorite removed"), 200
        else:
            return jsonify("error while removing"), 400
    else:
        return jsonify("invalid token"), 401
    
@api.route('/add_favorite', methods=['POST'])
def add_favorite():
    if UserManager.verify_token(request.headers.get('token'), True):
        data = request.json
        movie = MovieManager.get_movie(data['title'])
        user = UserManager.get_user_by_token(request.headers.get('token'))
        
        success = MovieManager.add_favorite(user, movie)
        if success:
            return jsonify("favorite added"), 200
        else:
            return jsonify("error while adding"), 400
    else:
        return jsonify("invalid token"), 401

@api.route('/seen_movies', methods=['GET'])
def getSeenMovies():
    if UserManager.verify_token(request.headers.get('token'), True):
        user = UserManager.get_user_by_token(request.headers.get('token'))
        result = MovieManager.get_seen_movies(user)
        movie_id = request.args.get('id')
        if movie_id:
            result = MovieManager.is_seen(user, int(movie_id))
            return jsonify("true" if result else "false"), 200
        
        if result:
            return jsonify([movie.__dict__ for movie in result]), 200
        else:
            return jsonify([]), 400

    else:
        return jsonify("invalid token"), 401

@api.route('/remove_seen', methods=['POST'])
def remove_seen():
    if UserManager.verify_token(request.headers.get('token'), True):
        data = request.json
        movie = MovieManager.get_movie(data['title'])
        user = UserManager.get_user_by_token(request.headers.get('token'))
        
        success = MovieManager.remove_seen_movie(user, movie)
        if success:
            return jsonify("seen removed"), 200
        else:
            return jsonify("error while removing"), 400
    else:
        return jsonify("invalid token"), 401

@api.route('/add_seen', methods=['POST'])
def add_seen():
    if UserManager.verify_token(request.headers.get('token'), True):
        data = request.json
        movie = MovieManager.get_movie(data['title'])
        user = UserManager.get_user_by_token(request.headers.get('token'))
        
        success = MovieManager.add_seen_movie(user, movie)
        if success:
            return jsonify("seen added"), 200
        else:
            return jsonify("error while adding"), 400
    else:
        return jsonify("invalid token"), 401

@api.route('/director/<id>/biography', methods=['GET'])
def get_director_biography(id):
    if UserManager.verify_token(request.headers.get('token'), True):
        if not isinstance(id, int):
            return jsonify("invalid id"), 400
        result = DirectorManager.get_director_by_id(id)
        
        if result is not None:
            result = result.get_biography()
        else:
            return jsonify("invalid director id"), 400
        
        if result is not None:
            return jsonify({"biography": result,}), 200
        else:
            return jsonify({}), 400
    else:
        return jsonify("invalid token"), 401

@api.route('/movies', methods=['POST'])
def add_movie():
    """
    Add a movie to the database
    """
    if not UserManager.verify_token(request.headers.get('token'), True):
        return jsonify("invalid token"), 401
    
    data = request.get_json()
    if data and isinstance(data['title'], str) and isinstance(data['year'], int) and isinstance(data['image_url'], str) and isinstance(data['director_id'], int):
        success = MovieManager.add_movie(Movie(0, data['title'], data['director_id'], data['year'], data['image_url']))
        if success:
            return jsonify("movie added"), 200
    return jsonify("error while adding"), 400

@api.route('/directors', methods=['POST'])
def add_director():
    """ 
    Add a Director to the database
    """
    if not UserManager.verify_token(request.headers.get('token'), True):
        return jsonify("invalid token"), 401
    
    data = request.get_json()
    if data and isinstance(data['name'], str) and isinstance(data['biography'], str) and isinstance(data['image_url'], str) and isinstance(data['categories_id'], list[str]):
        success = DirectorManager.add_director(Director(0, data['name'], data['image_url']), data['biography'], data['categories_id'])
        if success:
            return jsonify("director added"), 200
    return jsonify("error while adding"), 400

@api.teardown_appcontext
def close_db(exception):
    db = g.pop('db', None)
    
    if db is not None:
        db.close()

if __name__ == "__main__":
    api.run("0.0.0.0", debug=True)
