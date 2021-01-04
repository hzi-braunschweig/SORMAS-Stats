from django.urls import path

from . import views

urlpatterns = [
    path('transmission_chain', views.index, name='index'),
]
