from . import models as mo
from datetime import datetime, timedelta
from django.db.models import Avg


def cron_job():
    now_time = datetime.now()
    target_time = now_time - timedelta(hours=1)
    now_time = now_time.strftime('%H')
    target_time = target_time.strftime('%H')

    if datetime.now().minute == 30:
        try:
            for i in mo.Devices.objects.all():
                try:
                    avg_pm10 = mo.RawDatas.objects.filter(
                        d_id=i,
                        time__range=[f"{now_time}:00:00", f"{now_time}:29:59"]
                    ).aggregate(Avg('pm10'))['pm10__avg']
                    avg_pm2p5 = mo.RawDatas.objects.filter(
                        d_id=i,
                        time__range=[f"{now_time}:00:00", f"{now_time}:29:59"]
                    ).aggregate(Avg('pm25'))['pm25__avg']

                    mo.AvgDatas.objects.create(avgpm10=avg_pm10, avgpm25=avg_pm2p5, d_id=i, c_id=i.c_id)
                except Exception as ex:
                    print(f"{datetime.now()} - Avg 30 Error - {ex}")

            for i in mo.Companys.objects.all():
                try:
                    total_avg_pm10 = mo.AvgDatas.objects.filter(
                        c_id=i,
                        time__range=[f"{now_time}:29:00", f"{now_time}:31:00"]
                    ).aggregate(Avg('avgpm10'))['avgpm10__avg']
                    total_avg_pm2p5 = mo.AvgDatas.objects.filter(
                        c_id=i,
                        time__range=[f"{now_time}:29:00", f"{now_time}:31:00"]
                    ).aggregate(Avg('avgpm25'))['avgpm25__avg']

                    mo.TotalAvgDatas.objects.create(avgpm10=total_avg_pm10, avgpm25=total_avg_pm2p5, c_id=i)
                except Exception as ex:
                    print(f"{datetime.now()} - TotalAvg 30 Error - {ex}")

        except Exception as ex:
            print(f"{datetime.now()} - 30 Get Error - {ex}")
    else:
        try:
            for i in mo.Devices.objects.all():
                try:
                    avg_pm10 = mo.RawDatas.objects.filter(
                        d_id=i,
                        time__range=[f"{target_time}:30:00", f"{now_time}:00:00"]
                    ).aggregate(Avg('pm10'))['pm10__avg']
                    avg_pm2p5 = mo.RawDatas.objects.filter(
                        d_id=i,
                        time__range=[f"{target_time}:30:00", f"{now_time}:00:00"]
                    ).aggregate(Avg('pm25'))['pm25__avg']

                    mo.AvgDatas.objects.create(avgpm10=avg_pm10, avgpm25=avg_pm2p5, d_id=i, c_id=i.c_id)
                except Exception as ex:
                    print(f"{datetime.now()} - Avg 00 Error - {ex}")

            for i in mo.Companys.objects.all():
                try:
                    total_avg_pm10 = mo.AvgDatas.objects.filter(
                        c_id=i,
                        time__range=[f"{target_time}:59:00", f"{now_time}:01:00"]
                    ).aggregate(Avg('avgpm10'))['avgpm10__avg']
                    total_avg_pm2p5 = mo.AvgDatas.objects.filter(
                        c_id=i,
                        time__range=[f"{target_time}:59:00", f"{now_time}:01:00"]
                    ).aggregate(Avg('avgpm25'))['avgpm25__avg']

                    mo.TotalAvgDatas.objects.create(avgpm10=total_avg_pm10, avgpm25=total_avg_pm2p5, c_id=i)
                except Exception as ex:
                    print(f"{datetime.now()} - TotalAvg 00 Error - {ex}")

        except Exception as ex:
            print(f"{datetime.now()} - 00 Get Error - {ex}")
