import dash_bootstrap_components as dbc
import dash_html_components as html

report_download = html.Div(
    [
        html.H2('Report Download'),
        # todo this is a bug: dbc.Form is not working
        html.Form(
            action='/report',
            method='get',
            children=[
                dbc.Button('Report', id='btn-report')
            ]
        )

    ]
)
