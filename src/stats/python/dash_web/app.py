import dash
import dash_bootstrap_components as dbc
import flask

from layout.index import index_div
from modules.reporting.report import reports
from modules.transmission_net.transmission import transmission

server = flask.Flask(__name__)
server.register_blueprint(reports)
server.register_blueprint(transmission)
# mount the dash app
app = dash.Dash(__name__, external_stylesheets=[dbc.themes.BOOTSTRAP], server=server)
app.layout = index_div


def main():
    app.run_server(debug=True)


if __name__ == '__main__':
    main()
