import json
from django.views import View
from django.http import JsonResponse
from .models import Dips
from accounts.models import User
from musinsa_list.models import Goods

class AddDips(View):
    def post(self, request):
        # need user_id, goods_id
        data = json.loads(request.body)
        
        Dips(
            user = User.objects.get(user_id=data['user_id']),
            goods = Goods.objects.get(id=data['goods_id'])
        ).save()
    
        return JsonResponse({'message' : '찜 목록 추가 성공'}, status=200)

