from django.urls import path
from . import views as vi

urlpatterns = [
    # APP
    # 회원관리
    # 회원가입
    path('app/auth/signup/', vi.signup),
    # 로그인
    path('app/auth/signin/', vi.signin),

    # Main Page
    path('app/main/chart/<str:date>/', vi.main_chart),
    path('app/main/device/<str:date>/', vi.main_device),

    # Notice Page
    path('app/notice/', vi.notifications),

    # Device setting Page
    path('app/device/chart/<int:device_id>/<str:date>/', vi.device_setting_chart),
    path('app/device/value/<int:device_id>/', vi.device_setting_value),

    # Device
    # Device Data Post
    path('device/data/<int:device_id>/', vi.check_freq),
    path('device/data/', vi.datapost),
]

