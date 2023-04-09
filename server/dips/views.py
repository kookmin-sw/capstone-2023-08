import json
from django.views import View
from django.http import JsonResponse
from .models import Dips
from accounts.models import User
from musinsa_list.models import Goods
from .serializers import DipsListSerializer

class AddDips(View):
    def post(self, request):
        # need user_id, goods_id
        data = json.loads(request.body)
        
        Dips(
            user = User.objects.get(user_id=data['user_id']),
            goods = Goods.objects.get(id=data['goods_id'])
        ).save()
    
        return JsonResponse({'message' : '찜 목록 추가 성공'}, status=200)

class DeleteDips(View):
    def post(self, request):
        # need user_id, goods_id
        data = json.loads(request.body)

        item = Dips.objects.get(user_id=data['user_id'], goods_id=data['goods_id'])
        item.delete()

        return JsonResponse({'message' : '찜 목록 상품 삭제 성공'}, status=200)

class ShowDips(View):
    def get(self, request):
        # need user_id
        data = json.loads(request.body)

        queryset = Dips.objects.filter(user_id=data['user_id'])
        serializer = DipsListSerializer(queryset, many=True)

        return JsonResponse({'data' : serializer.data}, safe=False)
