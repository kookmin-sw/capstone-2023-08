from django.urls import path
from .views import SignUpView, SignInView, EditUserInfoView, LogoutView

urlpatterns = [
    path('check-id', SignUpView.as_view({'get' : 'id_validator'})),
    path('check-name', SignUpView.as_view({'get' : 'name_validator'})),
    path('sign-up', SignUpView.as_view({'post' : 'post'})),
    path('sign-in', SignInView.as_view()),
    path('edit-name', EditUserInfoView.as_view({'post' : 'edit_username'})),
    path('change-pw', EditUserInfoView.as_view({'post' : 'change_password'})),
    path('add-imgurl', EditUserInfoView.as_view({'post' : 'add_user_img_url'})),
    path('logout', LogoutView.as_view({'post' : 'logout'}))
]