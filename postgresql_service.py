import logging

import pg8000

from config import POSTGRESQL_CONFIG

logger = logging.getLogger(__name__)


def get_postgresql_connection():
    """Establish and return a PostgreSQL connection."""
    try:
        connection = pg8000.connect(**POSTGRESQL_CONFIG)
        logging.info("PostgreSQL connection established successfully.")
        return connection
    except pg8000.Error as e:
        logging.error(f"Error connecting to PostgreSQL: {e}")
        return None


def run_sql_file_postgresql(file_path):
    """Read and execute SQL statements from a file."""
    connection = None
    cursor = None

    try:
        connection = get_postgresql_connection()
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

    except pg8000.Error as err:
        logging.error(f"PostgreSQL error during SQL file execution: {err}")
    except Exception as e:
        logging.error(f"Unexpected error during SQL file execution: {e}")
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()
