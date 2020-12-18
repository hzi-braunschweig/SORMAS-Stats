import dash
import dash_bootstrap_components as dbc
import flask

from dash_web.layout.index import index_div
from dash_web.reporting.report import reports

server = flask.Flask(__name__)
app = dash.Dash(__name__, external_stylesheets=[dbc.themes.BOOTSTRAP], server=server)

server.register_blueprint(reports)

app.layout = index_div


def main():
    app.run_server(debug=True)


if __name__ == '__main__':
    main()
