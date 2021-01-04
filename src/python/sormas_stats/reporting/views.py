from django.http import FileResponse

from reporting.report_generation import generate_pdf_report


def get_report(request):
    pdf_report = generate_pdf_report()
    return FileResponse(open(pdf_report, 'rb'), as_attachment=True, filename='sormas_stats_report.pdf')
