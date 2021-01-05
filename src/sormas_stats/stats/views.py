from django.http import JsonResponse

from stats.tasks import task_case_count_total


# Create your views here.

def case_count_total(request):
    total = task_case_count_total.delay()
    return JsonResponse({'total': total.get()})
