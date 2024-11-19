import logging

import mysql.connector

from config import MYSQL_CONFIG

logger = logging.getLogger(__name__)


def get_mysql_connection():
    """Establish and return a MySQL connection."""
    try:
        connection = mysql.connector.connect(**MYSQL_CONFIG)
        logging.info("MySQL connection established successfully.")
        return connection
    except mysql.connector.Error as e:
        logging.error(f"Error connecting to MySQL: {e}")
        return None


def run_sql_file_mysql(file_path):
    """Read and execute SQL statements from a file."""
    connection = None
    cursor = None

    try:
        connection = get_mysql_connection()
        if connection:
            cursor = connection.cursor()

            with open(file_path, 'r') as file:
                sql = file.read()

            statements = sql.split(';')
            for statement in statements:
                if statement.strip():
                    cursor.execute(statement)
            connection.commit()

            logging.info(f"SQL file {file_path} executed successfully.")

    except mysql.connector.Error as err:
        logging.error(f"MySQL error during SQL file execution: {err}")
    except Exception as e:
        logging.error(f"Unexpected error during SQL file execution: {e}")
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()
