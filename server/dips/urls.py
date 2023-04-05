from django.urls import path
from .views import AddDips

urlpatterns = [
    path('add', AddDips.as_view()),
]