from django.db import models
from django.contrib.auth.models import User


class Companys(models.Model):
    name = models.TextField(null=False)


class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    c_id = models.ForeignKey(Companys, on_delete=models.CASCADE, db_column='c_id')


class Devices(models.Model):
    name = models.CharField(max_length=10, default='이름없는 측정기')
    connect = models.BooleanField(default=False)
    freq = models.IntegerField(default=5)
    # 0 최고, 1 좋음, 2 양호, 3 보통, 4 나쁨, 5 상당히 나쁨, 6 매우 나쁨, 7 최악
    pmhigh = models.IntegerField(default=5)
    null_freq = models.IntegerField(default=5)
    work_s = models.CharField(max_length=4, default='0900')
    work_e = models.CharField(max_length=4, default='1800')
    comment = models.TextField(null=True)
    c_id = models.ForeignKey(Companys, on_delete=models.CASCADE, db_column='c_id')


class Notices(models.Model):
    date = models.DateTimeField(auto_now_add=True)
    content = models.TextField(null=True)
    d_id = models.ForeignKey(Devices, on_delete=models.CASCADE, db_column='d_id')
    c_id = models.ForeignKey(Companys, on_delete=models.CASCADE, db_column='c_id')


class RawDatas(models.Model):
    date = models.DateField(auto_now_add=True)
    time = models.TimeField(auto_now_add=True)
    pm10 = models.IntegerField()
    pm25 = models.IntegerField()
    d_id = models.ForeignKey(Devices, on_delete=models.CASCADE, db_column='d_id')


class AvgDatas(models.Model):
    date = models.DateField(auto_now_add=True)
    time = models.TimeField(auto_now_add=True)
    avgpm10 = models.IntegerField()
    avgpm25 = models.IntegerField()
    d_id = models.ForeignKey(Devices, on_delete=models.CASCADE, db_column='d_id')
