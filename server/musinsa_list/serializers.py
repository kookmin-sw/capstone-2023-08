from rest_framework import serializers
from .models import Goods

class GoodsListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Goods
        fields = ['id', 's3_img_url']
    
    id = serializers.CharField(max_length=100)
    s3_img_url = serializers.URLField(max_length=200)

class GoodsDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Goods
        fields = ['id', 'detail_page_url']

    id = serializers.CharField(max_length=100)
    detail_page_url = serializers.URLField(max_length=200)
