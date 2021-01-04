import sys
sys.path.append('srv/src/python/db/')

from db import sormas_db as db

def main():
    with db.sormas_db_connect() as conn:
        with conn.cursor() as cur:
            cur.execute('SELECT version()')
            print(cur.fetchone())


if __name__ == "__main__":
    main()
