from rest_framework import serializers
from .models import Dips
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