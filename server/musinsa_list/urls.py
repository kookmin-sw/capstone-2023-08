from django.urls import path
from .views import RecieveCrawlingResultView, ShowClothListView, ShowDetailView, DipsView

urlpatterns = [
    path('send-result', RecieveCrawlingResultView.as_view()),
    path('cloth-list', ShowClothListView.as_view({'get': 'get'})),
    path('detail-page', ShowDetailView.as_view({'get': 'get'})),
    path('dips/add', DipsView.as_view({'post': 'post_add'})), 
    path('dips/show', DipsView.as_view({'post': 'post_show'})),
    path('dips/delete', DipsView.as_view({'delete': 'delete'})),
]