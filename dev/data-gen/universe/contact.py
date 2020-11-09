# todo make Contact extend the Dto?
from generator.contacts import gen_contact_dto


class Contact:
    def __init__(self, person, case_uuid, disease):
        self.person = person
        self.inner = gen_contact_dto(person.uuid, case_uuid, disease)

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
