import random
from datetime import timedelta

from sormas import Disease

from generator.person import gen_person_dto
from universe.case import Case
from universe.tick import Tick
from universe.util import export

random.seed(42)


class World:
    def __init__(self, beginning):
        self.susceptible = list()
        self.infected = list()
        self.removed = list()
        self.beginning = beginning
        self.today = beginning
        self.history = list()

    def add_region(self, region):
        print(f"Adding {region} to world")

    def populate(self, n=5):
        for _ in range(n):
            p = gen_person_dto()
            self.susceptible.append(p)

    def patient_zero(self, disease=Disease.CORONAVIRUS):
        patient_zero = self.susceptible.pop()
        case_zero = Case(self.beginning, patient_zero, disease)
        self.infected.append(case_zero)
        # make the first tick
        first_tick = Tick(self.beginning, cases=[case_zero])

        self.history.append(first_tick)

    def simulate(self, ticks=3):
        """
        Simulate the spread of the disease.
        :param ticks: For how many days the simulation should run.
        """
        for _ in range(ticks):
            self._tick()

    def export_sormas(self):
        export.sormas(self)

    def export_json(self):
        export.json(self)

    def _tick(self):
        """
        Make one day pass. Take the current state and evolve based on the predefined statistical values.
        """

        # A new day!
        self.today = self.today + timedelta(days=1)

        today_tick = Tick(self.today, [])

        # right now one person infects exactly one other persons and is removed
        # this will of course be changed to the correct values extracted from the live date
        infected = self.infected
        i = len(infected)
        while i > 0:
            # get a case
            case = infected.pop()

            # get a contact
            contact = self.susceptible.pop()

            # infect contact
            new_case = Case(self.today, contact, case.disease())
            self.infected.append(new_case)

            # remove source case
            self.removed.append(case)

            # record what happens today
            today_tick.cases.append(new_case)

            i = i - 1

        # make history
        self.history.append(today_tick)