from django.http import FileResponse
from django.shortcuts import render

from reporting.pdf.report_generation import generate_pdf_report


def reporting(request):
    context = {}
    return render(request, 'reporting/reporting.html', context)


def get_report(request):
    pdf_report = generate_pdf_report()
    return FileResponse(open(pdf_report, 'rb'), as_attachment=True, filename='sormas_stats_report.pdf')
