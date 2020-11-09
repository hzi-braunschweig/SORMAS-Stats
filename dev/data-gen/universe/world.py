import random
from datetime import timedelta

from sormas import Disease

from generator.person import gen_person_dto
from generator.utils import dnow
from universe.case import Case
from universe.contact import Contact
from universe.infected import Infected
from universe.tick import Tick
from universe.util import export

random.seed(42)


class World:
    def __init__(self, beginning):
        self.today = Tick(beginning)
        self.history = list()

    def add_district(self, district):
        raise NotImplementedError()

    def pre_populate_susceptible(self, n=5):
        for _ in range(n):
            p = gen_person_dto()
            self.today.susceptible.append(p)

    def pre_populate_infected(self, n=5):
        for _ in range(n):
            person = gen_person_dto()
            case = Infected(person, Disease.CORONAVIRUS)
            self.today.infected.append(case)

    # todo Create individual cases that reproduce the
    #  aggregated data from covid dashboard and SurvStat
    def pre_populate_cases(self, n=5):
        for _ in range(n):
            person = gen_person_dto()
            case = Case(dnow(), person, Disease.CORONAVIRUS)
            self.today.cases.append(case)

    def pre_populate_infection_chains(self):
        pass

    def pre_populate_contacts(self, n=5):
        for _ in range(n):
            person = gen_person_dto()
            source_case: Case = random.choice(self.today.cases)
            case = Contact(person, source_case.inner.uuid, Disease.CORONAVIRUS)
            self.today.contacts.append(case)

    def pre_populate_events(self):
        pass

    def start(self, disease=Disease.CORONAVIRUS):
        # todo needs rework regardin simuate and tick
        patient_zero = self.today.susceptible.pop()
        case_zero = Case(self.today.date, patient_zero, disease)
        self.today.infected.append(case_zero)
        # make the first tick

        today: Tick = self.today
        self.history.append(today)
        self.today = Tick(
            today.date + timedelta(days=1),
            susceptible=today.susceptible,
            infected=today.infected,
            removed=today.removed
        )

    def stop(self):
        self.history.append(self.today)

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

    def _new_day(self):
        pass

    def _tick(self):
        """
        Make one day pass. Take the current state and evolve based on the predefined statistical values.
        """

        self.history.append(self.today)

        tomorrow = self.today
        tomorrow.date = self.today.date + timedelta(days=1)
        self.today = tomorrow
        # right now one person infects exactly one other persons and is removed
        # this will of course be changed to the correct values extracted from the live date

        today = self.today

        while today.cases:
            # get an infected person
            source_case = today.cases.pop()

            susceptible = today.susceptible.pop()
            new_case = Case(today.date, susceptible, source_case.disease())
            today.cases.append(new_case)
            today.removed.append(source_case)
