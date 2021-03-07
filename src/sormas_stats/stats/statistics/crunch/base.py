from abc import ABC, abstractmethod

from pandas import DataFrame


# todo add way to provide/define functions which could be called via the stats api
class Stats(ABC):
    """
    Base class for all statistics and imports.
    1. Data is fetched from SORMAS
    2. Statistics are computed and data gets transformed
    3. Flush out old statistics from SORMAS DB if need be
    4. Store the computed data in SORMAS-Stats DB
    """

    def __init__(self):
        self.fetched = None
        self.computed = None

    def crunch_numbers(self):
        """
        Do the whole process of fetching, computing, flushing, and storing statistics and imported data.
        :return:
        """
        self.fetch()
        self.compute()
        self.flush()
        self.store()

    @abstractmethod
    def fetch(self):
        """
        Fetch data from SORMAS.
        :return:
        """
        pass

    @abstractmethod
    def compute(self):
        """
        Compute statistics or transform imported data.
        :return:
        """
        pass

    @abstractmethod
    def flush(self):
        """
        Cleanup old entries from table.
        :return:
        """

    @abstractmethod
    def store(self):
        """
        Write computed data back to SORMAS-Stats DB.
        :return:
        """
        pass


def get_regions():
    """
    Get a list of all regions stored in SORMAS.
    :return:
    """
    from stats.sormas_models import Region
    regions = DataFrame.from_records(Region.objects.all().values('id', 'name').filter(archived=False))
    regions.rename(columns={"id": "region_id", "name": "region_name"}, inplace=True)
    return regions


def get_districts():
    """
    Get a list of all districts stored in SORMAS.
    :return:
    """
    from stats.sormas_models import District
    districts = DataFrame.from_records(District.objects.all().values('id', 'name').filter(archived=False))
    districts.rename(columns={"id": "district_id", "name": "district_name"}, inplace=True)
    return districts


def datetime_to_date(df, dtime, date):
    """
    Convert a datetime column of the given dataframe to a date.
    :param df: the dataframe
    :param dtime: the datetime column of df
    :param date: the name of the date column
    :rtype: pandas.df
    """

    date_set, date_not_set = split_on_none(df, dtime)
    if not date_set.empty:
        date_set[date] = date_set[dtime].dt.date
    if dtime != date:
        # FIXME A value is trying to be set on a copy of a slice from a DataFrame
        date_set.drop([dtime], axis=1, inplace=True)
        date_not_set.drop([dtime], axis=1, inplace=True)
    return date_set.append(date_not_set)


def split_on_none(df, col):
    """
    Splits `df` and returns two dataframes: One with all rows where `col` is none and
    the other with all rows where `col` is not none.
    :param df: the dataframe
    :param col: the column which serves as criteria
    :return: A tuple of two dataframes. The first contains all rows of `df` where `col` is not None,
    the other where `col` is None.
    """
    not_null = df[df[col].notnull()]
    null = df[~df[col].notnull()]
    return not_null, null


def merge_or_default(df, left_on, other, right_on, fill):
    """
    :param df:
    :param other:
    :param left_on:
    :param right_on:
    :param fill:
    """
    present, not_present = split_on_none(df, left_on)

    present = present.merge(other, how='left', left_on=left_on, right_on=right_on)

    for f in fill:
        not_present[f] = None
    df = present.append(not_present)
    return df
