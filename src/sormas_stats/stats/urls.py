from django.urls import path

from . import views

urlpatterns = [
    path('', views.case_count_total, name='index'),
]
