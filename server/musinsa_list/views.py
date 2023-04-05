import json
from django.views import View
from django.http import JsonResponse

from .serializers import GoodsListSerializer, GoodsDetailSerializer
from .models import Goods

class RecieveCrawlingResultView(View):
    def post(self, request):
        # get crawling result file and update DB
        data = json.loads(request.body)
        for k, v in data.items():
            Goods(
                id = v["id"],
                goods_name = v['goods_name'],
                s3_img_url = v['s3_img_url'],
                detail_page_url = v['detail_page_url'],
            ).save()

        return JsonResponse({'message' : 'DB 업데이트 성공'}, status=200)

class ShowClothListView(View):
    def get(self, request):
        # query id and s3_url from DB
        queryset = Goods.objects.values('id', 's3_img_url')
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
