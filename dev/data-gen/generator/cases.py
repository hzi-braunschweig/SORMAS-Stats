from datetime import datetime, time

from sormas import CaseDataDto, CaseClassification, InvestigationStatus

from generator.district import default_district
from generator.facility import none_facility_ref
from generator.person import person_ref
from generator.region import default_region
from generator.user import surv_sup_user_ref
from generator.utils import duuid


def gen_case_dto(date, p_uuid, disease):
    date = datetime.combine(date, time(0, 0, 0, ))
    case_dto = CaseDataDto(
        uuid=duuid(),
        disease=disease,
        person=person_ref(p_uuid),  # FIXME case can be pushed without the person existing
        report_date=date,
        change_date=date,  # FIXME not annotated as required
        creation_date=date,  # FIXME not annotated as required
        reporting_user=surv_sup_user_ref(),
        case_classification=CaseClassification.CONFIRMED,
        investigation_status=InvestigationStatus.PENDING,
        region=default_region(),
        district=default_district(),
        health_facility=none_facility_ref(),  # FIXME not required, somewhat validated but without telling the user
        health_facility_details="Home",  # FIXME not required, somewhat validated but without telling the user
    )
    return case_dto
