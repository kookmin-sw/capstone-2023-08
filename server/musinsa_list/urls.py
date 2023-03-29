from django.urls import path
from .views import RecieveCrawlingResultView

urlpatterns = [
    path('send-result', RecieveCrawlingResultView.as_view()),
]