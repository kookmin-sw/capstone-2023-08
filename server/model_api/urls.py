from django.urls import path, re_path
from . import views

urlpatterns = [
    path('human', views.HumanParsing.as_view()),
    path('infer', views.Inference.as_view()),
    path('feedback', views.ResultFeedback.as_view())
]