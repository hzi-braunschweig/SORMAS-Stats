from sormas import UserReferenceDto

from generator.utils import sormas_db_connect


def surv_sup_user_ref():
    with sormas_db_connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT uuid FROM users WHERE firstname = 'Surveillance' AND lastname = 'Supervisor'")
            uuid = cur.fetchone()[0]
            return UserReferenceDto(uuid=uuid)
