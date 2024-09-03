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
            'host': os.getenv('DB_HOST'),
            'user': os.getenv('DB_USER'),
            'port': os.getenv('DB_PORT'),
            'password': os.getenv('DB_PASSWORD'),
            'database': os.getenv('DB_NAME'),
            'collation': os.getenv('DB_COLLATION'),
            'charset': os.getenv('DB_CHARSET')
        }
        
        try:
            connection = mysql.connector.connect(**db_config)                           
            if connection.is_connected():
                print("Connection successful")
            return connection
        except Error as e:
            print(f"Error: {e}")
            return None
    
    @staticmethod  
    def init_db() -> bool:
        """
        Initialize the database and its connection.                             
        Returns:
            The result of the initialization query (True if successfull / False if not).
        """
        
        try:
            connection = DB_utils.get_db_connection()
            cursor = connection.cursor()

            for result in cursor.execute(open(os.path.join(os.getcwd(), 'db_utils', 'init.sql'), 'r').read(), multi=True):
                if result.with_rows:
                    pass
                    #print(f"Rows produced by statement '{result.statement}': {result.fetchall()}")
                else:
                    pass
                    #print(f"Number of rows affected by statement '{result.statement}': {result.rowcount}")
            connection.commit()     
            
            cursor.close()
            connection.close()
            print("Database initialized successfully")  
            return True
        except Error as e:     
            print(f"Error: {e}")
            return False
