from django.db import connections

from stats.models import CasesPerDay as CasesPerDayModel
from stats.statistics.crunch.base import Stats


class CasesPerDay(Stats):

    def fetch(self):
        with connections['sormas'].cursor() as cur:
            cur.execute(
                "SELECT reportdate::date AS date, COUNT(id) AS count "
                "FROM cases "
                "WHERE disease = 'CORONAVIRUS' "
                "GROUP BY date;"
            )
            self.fetched = cur.fetchall()

    def compute(self):
        self.computed = self.fetched

    def store(self):
        results = self.computed
        for result in results:
            store = CasesPerDayModel(*result)
            store.save()
