import io
import os
import uuid
from pathlib import Path

import pdfkit
from django.template import loader

from dashboards.figures import gapminder
from reporting.apps import ReportingConfig

template = loader.get_template('reporting/report.html')


def generate_pdf_report():
    context = {
        'introduction': 'Quidem natus voluptatibus laboriosam quis aspernatur voluptatem optio provident.',
        'graph': _get_figure_html()
    }
    rendered = template.render(context)

    # FIXME(@JonasCir) use BytesIO directly instead of filesystem
    #  see https://github.com/JazzCore/python-pdfkit/issues/178

    rnd_file = os.path.join(ReportingConfig.REPORT_DIRECTORY, uuid.uuid4().hex + '.pdf')
    Path(rnd_file).touch()

    # todo cover page supported
    pdfkit.from_string(rendered, rnd_file)

    with open(rnd_file, 'rb') as f:
        pdf = io.BytesIO(f.read())

    os.remove(rnd_file)
    return pdf


def _get_figure_html():
    return gapminder.get_html()
