from django.shortcuts import render

def index(request):
    context = {}
    return render(request, 'analysis/index.html', context)
    
