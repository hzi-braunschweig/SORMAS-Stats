from django.shortcuts import render

def alerting(request):
    context = {}
    return render(request, 'alerting/alerting.html', context)