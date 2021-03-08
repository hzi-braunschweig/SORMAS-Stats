import datetime
import json
import os
from json import JSONEncoder

import django
from django.db.models import Q
from pandas import DataFrame

from stats.statistics.crunch.base import Stats, datetime_to_date, merge_or_default, get_regions, \
    get_districts


class Contacts(Stats):

    def fetch(self):
        from stats.sormas_models import Cases
        from stats.sormas_models import Contact

        case_col = ['id', 'person_id', 'region_id', 'district_id', 'caseclassification', 'disease']

        cases = DataFrame.from_records(
            Cases.objects.all().values(*case_col).filter(deleted=False).exclude(Q(caseclassification='NO_CASE'))
        )

        contact_col = [
            'id', 'caze_id', 'district_id', 'disease', 'region_id', 'person_id',
            'reportdatetime', 'contactproximity', 'resultingcase_id', 'relationtocase'
        ]

        contacts = DataFrame.from_records(
            Contact.objects.all().values(*contact_col).filter(deleted=False).exclude(caze_id__isnull=True)
        )
        self.fetched = cases, contacts

    def compute(self):
        # todo return if contacts are empty
        cases, contacts = self.fetched

        contacts = datetime_to_date(contacts, 'reportdatetime', 'reportdate')

        regions = get_regions()
        districts = get_districts()

        # left outer join
        contacts = contacts.merge(cases, how='left', left_on='caze_id', right_on='id', suffixes=['_contact', '_cases'])
        contacts.drop(['id_cases'], axis=1, inplace=True)
        # merge with region, add None if not present
        contacts = merge_or_default(contacts, 'region_id_contact', regions, 'region_id', ['region_id', 'region_name'])

        # merge with district, add None if not present
        contacts = merge_or_default(contacts, 'district_id_contact', districts, 'district_id',
                                    ['district_id', 'district_name'])

        contacts.drop(['region_id_contact'], axis=1, inplace=True)
        contacts.drop(['region_id_cases'], axis=1, inplace=True)

        contacts.drop(['district_id_contact'], axis=1, inplace=True)
        contacts.drop(['district_id_cases'], axis=1, inplace=True)

        contacts.drop(['region_id'], axis=1, inplace=True)
        contacts.drop(['district_id'], axis=1, inplace=True)
        contacts.drop(['disease_cases'], axis=1, inplace=True)
        self.computed = contacts

    def flush(self):
        from stats.models import Contacts
        Contacts.objects.all().delete()

    def store(self):
        from stats.models import Contacts

        class DateTimeEncoder(JSONEncoder):
            def default(self, obj):
                if isinstance(obj, (datetime.date, datetime.datetime)):
                    return obj.isoformat()

        json_list = json.loads(json.dumps(list(self.computed.T.to_dict().values()), cls=DateTimeEncoder))

        for result in json_list:
            store = Contacts(**result)
            store.save()


def main():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'sormas_stats.settings')

    django.setup()

    cont = Contacts()
    cont.crunch_numbers()


if __name__ == '__main__':
    main()
