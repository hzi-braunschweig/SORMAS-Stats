from django.shortcuts import render

def alerting(request):
    context = {}
    return render(request, 'alerting/index.html', context)