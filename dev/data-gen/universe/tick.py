class Tick:
    def __init__(self, date, cases):
        self.date = date
        self.cases = cases

    def __str__(self):
        return f"({self.date}: {str(self.cases)})"

    def __repr__(self):
        return self.__str__()

    def to_dict(self):
        return {
            "date": self.date,
            "cases": list(map(lambda case: case.to_dict(), self.cases))
        }
