from django.http import JsonResponse

from stats.models import CasesPerDay


def days_with_cases(request):
    total = CasesPerDay.objects.count()
    return JsonResponse({'days_with_cases': total})
