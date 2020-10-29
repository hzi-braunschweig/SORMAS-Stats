from pprint import pprint

import sormas
from sormas.rest import ApiException

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
    # Create an instance of the API class
    api_instance = sormas.ActionControllerApi(api_client)
    since = 56  # int |

    try:
        api_response = api_instance.get_all(since)
        pprint(api_response)
    except ApiException as e:
        print("Exception when calling ActionControllerApi->get_all: %s\n" % e)
