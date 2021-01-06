from django.shortcuts import render

from .figures.gapminder import Gapminder
from .figures.cases_per_day import CasesPerDay


def index(request):
    context = {
        'gapminder': Gapminder.get_html(),
        'cases_per_day': CasesPerDay.get_html()
    }
    return render(request, 'dashboards/index.html', context)
