from sormas import PersonDto, PersonReferenceDto

from generators.utils import duuid


def create_person():
    uuid = duuid()
    person_dto = PersonDto(
        uuid=uuid,
        first_name="John",
        last_name="Doe"
    )
    return person_dto


def person_ref(p_uuid):
    person_ref_dto = PersonReferenceDto(uuid=p_uuid)
    return person_ref_dto
