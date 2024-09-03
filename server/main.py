from flask import Flask, request, jsonify, g
from db_utils.db import DB_utils
from dotenv import load_dotenv
import mysql.connector
from utils import *

app = Flask(__name__)   

@app.route('/director_movies', methods=['GET'])
def director_movies():
    director_name = request.args.get('director')
    director = DirectorManager.get_director(director_name)
    if director:    
        result = MovieManager.get_movies_from_director(director)
        
        return jsonify([movie.__dict__ for movie in result])
    
    else:   
        return jsonify([])

@app.route('/search_movie', methods=['GET'])
def movie():
    title = request.args.get('title')
    result = MovieManager.search_movie(title)
    if result:
        return jsonify([movie.__dict__ for movie in result])
    else:
        return jsonify({})

@app.route('/movies_category', methods=['GET'])
def movies_category():
    category = request.args.get('category')
    result = MovieManager.get_movies_from_category(category)
    if result:
        return jsonify([movie.__dict__ for movie in result])
    else:
        return jsonify([])

@app.teardown_appcontext
def close_db(exception):
    db = g.pop('db', None)
    
    if db is not None:
        db.close()

if __name__ == "__main__":
    load_dotenv()
    DB_utils.init_db()
    app.run(debug=True)