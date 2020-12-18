import os
import uuid
from pathlib import Path

import pdfkit
from flask import Blueprint, send_file
from jinja2 import Environment, PackageLoader, select_autoescape

from dash_web.figures import gapminder
from dash_web.utils.config import REPORT_DIRECTORY

reports = Blueprint('reports', __name__)

env = Environment(
    loader=PackageLoader('dash_web', 'assets/templates'),
    autoescape=select_autoescape(['html', 'xml'])
)

template = env.get_template('report.html')


@reports.route("/report/", methods=['GET'])
def get_report():
    pdf_report = _generate_pdf_report()
    return send_file(
        pdf_report,
        mimetype='application/pdf',
        as_attachment=True,
        attachment_filename='sormas_stats_report.pdf'
    )


def _generate_pdf_report():
    context = {
        'a_variable': 'super!:)',
        'graph': _get_figure_html()
    }
    rendered = template.render(context)

    rnd_file = os.path.join(REPORT_DIRECTORY, uuid.uuid4().hex)
    Path(rnd_file).touch()

    # todo cover page supported
    pdfkit.from_string(rendered, rnd_file)
    return rnd_file


def _get_figure_html():
    return gapminder.get_html()
