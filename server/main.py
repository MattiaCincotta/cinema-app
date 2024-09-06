from flask import Flask, request, jsonify, g
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
            return jsonify([movie.__dict__ for movie in result])
        else:
            return jsonify([])
    else:
        return jsonify("invalid token"), 401

@api.route('/directors/category', methods=['GET'])
def directors_category():
    if UserManager.verify_token(request.headers.get('token'), True):
        category = request.args.get('category')
        result = DirectorManager.get_directors_from_category(category)
        if result:
            return jsonify([director.__dict__ for director in result])
        else:
            return jsonify([])
    else:
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

@api.teardown_appcontext
def close_db(exception):
    db = g.pop('db', None)
    
    if db is not None:
        db.close()

if __name__ == "__main__":
    api.run("0.0.0.0", debug=True)