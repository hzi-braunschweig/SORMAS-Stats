import datetime as dt
import os

import psycopg2

from stats.models import CasesPerDay

#todo cleanup

def sormas_db_connect(host="postgres", port="5432", dbname="sormas", user="sormas_reader", password="password"):
    conn = psycopg2.connect(host=host, port=port, dbname=dbname, user=user, password=password)
    return conn


def import_cases_per_day():
    when = dt.date.today()
    with sormas_db_connect(host=os.getenv('DB_HOST', 'localhost')) as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT reportdate::date AS date, "
                "COUNT(id) FROM cases "
                "WHERE disease = 'CORONAVIRUS' AND reportdate::date = %s GROUP BY date;",
                [when])
            res = cur.fetchone()
            if res is not None:
                CasesPerDay.objects.create(date=res[0], number=res[1])
            return res
