import json
from django.views import View
from django.http import JsonResponse
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from .models import User
from .serializers import UserSerializer

class SignUpView(View):
    def post(self, request):
        data = json.loads(request.body)

        if User.objects.filter(user_id = data['user_id']).exists():
            return JsonResponse({'messge' : '이미 등록된 아이디입니다.'}, status=400)

        user = User(
            user_id = data['user_id'],
            user_name = data['user_name'],
            password = data['password'],
            user_img_url = data['user_img_url']
        )
        user.save()
        res = JsonResponse({'message' : '회원가입이 완료되었습니다.' }, status=200)

        return res

class SignInView(View):
    def post(self, request):
        data = json.loads(request.body)

        if User.objects.filter(user_id = data['user_id']).exists():
            user = User.objects.get(user_id = data['user_id'])

            if user.password == data['password']:
                token = TokenObtainPairSerializer.get_token(user)
                refresh_token = str(token)
                access_token = str(token.access_token)

                serializer = UserSerializer(user)

                return JsonResponse({
                    'messge' : f'{user.user_name}님, 로그인 성공.',
                    'User' : serializer.data,
                    'jwt_token': {
                        'access_token' : access_token,
                        'refresh_token' : refresh_token },
                    },
                    status=200)
            else:
                return JsonResponse({'message' : '비밀번호가 틀립니다. 다시한번 확인해주세요'}, status=400)
        
        res = JsonResponse({'message' : '등록되지 않은 아이디입니다.'}, status=400)
        
        res.set_cookie('access_token', access_token, httponly=True)
        res.set_cookie('refresh_token', refresh_token, httponly=True)

        return res
