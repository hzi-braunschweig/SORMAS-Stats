from django.urls import path

from . import views

urlpatterns = [
    path('', views.days_with_cases, name='index'),
]
