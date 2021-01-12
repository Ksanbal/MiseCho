from django.contrib import admin
from .models import *


class UsersAdmin(admin.ModelAdmin):
    pass


class CompanyAdmin(admin.ModelAdmin):
    pass


class DevicesAdmin(admin.ModelAdmin):
    pass


class NoticesAdmin(admin.ModelAdmin):
    pass


class DatasAdmin(admin.ModelAdmin):
    pass


class AvgdatasAdmin(admin.ModelAdmin):
    pass


admin.site.register(Users, UsersAdmin)
admin.site.register(Companys, CompanyAdmin)
admin.site.register(Devices, DevicesAdmin)
admin.site.register(Notices, NoticesAdmin)
admin.site.register(Datas, DatasAdmin)
admin.site.register(AvgDatas, AvgdatasAdmin)
