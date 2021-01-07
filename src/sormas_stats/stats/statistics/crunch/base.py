from abc import ABC, abstractmethod


# todo add way to provide/define functions which could be called via the stats api
class Stats(ABC):

    def __init__(self):
        self.fetched = None
        self.computed = None

    def crunch_numbers(self):
        self.fetch()
        self.compute()
        self.flush()
        self.store()

    @abstractmethod
    def fetch(self):
        pass

    @abstractmethod
    def compute(self):
        pass

    @abstractmethod
    def flush(self):
        """
        Cleanup old entries from table.
        :return:
        """

    @abstractmethod
    def store(self):
        pass
