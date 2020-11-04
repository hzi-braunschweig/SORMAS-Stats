from sormas import DistrictReferenceDto

from generators.utils import sormas_db_connect


def district_ref():
    with sormas_db_connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT uuid FROM district")
            uuid = cur.fetchone()[0]
            return DistrictReferenceDto(uuid=uuid)
