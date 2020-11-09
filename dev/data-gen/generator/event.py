from sormas import EventDto, EventStatus

# Events:
from generator.user import surv_sup_user_ref
from generator.utils import dnow, duuid

# todo Begin

frac_events_cases = 0.05  # number of events divided by number of cases
mu_event_size = 10  # mean parameter of the Gaussian used in draw the event size
sig_event_size = 10  # standard deviation of the Gaussian
min_event_size = 5  # minimum size of an event
p_known_participant = 0.01  # 0.2 # proportion of participants who are a case


# or a contact, knowing that there is at least one case participating

# todo End


def gen_event_dto():
    event_dto = EventDto(
        uuid=duuid(),  # todo EventFacade:163 not null fires
        event_status=EventStatus.EVENT,
        event_desc='Party Party!',
        report_date_time=dnow(),
        reporting_user=surv_sup_user_ref()
        #todo region + district is required in the UI!
    )
    return event_dto
