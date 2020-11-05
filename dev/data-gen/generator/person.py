import random
from random import choice

from sormas import PersonReferenceDto, Sex

from generator.utils import duuid
from universe.person import Person

random.seed(0)

# Maximum age that can be generated
max_age = 95

# todo BEGIN only german names for now b/c residence abroad cannot be displayed
male_first_names = [
    'Peter', 'Wolfgang', 'Michael', 'Werner', 'Klaus', 'Thomas',
    'Manfred', 'Helmut', 'Jürgen', 'Heinz', 'Gerhard', 'Andreas', 'Hans',
    'Josef', 'Günter', 'Dieter', 'Horst', 'Walter', 'Frank', 'Bernd', 'Karl',
    'Herbert', 'Franz ', 'Mehmet', 'Mustafa', 'Piotr', 'Krzysztof'
]
female_first_names = [
    'Maria', 'Ursula', 'Monika', 'Petra', 'Elisabeth', 'Sabine', 'Renate',
    'Helga', 'Karin', 'Brigitte', 'Ingrid', 'Erika', 'Andrea', 'Gisela',
    'Claudia', 'Susanne', 'Gabriele', 'Christa', 'Christine', 'Hildegard',
    'Anna', 'Birgit', 'Fatma', 'Ayşe '
]
last_names = [
    'Müller', 'Schmidt', 'Schneider', 'Fischer', 'Weber', 'Meyer',
    'Wagner', 'Becker', 'Schulz', 'Hoffmann', 'Schäfer', 'Koch', 'Bauer',
    'Richter', 'Klein', 'Wolf', 'Schröder', 'Neumann', 'Schwarz', 'Zimmermann',
    'Braun', 'Krüger', 'Hofmann', 'Yılmaz', 'Kaya', 'Nowak', 'Kowalski'
]
# todo END

# todo I don't now how state that a person does not live inside the jurisdiction/country of SORMAS
# todo I don't if this is even possible
# Default country of residence
default_country = 'Deutschland'
# Foreign country of residence taken as example
foreign_country = 'Frankreich'
# Probability that a case has residence abroad
p_foreign_country = 0.05


# todo END


def assign_age_from_rki_age_group(ag_vec, m_a):
    # Draws a random age in each age group of the vector `ag_vec` uniformly at
    # random. For the last age group "A80+", a maximum age of `m_a` is taken.
    # Specific to the way age groups are coded in RKI's corona dashboard
    # todo do this statically without the need of parsing a file each and every time we run the script
    pass


def assign_address():
    # todo
    pass


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
