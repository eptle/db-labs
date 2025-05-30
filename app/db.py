from config import Config
import psycopg2
from psycopg2.extras import RealDictCursor

def __get_connection():
    return psycopg2.connect(
        dbname = Config.DB_NAME,
        user = Config.DB_USER,
        password = Config.DB_PASSWORD,
        host = Config.DB_HOST,
        port = Config.DB_PORT,
        cursor_factory = RealDictCursor
    )


def execute_query(query, params=None, fetchone=False, fetchall=True, commit=False):
    conn = __get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(query, params)
            if commit:
                conn.commit()
            if fetchone:
                result = cur.fetchone()
            elif fetchall:
                result = cur.fetchall()
            else:
                result = None
    finally:
        conn.close()
    return result