from flask import Flask, request, jsonify, g
from db_utils.db import DB_utils
from dotenv import load_dotenv
import mysql.connector
from utils import *

app = Flask(__name__)   

@app.route('/director_movies', methods=['GET'])
def index():
    director_name = request.args.get('director')
    director = DirectorManager.get_director(director_name)
    if director:    
        result = MovieManager.get_movies_from_director(director)
        
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