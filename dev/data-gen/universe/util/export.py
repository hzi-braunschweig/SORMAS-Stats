import datetime
import json as _json
from json import JSONEncoder
from pprint import pprint

import sormas
from sormas.rest import ApiException

from generator.cases import gen_case_dto


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
    configuration = sormas.Configuration(
        host="https://sormas-docker-test.com/sormas-rest",
        username="SurvOff",
        password="SurvOff"
    )
    configuration.verify_ssl = False
    configuration.debug = True

    with sormas.ApiClient(configuration) as api_client:
        try:
            p = person_dto()
            person_dto = [p]
            resp = sormas.PersonControllerApi(api_client).post_persons(person_dto=person_dto)
            pprint(resp)
            case_data_dto = [gen_case_dto(p.uuid)]
            resp = sormas.CaseControllerApi(api_client).post_cases(case_data_dto=case_data_dto)
            pprint(resp)

        except ApiException as e:
            print("Exception: %s\n" % e)
