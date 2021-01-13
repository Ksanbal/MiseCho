from django.shortcuts import render

from rest_framework import generics, status, viewsets, permissions
from rest_framework.response import Response
from rest_framework.parsers import FileUploadParser
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework import mixins
from rest_framework.authtoken.models import Token

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
@api_view(['GET'])
def main(request):
    # 전체 평균 data
    # 측정기 list (id, 이름, 연결상태, 현재날짜 평균 pm10, 현재날짜 평균 pm25)
    pass


# Notifications List Page
@api_view(['GET'])
def notifications(request):
    # 접속한 유저 확인
    now_c_id = mo.Profile.objects.get(
        user_id=mo.User.objects.get(username=request.user).id
    ).c_id

    # 회사의 id를 가진 모든 notification 반환
    notices = mo.Notices.objects.filter(c_id=now_c_id)

    if request.method == 'GET':
        serializer = se.Notification_Serializer(notices, many=True)
        return Response(serializer.data)


# Device setting Page
@api_view(['GET', 'PUT'])
def device_setting(request, device_id):
    # Found Check
    try:
        device = mo.Devices.objects.get(id=device_id)
    except device.DoesNotExist:
        return Response('디바이스를 찾지 못했습니다.', status=status.HTTP_404_NOT_FOUND)

    # GET
    if request.method == 'GET':
        # 시간대, 날짜별 평균 데이터
        serializer = se.DeviceSetting_Serializer(device)
        return Response(serializer.data)
    # PUT
    elif request.method == 'PUT':
        serializer = se.DeviceSetting_Serializer(device, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# Device Data Post
@api_view(['POST'])
def data_post(request):
    if request.method == 'POST':
        serializer = se.DataPost_Serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.errors, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
