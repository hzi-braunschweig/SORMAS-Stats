from sormas import Disease

from generator.person import gen_person_dto
from universe.case import Case
from universe.tick import Tick
from universe.util import export


class World:
    def __init__(self, beginning):
        self.susceptible = list()
        self.infected = list()
        self.removed = list()
        self.beginning = beginning
        self.history = list()

    def add_region(self, region):
        print(f"Adding {region} to world")

    def populate(self, n=5):
        for _ in range(n):
            p = gen_person_dto()
            self.susceptible.append(p)

    def patient_zero(self, disease=Disease.CORONAVIRUS):
        patient_zero = self.susceptible.pop()
        case_zero = Case(self.beginning,patient_zero, disease)
        self.infected.append(case_zero)
        # make the first tick
        first_tick = Tick(self.beginning, cases=[case_zero])

        self.history.append(first_tick)

    def simulate(self, ticks=3):
        for _ in range(ticks):
            self._tick()

    def export_sormas(self):
        export.sormas(self)

    def export_json(self):
        export.json(self)

    def _tick(self):
        pass
