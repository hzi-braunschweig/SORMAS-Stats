# todo Begin
# Contacts:
# Probability that a contact resides in the county of the local health
# authority responsible for the index (otherwise equal probabilities to reside
# in the other counties)
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

# todo Begin
