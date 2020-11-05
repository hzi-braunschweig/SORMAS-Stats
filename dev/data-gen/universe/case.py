from generator.cases import gen_case_dto


class Case:
    def __init__(self, date, person, disease):
        self.person = person
        self.inner = gen_case_dto(date, person.uuid, disease)

    def __str__(self):
        return f"({self.inner.disease}: {self.person})"

    def __repr__(self):
        return self.__str__()

    def disease(self):
        # todo can python do delegation?
        return self.inner.disease

    def to_dict(self):
        return {
            "person": self.person.to_dict(),
            "inner": self.inner.to_dict()
        }
