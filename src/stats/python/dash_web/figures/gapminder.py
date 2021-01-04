import plotly.express as px

_df = px.data.gapminder().query("continent=='Oceania'")
gapminder_fig = px.line(_df, x="year", y="lifeExp", color='country')


def get_html():
    """
    :rtype: str
    :return: exports the figure inside a div and hide config bar
    """
    return gapminder_fig.to_html(config={'displayModeBar': False}, full_html=False)
