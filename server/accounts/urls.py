from django.urls import path
from .views import SignUpView, SignInView, EditUserInfoView

urlpatterns = [
    path('check-id', SignUpView.as_view({'get' : 'id_validator'})),
    path('check-name', SignUpView.as_view({'get' : 'name_validator'})),
    path('sign-up', SignUpView.as_view({'post' : 'post'})),
    path('sign-in', SignInView.as_view()),
    path('edit-name', EditUserInfoView.as_view({'post' : 'edit_username'}))
]