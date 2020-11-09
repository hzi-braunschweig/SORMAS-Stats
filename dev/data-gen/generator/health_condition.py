from sormas import HealthConditionsDto

from generator.utils import duuid


def gen_health_condition_dto():
    health_condition_dto = HealthConditionsDto(
        uuid=duuid() # todo must not be null ClinicalCourseFacadeRjb:133
    )
    return health_condition_dto
