import mysql.connector, os
from mysql.connector import Error

class DB_utils:                           
    def __init__(self) -> None:
        pass
    
    connection = None
    @staticmethod
    def get_db_connection():
        """
        Create a new database connection using the configured settings.
        Returns:
            connection: MySQLConnection object if successful, None otherwise.
        """
        
        db_config = {
            'host': os.getenv('MYSQL_HOST'),
            'user': os.getenv('MYSQL_USER'),
            'password': os.getenv('MYSQL_PASSWORD'),
            'database': os.getenv('MYSQL_DATABASE'),
            # 'collation': os.getenv('DB_COLLATION'),
            # 'charset': os.getenv('DB_CHARSET')
        }
        
        try:
            connection = mysql.connector.connect(**db_config)                           
            if connection.is_connected():
                print("Connection successful")
            return connection
        except Error as e:
            print(f"Error: {e}")
            return None