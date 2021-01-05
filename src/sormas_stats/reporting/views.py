from django.http import FileResponse

from reporting.pdf.report_generation import generate_pdf_report


def get_report(request):
    pdf_report = generate_pdf_report()
    return FileResponse(pdf_report, as_attachment=True, filename='sormas_stats_report.pdf')
