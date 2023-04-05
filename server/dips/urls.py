from django.urls import path
from .views import AddDips, DeleteDips

urlpatterns = [
    path('add', AddDips.as_view()),
    path('delete', DeleteDips.as_view()),
]