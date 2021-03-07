from django.http import FileResponse
from django.shortcuts import render

from reporting.pdf.report_generation import generate_pdf_report


def index(request):
    """
    The index page of /reporting.
    """
    context = {}
    return render(request, 'reporting/index.html', context)


def get_report(request):
    """
    Generate a report. Currently a simple PDF report ist templated and returned.
    :return: A generated PDF file report.
    """
    pdf_report = generate_pdf_report()
    return FileResponse(pdf_report, as_attachment=True, filename='sormas_stats_report.pdf')
