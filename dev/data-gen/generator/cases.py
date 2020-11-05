from datetime import datetime, time

from sormas import CaseDataDto, CaseClassification, InvestigationStatus

from generator.district import default_district
from generator.facility import none_facility_ref
from generator.person import person_ref
from generator.region import default_region
from generator.symptoms import gen_symptom_dto
from generator.user import surv_sup_user_ref
from generator.utils import duuid

# todo Begin not 100 % sure what this means
# County of residence and reporting local health authority are the same with
# probability `p_lha_address`
p_lha_address = 0.85
# todo END

# todo
# Hospitalization and death for cases
p_hospitalization = 0.1
p_death = 0.03  # case fatality rate, approximately the average for Germany
# in October 2020, see https://ourworldindata.org/ ...
# ... coronavirus-data-explorer?zoomToSelection=true&country=~DEU& ...
# ... region=World&cfrMetric=true&interval=smoothed&smoothing=7& ...
# ... pickerMetric=location&pickerSort=asc
# todo

# todo
# Date of onset of disease:
# The delay between onset and reporting dates is assumed to follow a Gumbel
# distribution fitted on available data. The function `rgumbel` to generate
# random numbers from the fitted distribution has three further (not fitted)
# parameters: `gumbel_stepsize`, `gumbel_lowerbound` and `gumbel_upperbound`.
gumbel_stepsize = 1 / 100
gumbel_lowerbound = -100
gumbel_upperbound = 100
# todo


# todo Begin
# Date of infection:
# Assumed to happen before the date of onset or reporting, whichever is earlier,
# with the length of the preceding period following an exponential distribution
# with scale `infection_timescale` (it is the inverse of the rate).
infection_timescale = 3

# Infectiosity:
# A person is assumed infectious for a period after infection that follows an
# exponential distribution of scale `infectiosity_timescale` (it is the inverse
# of the rate).
infectiosity_timescale = 5

# Clusters:
# the probability to be infected by a person is higher
# if that persons has already infected others. This is modeled with the
# relative gain in probability from each previous infection.
p_cluster_case = 0.3

# Case generations:
# "0" = it is not known by whom one person was infected (root of the
#   transmission tree)
# "1" = infected by a generation 0 case (belongs to neighbors of a root)
# "2" = infected by a generation 1 case
# etc.
# Probabilities that a given case within the default country is of a given
# generation
p_case_generation = {'0' : 0.2, '1' : 0.3, '2' : 0.2, '3' : 0.15, '4' : 0.15}
# Relative probability of infection as a function of the difference in
# generations between two cases. Taken to be an exponential of the distance -1
# (so that a case cannot be infected by a case of identical or higher
# generation) of scale `infect_diff_generation_scale` (the inverse of the rate).
infect_diff_generation_scale = 1.5

# Initiation:
# All cases infected within `init_days` days of the first infection are roots in
# transmission chains (generation "0").
init_days = 14
# todo End


def impute_onset_date():
    # todo
    pass

def impute_infection_date():
    # todo
    pass


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
        symptoms=gen_symptom_dto(disease)
    )
    return case_dto
