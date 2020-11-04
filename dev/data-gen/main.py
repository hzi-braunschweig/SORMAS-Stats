from pprint import pprint

import sormas
from sormas.rest import ApiException

from generators.gen_cases import create_case
from generators.gen_person import create_person

# Defining the host is optional and defaults to http://localhost/sormas-rest
# See configuration.py for a list of all supported configuration parameters.
configuration = sormas.Configuration(
    host="https://sormas-docker-test.com/sormas-rest",
    username="SurvOff",
    password="SurvOff"
)
configuration.verify_ssl = False
configuration.debug = True

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Enter a context with an instance of the API client
with sormas.ApiClient(configuration) as api_client:
    try:
        p = create_person()
        person_dto = [p]
        resp = sormas.PersonControllerApi(api_client).post_persons(person_dto=person_dto)
        pprint(resp)
        case_data_dto = [create_case(p.uuid)]
        resp = sormas.CaseControllerApi(api_client).post_cases(case_data_dto=case_data_dto)
        pprint(resp)

    except ApiException as e:
        print("Exception when calling CaseControllerApi->post_cases: %s\n" % e)
