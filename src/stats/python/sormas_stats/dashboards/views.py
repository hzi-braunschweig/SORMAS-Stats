from django.shortcuts import render

from .figures import gapminder


def index(request):
    context = {'gapminder': gapminder.get_html()}
    return render(request, 'dashboards/index.html', context)
