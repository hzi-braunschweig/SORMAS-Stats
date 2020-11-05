import random
from random import choice

from sormas import PersonReferenceDto, Sex

from generator.utils import duuid
from universe.person import Person

random.seed(0)

male_first_names = ['Peter', 'Bob', 'Daniel']
female_first_names = ['Lisa', 'Lara', 'Anna']
last_names = ['Bauer', 'Mann', 'Maurer']


def gen_person_dto(first_name=None, last_name=None, sex=None):
    if sex is None:
        sex = choice([Sex.MALE, Sex.FEMALE])
    if first_name is None:
        first_name = choice(male_first_names) if sex is Sex.MALE else choice(female_first_names)
    if last_name is None:
        last_name = choice(last_names)

    uuid = duuid()

    # Person extends PersonDto, but Person overwrites __str__ for better debugging
    person_dto = Person(
        uuid=uuid,
        sex=sex,
        first_name=first_name,
        last_name=last_name,
    )
    return person_dto


def person_ref(p_uuid):
    person_ref_dto = PersonReferenceDto(uuid=p_uuid)
    return person_ref_dto
