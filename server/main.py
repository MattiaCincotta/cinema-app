from flask import Flask, request, jsonify, g
from utils.models import *

api = Flask(__name__, '/api')   

@api.route('/director_movies', methods=['GET'])
def director_movies():
    director_name = request.args.get('director')
    director = DirectorManager.get_director(director_name)
    if director:    
        result = MovieManager.get_movies_from_director(director)
        
        return jsonify([movie.__dict__ for movie in result]), 200
    
    else:   
        return jsonify([]), 400

@api.route('/search_movie', methods=['GET'])
def search_movie():
    title = request.args.get('title')
    result = MovieManager.search_movie(title)
    if result:
        return jsonify([movie.__dict__ for movie in result]), 200
    else:
        return jsonify({}), 404

@api.route('/search_director', methods=['GET'])
def search_director():
    name = request.args.get('name')
    result = DirectorManager.search_director(name)
    if result:
        return jsonify([director.__dict__ for director in result]), 200
    else:
        return jsonify([]), 404

@api.route('/movies_category', methods=['GET'])
def movies_category():
    category = request.args.get('category')
    result = MovieManager.get_movies_from_category(category)
    if result:
        return jsonify([movie.__dict__ for movie in result])
    else:
        return jsonify([])

@api.route('/directors_category', methods=['GET'])
def directors_category():
    category = request.args.get('category')
    result = DirectorManager.get_directors_from_category(category)
    if result:
        return jsonify([director.__dict__ for director in result])
    else:
        return jsonify([])
    
@api.route('/director', methods=['GET'])
def director():
    director_id = request.args.get('director_id')
    result = DirectorManager.get_director_by_id(director_id)
    if result:
        return jsonify(result.__dict__), 200
    else:
        return jsonify({}), 400

@api.teardown_appcontext
def close_db(exception):
    db = g.pop('db', None)
    
    if db is not None:
        db.close()

if __name__ == "__main__":
    api.run("0.0.0.0", debug=True)