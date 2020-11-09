import uuid
from datetime import datetime

import psycopg2


def sormas_db_connect(host="localhost", port="5432", dbname="sormas", user="sormas_reader", password="password"):
    conn = psycopg2.connect(host=host, port=port, dbname=dbname, user=user, password=password)
    return conn


def duuid():
    #todo make det. again
    # tmp = str(uuid.UUID(int=random.getrandbits(128)))
    tmp = str(uuid.uuid4())
    return tmp


def dnow():
    # FIXME(@JonasCir) make deterministic
    return datetime.now()
