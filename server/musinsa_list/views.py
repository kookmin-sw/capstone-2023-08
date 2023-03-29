import json
from django.views import View
from django.http import JsonResponse
from .models import Goods

class RecieveCrawlingResultView(View):
    def post(self, request):
        # make all is_latest value into False
        ### TO-DO

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