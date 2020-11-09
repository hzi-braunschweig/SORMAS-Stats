class Tick:
    def __init__(self, date, susceptible=None, infected=None, cases=None, contacts=None, removed=None, events=None):

        if susceptible is None:
            susceptible = []
        if infected is None:
            infected = []
        if cases is None:
            cases = []
        if contacts is None:
            contacts = []
        if removed is None:
            removed = []
        if events is None:
            events = []

        self.date = date
        self.susceptible = susceptible
        self.infected = infected
        self.cases = cases
        self.contacts = contacts
        self.removed = removed
        self.events = events

    def __str__(self):
        return f"({self.date}: Sus<{str(self.infected)}> Inf<{str(self.infected)}>, Rem<{str(self.removed)}>"

    def __repr__(self):
        return self.__str__()

    def to_dict(self):
        return {
            'date': self.date,
            'susceptible': list(map(lambda susceptible: susceptible.to_dict(), self.susceptible)),
            'cases': list(map(lambda cases: cases.to_dict(), self.cases)),
            'contacts': list(map(lambda contacts: contacts.to_dict(), self.contacts)),
            'infected': list(map(lambda infected: infected.to_dict(), self.infected)),
            'removed': list(map(lambda removed: removed.to_dict(), self.removed)),
            'events': list(map(lambda events: events.to_dict(), self.events))
        }
