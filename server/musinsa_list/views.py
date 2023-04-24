import json
from django.views import View
from django.http import JsonResponse

from .serializers import GoodsListSerializer, GoodsDetailSerializer, DipsListSerializer
from .models import Goods, Dips
from accounts.models import User

class RecieveCrawlingResultView(View):
    def post(self, request):
        # get crawling result file and update DB
        data = json.loads(request.body)
        for k, v in data.items():
            Goods(
                id = v["id"],
                goods_name = v['goods_name'],
                brand_name = v['brand_name'],
                s3_img_url = v['s3_img_url'],
                detail_page_url = v['detail_page_url'],
            ).save()

        return JsonResponse({'message' : 'DB 업데이트 성공'}, status=200)

class ShowClothListView(View):
    def get(self, request):
        # query id and s3_url from DB
        queryset = Goods.objects.values('id', 'goods_name', 'brand_name', 's3_img_url')
        serializer = GoodsListSerializer(queryset, many=True)

        return JsonResponse({'data' : serializer.data }, safe=False)

class ShowDetailView(View):
    def get(self, request):
        # query detail_page_url from DB
        data = json.loads(request.body)
        goods_id = data["id"]

        queryset = Goods.objects.filter(id=goods_id)
        serializer = GoodsDetailSerializer(queryset, many=True)
        
        return JsonResponse({'data' : serializer.data}, safe=False)


class DipsView(View):
    def post(self, request):
        # need user_id, goods_id
        data = json.loads(request.body)

        Dips(
            user = User.objects.get(user_id=data['user_id']),
            goods = Goods.objects.get(id=data['goods_id'])
        ).save()

        return JsonResponse({'message' : '찜 목록 추가 성공'}, status=200)
    
    def get(self, request):
        # need user_id
        data = json.loads(request.body)

        queryset = Dips.objects.filter(user_id=data['user_id'])
        
        serializer = DipsListSerializer(queryset, many=True)

        return JsonResponse({'data' : serializer.data}, safe=False)
