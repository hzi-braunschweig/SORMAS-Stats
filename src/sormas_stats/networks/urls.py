from django.urls import path

from . import views

urlpatterns = [
    path('contact_network', views.index, name='networks'),
]
