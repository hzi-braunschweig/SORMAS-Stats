from sormas import PersonDto, PersonReferenceDto

from generators.utils import duuid


def create_person():
    person_dto = PersonDto(
        uuid=duuid(),
        first_name="John",
    )
    return person_dto


def person_ref():
    person_ref_dto = PersonReferenceDto()
    return person_ref_dto
