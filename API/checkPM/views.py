from datetime import datetime

from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework.authtoken.models import Token
from django.db.models import Avg

# 시리얼라이저
from . import serializers as se
from . import models as mo


# 회원관리
@api_view(['POST'])
def signup(request):
    if request.method == 'POST':
        if len(request.data["password"]) < 4:
            body = {"message": "비밀번호 길이가 너무 짧습니다."}
            return Response(body, status=status.HTTP_400_BAD_REQUEST)
        try:
            if mo.User.objects.get(email=request.data['email']):
                return Response('이미 등록된 이메일입니다.', status=status.HTTP_400_BAD_REQUEST)
            if mo.User.objects.get(username=request.data['username']):
                return Response('이미 등록된 아이디입니다.', status=status.HTTP_400_BAD_REQUEST)
        except Exception:
            pass

        serializer = se.SignUp_Serializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            token = Token.objects.create(user=user)
            return Response(
                {
                    "token": token.key
                }
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# 로그인
@api_view(['POST'])
def signin(request):
    if request.method == 'POST':
        serializer = se.SignIn_Serializer(data=request.data)
        if serializer.is_valid():
            user = serializer.validated_data
            token = Token.objects.create(user=user)
            return Response(
                {
                    "token": token.key
                }
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# Main Page
# Chart Data
@api_view(['GET'])
def main_chart(request, date):
    if request.user.username != 'AnonymousUser':
        now_user = request.user
        date = [int(i) for i in date.split('-')]
        date = datetime(date[0], date[1], date[2])

        # 전체 평균 data
        myAVG = mo.TotalAvgDatas.objects.filter(
            date=date, c_id=mo.Profile.objects.get(user_id=now_user).c_id
        )
        avg_serializer = se.Total_AvgData_Serializer(myAVG, many=True)
        return Response(avg_serializer.data, status=status.HTTP_200_OK)
    else:
        return Response(status=status.HTTP_401_UNAUTHORIZED)


# Device List
@api_view(['GET'])
def main_device(request, date):
    if request.user.username != 'AnonymousUser':
        now_user = request.user
        date = [int(i) for i in date.split('-')]
        date = datetime(date[0], date[1], date[2])

        # 측정기 list (id, 이름, 연결상태, 현재날짜 평균 pm10, 현재날짜 평균 pm25)
        myDevices = mo.Devices.objects.filter(c_id=mo.Profile.objects.get(user_id=now_user).c_id)
        for i in myDevices:
            i.avgpm10 = mo.AvgDatas.objects.filter(
                date=date,
                d_id=i.id
            ).aggregate(Avg('avgpm10'))['avgpm10__avg']
            i.avgpm25 = mo.AvgDatas.objects.filter(
                date=date,
                d_id=i.id
            ).aggregate(Avg('avgpm25'))['avgpm25__avg']
            i.save()

        deviceList_serializer = se.MainDeviceList_Serialzier(myDevices, many=True)
        return Response(deviceList_serializer.data, status=status.HTTP_200_OK)
    else:
        return Response(status=status.HTTP_401_UNAUTHORIZED)


# Notifications List Page
@api_view(['GET'])
def notifications(request):
    # 접속한 유저 확인
    if request.user.username != 'AnonymousUser':
        now_c_id = mo.Profile.objects.get(
            user_id=request.user.id
        ).c_id

        # 회사의 id를 가진 모든 notification 반환
        notices = mo.Notices.objects.filter(c_id=now_c_id).order_by('-date')

        if request.method == 'GET':
            serializer = se.Notification_Serializer(notices, many=True)
            return Response(serializer.data)
    return Response(status=status.HTTP_401_UNAUTHORIZED)


# 요청한 사용자가 디바이스에 권한이 있는지 확인
def check_device_auth(user, device_id):
    if user.username != 'AnonymousUser':
        device_c_id = mo.Devices.objects.get(id=device_id).c_id
        user_c_id = mo.Profile.objects.get(user_id=user).c_id

        if user_c_id == device_c_id:
            return True
    return False


# Device setting Page
# Device Chart Data
@api_view(['GET'])
def device_setting_chart(request, device_id, date):
    # Found Check
    try:
        device = mo.Devices.objects.get(id=device_id)
    except device.DoesNotExist:
        return Response('디바이스를 찾지 못했습니다.', status=status.HTTP_404_NOT_FOUND)

    if check_device_auth(request.user, device_id):
        # 해당 디바이스 선택날짜 시간대별 데이터
        date = [int(i) for i in date.split('-')]
        avgdatas = mo.AvgDatas.objects.filter(date=datetime(date[0], date[1], date[2]), d_id=device)
        avgdata_serializer = se.AvgData_Serializer(avgdatas, many=True)

        return Response(avgdata_serializer.data, status=status.HTTP_200_OK)
    return Response(status=status.HTTP_401_UNAUTHORIZED)


# Device Setting Value
@api_view(['GET', 'PUT', 'PATCH'])
def device_setting_value(request, device_id):
    # Found Check
    try:
        device = mo.Devices.objects.get(id=device_id)
    except device.DoesNotExist:
        return Response('디바이스를 찾지 못했습니다.', status=status.HTTP_404_NOT_FOUND)

    if check_device_auth(request.user, device_id):
        # GET
        if request.method == 'GET':
            # 디바이스 설정 정보
            device_serializer = se.DeviceSetting_Serializer(device)
            return Response(device_serializer.data, status=status.HTTP_200_OK)
        # PUT
        elif request.method == 'PUT':
            serializer = se.DeviceSetting_Serializer(device, data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        # PATCH -> 전원 끄기r
        elif request.method == 'PATCH':
            # 디바이스 끄는 코드 작성
            return Response('전원 끄기', status=status.HTTP_200_OK)
    return Response(status=status.HTTP_401_UNAUTHORIZED)


# Device Data Post
@api_view(['POST'])
def data_post(request):
    # 미세먼지 정도 확인 및 알림 생성 함수
    def check_grade(pm10, pm25, d_id):
        # 미세먼지 단계
        pm10_grade = [0, 16, 31, 41, 51, 76, 101, 151]  # 미세먼지
        pm25_grade = [0, 9, 16, 21, 26, 38, 51, 76]  # 초미세먼지
        str_grade = ['최고', '좋음', '양호', '보통', '나쁨', '상당히 나쁨', '매우 나쁨', '최악']

        # 디바이스의 단계 확인
        device = mo.Devices.objects.get(id=d_id)
        device_grade = device.pmhigh

        for n, i in enumerate(pm10_grade):
            if pm10 > i:
                pm10_now = n

        for n, i in enumerate(pm25_grade):
            if pm25 > i:
                pm25_now = n

        # 단계 확인 후 알림 데이터 생성
        if pm10 > pm10_grade[device_grade]:
            for n, i in enumerate(pm10_grade):
                if pm10 > i:
                    pm10_now = n

            mo.Notices(
                content=f'미세먼지 상태가 "{str_grade[pm10_now]}"입니다. 확인해주세요.',
                d_id=device,
                c_id=device.c_id
            ).save()

        if pm25 > pm25_grade[device_grade]:
            for n, i in enumerate(pm25_grade):
                if pm25 > i:
                    pm25_now = n

            mo.Notices(
                content=f'초미세먼지 상태가 "{str_grade[pm25_now]}"입니다. 확인해주세요.',
                d_id=device,
                c_id=device.c_id
            ).save()

    if request.method == 'POST':
        serializer = se.DataPost_Serializer(data=request.data)
        if serializer.is_valid():
            check_grade(request.data['pm10'], request.data['pm25'], request.data['d_id'])
            serializer.save()
            return Response(serializer.errors, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
