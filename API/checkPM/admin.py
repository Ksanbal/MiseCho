from django.contrib import admin
from . import models as mo


class ProfileAdmin(admin.ModelAdmin):
    pass


class CompanyAdmin(admin.ModelAdmin):
    pass


class DevicesAdmin(admin.ModelAdmin):
    pass


class NoticesAdmin(admin.ModelAdmin):
    pass


class RawDatasAdmin(admin.ModelAdmin):
    pass


class AvgDatasAdmin(admin.ModelAdmin):
    pass


class TotalAvgDatasAdmin(admin.ModelAdmin):
    pass


class DaysAvgDatasAdmin(admin.ModelAdmin):
    pass

admin.site.register(mo.Profile, ProfileAdmin)
admin.site.register(mo.Companys, CompanyAdmin)
admin.site.register(mo.Devices, DevicesAdmin)
admin.site.register(mo.Notices, NoticesAdmin)
admin.site.register(mo.RawDatas, RawDatasAdmin)
admin.site.register(mo.AvgDatas, AvgDatasAdmin)
admin.site.register(mo.TotalAvgDatas, TotalAvgDatasAdmin)
admin.site.register(mo.DaysAvgDatas, DaysAvgDatasAdmin)
