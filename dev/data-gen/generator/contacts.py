import datetime

from sormas import ContactDto

# todo Begin
# Contacts:
# Probability that a contact resides in the county of the local health
# authority responsible for the index (otherwise equal probabilities to reside
# in the other counties)
from generator.health_condition import gen_health_condition_dto
from generator.person import person_ref, case_ref
from generator.user import surv_sup_user_ref
from generator.utils import dnow, duuid

p_contact_reside = 2 / 3
# Probability that a contact has been contacted by the local health authority
# of the index
p_contact_contacted = 0.5
# Probability that, given that they were contacted, a contact is in quarantine
p_contact_quarantine = 0.75
# Probability that, given that they were contacted, a contact has been tested
# (with a negative result, otherwise it would be a case)
p_contact_test = 0.75

# todo End


# todo Begin
# Geolocations:
# Shapes (polygons) of the counties
# county_shapes < - st_read(
#    here(data_dir, 'in/germany_counties.geojson'), quiet=T
# ) % > %
# st_set_crs(4839) % > %
# st_transform(crs=4326) % > %
# select(-c(value, signal, id, IdParent, AdminUnit)) % > %
# filter(GeoName % in % selected_counties)
# The probability of the location of the contact of a person depends is
# an exponential of the distance between the two with scale (the inverse of
# the rate) `location_dist_scale` in meters.
location_dist_scale = 2000
# Sample sizes of geolocations: `relative_sample_size_geolocation` sets the size
# of the one-time generated list of geolocations relative to the number of
# cases, `sub_sample_size_geolocation` the size of the samples from the list of
# geolocations
relative_sample_size_geolocation = 100
sub_sample_size_geolocation = 100


# todo End


def gen_contact_dto(person_uuid, case_uuid, disease):
    contact_dto = ContactDto(
        uuid=duuid(),  # todo broken handling in backend ContactFacadeEjb:280
        person=person_ref(person_uuid),
        report_date_time=dnow(),
        creation_date=dnow(),  # todo  required missing
        change_date=dnow(),  # todo  required missing
        reporting_user=surv_sup_user_ref(),
        last_contact_date=datetime.date.fromisoformat('2020-02-01'),
        disease=disease,
        caze=case_ref(case_uuid),  # todo validation exception talking about region
        health_conditions=gen_health_condition_dto()  # todo ContactFacadeRjb:1092 nullpointer if missing

    )
    return contact_dto
