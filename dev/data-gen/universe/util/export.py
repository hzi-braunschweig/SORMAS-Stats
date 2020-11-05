import datetime
import json as _json
from json import JSONEncoder

import sormas as sormas_api
from sormas.rest import ApiException
from universe.tick import Tick


def json(world):
    """
    Dump cases of our world to JSON
    :type world: World
    """

    class DateTimeEncoder(JSONEncoder):
        def default(self, obj):
            if isinstance(obj, (datetime.date, datetime.datetime)):
                return obj.isoformat()

    with open('cases.json', 'w') as f:
        out = list(map(lambda tick: tick.to_dict(), world.history))
        s = _json.dumps(out, indent=2, cls=DateTimeEncoder)
        f.write(s)


def sormas(world):
    """

    :type world: World
    """

    configuration = sormas_api.Configuration(
        host="https://sormas-docker-test.com/sormas-rest",
        username="SurvOff",
        password="SurvOff"
    )
    configuration.verify_ssl = False
    configuration.debug = True

    with sormas_api.ApiClient(configuration) as api_client:

        day: Tick
        for day in world.history:
            date = day.date
            cases = day.cases
            for case in cases:
                person_dto = case.person
                case_data_dto = case.inner
                try:
                    sormas_api.PersonControllerApi(api_client).post_persons(person_dto=[person_dto])
                    sormas_api.CaseControllerApi(api_client).post_cases(case_data_dto=[case_data_dto])
                    pass
                except ApiException as e:
                    print("Exception: %s\n" % e)
