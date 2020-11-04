from sormas import CaseDataDto, Disease, \
    CaseClassification, InvestigationStatus

from generators.gen_district import district_ref
from generators.gen_facility import facility_ref
from generators.gen_person import person_ref
from generators.gen_region import region_ref
from generators.gen_user import user_ref
from generators.utils import dnow, duuid


def create_case(p_uuid):
    now = dnow()
    case_dto = CaseDataDto(
        uuid=duuid(),
        disease=Disease.CORONAVIRUS,
        person=person_ref(p_uuid),  # FIXME case can be pushed without the person existing
        report_date=dnow(),
        change_date=now,  # FIXME not annotated as required
        creation_date=now,  # FIXME not annotated as required
        reporting_user=user_ref(),
        case_classification=CaseClassification.CONFIRMED,
        investigation_status=InvestigationStatus.PENDING,
        region=region_ref(),
        district=district_ref(),
        health_facility=facility_ref(),  # FIXME not required, somewhat validated but without telling the user
        health_facility_details="Home",  # FIXME not required, somewhat validated but without telling the user
    )
    return case_dto
