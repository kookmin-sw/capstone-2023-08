from rest_framework import serializers
from .models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['user_id', 'user_name', 'user_img_url']
    
    user_id = serializers.CharField(max_length=100)
    user_name = serializers.CharField(max_length=100)
    user_img_url = serializers.URLField()
