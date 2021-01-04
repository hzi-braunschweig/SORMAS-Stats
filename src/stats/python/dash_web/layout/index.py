import dash_core_components as dcc
import dash_html_components as html

from figures.gapminder import gapminder_fig
from layout.jumbotron import jumbotron
from layout.navbar import navbar
from layout.report import report_download

index_div = html.Div(
    [
        navbar,
        jumbotron,
        dcc.Graph(figure=gapminder_fig),
        report_download

    ]
)
