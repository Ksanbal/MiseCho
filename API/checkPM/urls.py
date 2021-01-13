from django.urls import path
from .views import *

urlpatterns = [
    # 회원관리
    # 회원가입
    path('auth/signup/', SignUp.as_view()),
    # 로그인
    path('auth/signin/', SignIn.as_view()),

    # Main Page

    # Notice Page

    # Device setting Page
        # Get

        # Post

    # Device Data Post
]