from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User

class UserAdmin(BaseUserAdmin):
    ordering = ("user_id",)
    list_display = ('user_id', 'user_name', 'user_img_url')
    list_display_links = ('user_id',)
    list_filter = ('user_id',)
    search_fields = ('user_id', 'user_name')

    fieldsets = (
        ('info', {'fields' : ('user_id', 'user_name', 'password', 'join_date',)}),
        ('Permissions', {'fields' : ('is_admin',)}),
    )

    filter_horizontal = []

    def get_readonly_fields(self, request, obj=None) :
        if obj:
            return ('user_name', 'join_date',)
        else:
            return ('join_date',)
    
admin.site.register(User, UserAdmin)