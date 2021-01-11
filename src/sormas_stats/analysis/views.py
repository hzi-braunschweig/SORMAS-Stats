from django.shortcuts import render

def analysis(request):
    context = {}
    return render(request, 'analysis/analysis.html', context)