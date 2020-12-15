import plotly.express as px

_df = px.data.gapminder().query("continent=='Oceania'")
gapminder_fig = px.line(_df, x="year", y="lifeExp", color='country')


def get_html():
    """
    :rtype: plotly.graph_objs.Figure
    :return: The gapminder figure
    """
    return gapminder_fig.write_html(full_html=False)
