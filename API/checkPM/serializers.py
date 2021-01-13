from django.contrib.auth import authenticate
from rest_framework import serializers
from .models import *


# 회원관리
# 회원가입
class SignUp_Serializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()
    first_name = serializers.CharField()
    last_name = serializers.CharField()
    email = serializers.EmailField()
    c_id = serializers.IntegerField()

    def create(self, validated_data):
        user = Users.objects.create_user(
            username=validated_data["username"],
            password=validated_data["password"],
            first_name=validated_data["first_name"],
            last_name=validated_data["last_name"],
            email=validated_data["email"],
            c_id=Companys.objects.get(id=validated_data["c_id"])
        )
        return user


# 로그인
class SignIn_Serializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()

    def validate(self, data):
        user = authenticate(**data)
        if user and user.is_active:
            return user
        raise serializers.ValidationError("Unable to sign in with provided credentials.")


class User_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Users
        fields = ('id', 'username')

# Main Page

# Notice Page

# Device setting Page
    # Get

    # Post

# Device Data Post
