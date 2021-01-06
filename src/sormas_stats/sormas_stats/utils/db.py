from collections import namedtuple


def named_tuple_fetchone(cursor):
    """
    Return a row from a cursor as a namedtuple
    """
    desc = cursor.description
    nt_result = namedtuple('Result', [col[0] for col in desc])
    row = cursor.fetchone()
    return nt_result(*row)


def named_tuple_fetchall(cursor):
    """
    Return all rows from a cursor as a namedtuple
    """
    desc = cursor.description
    nt_result = namedtuple('Result', [col[0] for col in desc])
    return [nt_result(*row) for row in cursor.fetchall()]


def dict_fetchall(cursor):
    """
    Return all rows from a cursor as a dict
    """
    columns = [col[0] for col in cursor.description]
    return [
        dict(zip(columns, row))
        for row in cursor.fetchall()
    ]
