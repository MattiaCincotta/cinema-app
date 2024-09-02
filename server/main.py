from flask import Flask, request, jsonify, g
from db_utils.db import DB_utils
from dotenv import load_dotenv
import mysql.connector, utils
app = Flask(__name__)   

@app.route('/')
def index():
    return "Hello, World!"
    # utils.UserManager.add_user(utils.User("test", "password"))
    # return utils.UserManager.get_user("test").username     

@app.teardown_appcontext
def close_db(exception):
    db = g.pop('db', None)
    
    if db is not None:
        db.close()

if __name__ == "__main__":
    load_dotenv()
    DB_utils.init_db()
    app.run(debug=True)                         