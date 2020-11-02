from sormas import CaseDataDto, Disease, \
    CaseClassification, InvestigationStatus

from generators.gen_district import district_ref
from generators.gen_facility import facility_ref
from generators.gen_person import person_ref
from generators.gen_region import region_ref
from generators.gen_user import user_ref
from generators.utils import dnow, duuid


def case():
    case_dto = CaseDataDto(
        uuid=duuid(),
        disease=Disease.CORONAVIRUS,
        person=person_ref(),
        report_date=dnow(),
        reporting_user=user_ref(),
        case_classification=CaseClassification.CONFIRMED,
        investigation_status=InvestigationStatus.PENDING,
        region=region_ref(),
        district=district_ref(),
        health_facility=facility_ref()
    )
    return case_dto
