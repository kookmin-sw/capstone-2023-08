from django.urls import path, re_path
from . import views

url_patterns = [
    path('human', views.HumanParsing.as_view()),
    path('infer', views.Inference.as_view())
]