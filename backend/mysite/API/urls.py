from django.urls import path

from . import views

urlpatterns = [
    path("", views.CallHandler, name="CallHandler"),
]