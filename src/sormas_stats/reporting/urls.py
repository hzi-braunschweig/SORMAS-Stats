from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='reporting'),
    path('get_report', views.get_report, name='get_report'),
]
