import pandas as pd
import plotly.express as px

from dashboards.figures.base import Figure
from stats.models import CasesPerDay as CasesPerDayModel


class CasesPerDay(Figure):

    @staticmethod
    def get_html():
        df = pd.DataFrame.from_records(CasesPerDayModel.objects.all().values())

        fig = px.bar(df, x='date', y="count")
        return fig.to_html(**Figure.html_config)
