import psycopg2

def sormas_db_connect(host="postgres", port="5432", dbname="sormas", user="sormas_reader", password="password"):
    conn = psycopg2.connect(host=host, port=port, dbname=dbname, user=user, password=password)
    return conn
