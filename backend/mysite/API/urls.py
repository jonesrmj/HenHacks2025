from django.urls import path

from . import views

urlpatterns = [
    path("", views.call_handler, name="CallHandler"),
    path("dummy/", views.dummy_data, name="DummyData"),
]