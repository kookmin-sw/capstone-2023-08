from django.urls import path
from .views import RecieveCrawlingResultView, ShowClothListView, ShowDetailView

urlpatterns = [
    path('send-result', RecieveCrawlingResultView.as_view()),
    path('cloth-list', ShowClothListView.as_view()),
    path('detail-page', ShowDetailView.as_view()),
]