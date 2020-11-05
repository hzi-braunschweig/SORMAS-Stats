from sormas import RegionReferenceDto

from generator.utils import sormas_db_connect


def default_region():
    with sormas_db_connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT uuid FROM region")
            uuid = cur.fetchone()[0]
            return RegionReferenceDto(uuid=uuid)
