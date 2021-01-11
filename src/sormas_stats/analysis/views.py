from django.shortcuts import render

def analysis(request):
    context = {}
    return render(request, 'analysis/index.html', context)