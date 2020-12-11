import dash_core_components as dcc

import plotly.express as px

_df = px.data.gapminder().query("continent=='Oceania'")
_fig = px.line(_df, x="year", y="lifeExp", color='country')

_graph = dcc.Graph(figure=_fig)


def graph():
    return _graph
