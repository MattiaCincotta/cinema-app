from flask import Flask, request, jsonify, g
from db_utils.db import DB_utils
from dotenv import load_dotenv
import mysql.connector
app = Flask(__name__)   

@app.route('/')
def index():
    if 'db' not in g:
        g.db = DB_utils.get_db_connection()
        
    try:
        cursor = g.db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM movies")
        result = cursor.fetchall()
        return jsonify(result)
    except mysql.connector.Error as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)})

@app.teardown_appcontext
def close_db(exception):
    db = g.pop('db', None)
    
    if db is not None:
        db.close()

if __name__ == "__main__":
    load_dotenv()
    DB_utils.init_db()
    app.run(debug=True)                         