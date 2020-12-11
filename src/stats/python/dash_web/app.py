import dash
import dash_bootstrap_components as dbc
import dash_html_components as html
import flask

from layout.graph import graph
from layout.jumbotron import jumbotron
from layout.navbar import navbar

server = flask.Flask(__name__)
app = dash.Dash(__name__, external_stylesheets=[dbc.themes.BOOTSTRAP], server=server)

navbar = navbar()
jumbotron = jumbotron()
graph = graph()

app.layout = html.Div([
    navbar,
    jumbotron,
    graph
])

if __name__ == '__main__':
    app.run_server(debug=True)
