import datetime
import json
from json import JSONEncoder

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
            'reportdatetime', 'lastcontactdate', 'contactproximity', 'resultingcase_id', 'contactstatus',
            'contactclassification', 'followupstatus', 'relationtocase'
        ]

        contacts = DataFrame.from_records(
            Contact.objects.all().values(*contact_col).filter(deleted=False).exclude(caze_id__isnull=True)
        )
        self.fetched = cases, contacts

    def compute(self):
        cases, contacts = self.fetched

        contacts = datetime_to_date(contacts, 'reportdatetime', 'reportdate')
        contacts = datetime_to_date(contacts, 'lastcontactdate', 'lastcontactdate')

        regions = get_regions()
        districts = get_districts()

        # left outer join
        contacts = contacts.merge(cases, how='left', left_on='caze_id', right_on='id', suffixes=['_contact', '_cases'])

        # merge with region, add None if not present
        contacts = merge_or_default(contacts, 'region_id_contact', regions, 'region_id', ['region_id', 'region_name'])
        contacts.drop(['region_id_contact'], axis=1, inplace=True)
        # merge with district, add None if not present
        contacts = merge_or_default(contacts, 'district_id_contact', districts, 'district_id',
                                    ['district_id', 'district_name'])
        contacts.drop(['district_id_contact'], axis=1, inplace=True)
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
