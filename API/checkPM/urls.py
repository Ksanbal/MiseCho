from django.urls import path
from . import views as vi

urlpatterns = [
    # 회원관리
    # 회원가입
    path('app/auth/signup/', vi.signup),
    # 로그인
    path('app/auth/signin/', vi.signin),

    # Main Page

    # Notice Page
    path('app/notice/', vi.notifications),

    # Device setting Page
    path('app/device/<int:device_id>/', vi.device_setting),

    # Device Data Post
    path('device/datapost/', vi.data_post),
]

