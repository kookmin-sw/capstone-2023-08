from django.urls import path
from .views import RecieveCrawlingResultView, ShowClothListView, ShowDetailView, DipsView

urlpatterns = [
    path('send-result', RecieveCrawlingResultView.as_view()),
    path('cloth-list', ShowClothListView.as_view()),
    path('detail-page', ShowDetailView.as_view()),
    path('dips/add', DipsView.as_view({'post': 'post_add'})), 
    path('dips/show', DipsView.as_view({'post': 'post_show'})),
    path('dips/delete', DipsView.as_view({'delete': 'delete'})),
]