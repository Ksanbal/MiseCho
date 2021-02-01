from . import models as mo
from datetime import datetime, timedelta
from django.db.models import Avg


def cron_job():
    now_time = datetime.now()
    target_time = now_time - timedelta(hours=1)
    now_time = now_time.strftime('%H')
    target_time = target_time.strftime('%H')

    for i in mo.Devices.objects.all():
        avg_pm10 = mo.RawDatas.objects.filter(
            d_id=i,
            time__range=[f"{target_time}:00:00", f"{target_time}:59:59"]
        ).aggregate(Avg('pm10'))['pm10__avg']
        avg_pm2p5 = mo.RawDatas.objects.filter(
            d_id=i,
            time__range=[f"{target_time}:00:00", f"{target_time}:59:59"]
        ).aggregate(Avg('pm25'))['pm25__avg']

        mo.AvgDatas.objects.create(avgpm10=avg_pm10, avgpm25=avg_pm2p5, d_id=i, c_id=i.c_id)

    for i in mo.Companys.objects.all():
        total_avg_pm10 = mo.AvgDatas.objects.filter(
            c_id=i,
            time__range=[f"{target_time}:50:00", f"{now_time}:10:00"]
        ).aggregate(Avg('avgpm10'))['avgpm10__avg']
        total_avg_pm2p5 = mo.AvgDatas.objects.filter(
            c_id=i,
            time__range=[f"{target_time}:50:00", f"{now_time}:10:00"]
        ).aggregate(Avg('avgpm25'))['avgpm25__avg']

        mo.TotalAvgDatas.objects.create(avgpm10=total_avg_pm10, avgpm25=total_avg_pm2p5, c_id=i)

    print(f"{datetime.now()} Avg Data created")
