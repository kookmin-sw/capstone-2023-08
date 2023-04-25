from rest_framework import serializers
from .models import Goods, Dips

class GoodsListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Goods
        fields = ['id', 'goods_name', 'brand_name', 's3_img_url']
    
    id = serializers.CharField(max_length=100)
    goods_name = serializers.CharField(max_length=100)
    brand_name = serializers.CharField(max_length=100)
    s3_img_url = serializers.URLField(max_length=200)

class GoodsDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Goods
        fields = ['id', 'detail_page_url']

    id = serializers.CharField(max_length=100)
    detail_page_url = serializers.URLField(max_length=200)


class DipsListSerializer(serializers.ModelSerializer):
    goods_info = serializers.SerializerMethodField()

    def get_goods_info(self, obj):
        info = {'id' : obj.goods.id,
                'goods_name' : obj.goods.goods_name,
                'brand_name' : obj.goods.brand_name,
                's3_img_url' : obj.goods.s3_img_url}
        return info
    class Meta:
        model = Dips
        fields = ['goods_info']
