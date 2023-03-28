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
        Goods(
            id = data['id'],
            goods_name = data['goods_name'],
            s3_img_url = data['s3_img_url'],
            detail_page_url = data['detail_page_url'],
            is_latest = data['is_latest']
        ).save()

        return JsonResponse({'message' : 'DB 업데이트 성공'}, status=200)