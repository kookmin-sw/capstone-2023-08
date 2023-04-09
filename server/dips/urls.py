from django.urls import path
from .views import AddDips, DeleteDips, ShowDips

urlpatterns = [
    path('add', AddDips.as_view()),
    path('delete', DeleteDips.as_view()),
    path('show', ShowDips.as_view()),
]