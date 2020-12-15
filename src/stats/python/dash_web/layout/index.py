import dash_core_components as dcc
import dash_html_components as html

from dash_web.figures.gapminder import gapminder_fig
from dash_web.layout.jumbotron import jumbotron
from dash_web.layout.navbar import navbar
from dash_web.layout.report import report_download

graph = dcc.Graph(figure=gapminder_fig)

index_div = html.Div(
    [
        navbar,
        jumbotron,
        graph,
        report_download

    ]
)
