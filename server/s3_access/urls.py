from django.urls import path
from .views import CreatePresignedUrl

urlpatterns = [
    path('get-presigned-url', CreatePresignedUrl.as_view({'get' : 'get'})),
]