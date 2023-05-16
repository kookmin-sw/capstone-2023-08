import json
from django.views import View
from django.http import JsonResponse
from rest_framework.viewsets import ModelViewSet
from rest_framework.decorators import action, permission_classes
from rest_framework.permissions import AllowAny

from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework import status

from .models import User
from .serializers import UserSerializer

@permission_classes([AllowAny])
class SignUpView(ModelViewSet):
    @action(methods=['GET'], detail=False)
    def id_validator(self, request):
        # check id already exists
        data = json.loads(request.body)

        try:
            if User.objects.filter(user_id = data['user_id']).exists():
                return JsonResponse({'message' : '이미 등록된 아이디입니다.'}, status=status.HTTP_205_RESET_CONTENT)
            else:
                return JsonResponse({'message' : '사용 가능한 아이디입니다.'}, status=status.HTTP_200_OK)

        except KeyError:    
           return JsonResponse({'error' : 'ID field is required.'}, status=status.HTTP_400_BAD_REQUEST)
    
    
    @action(methods=['GET'], detail=False)
    def name_validator(self, request):
        # check user_name already exists
        data = json.loads(request.body)

        try:
            if User.objects.filter(user_name = data['user_name']).exists():
                return JsonResponse({'message' : '이미 등록된 닉네임입니다.'}, status=status.HTTP_205_RESET_CONTENT)
            else:
                return JsonResponse({'message' : '사용 가능한 닉네임입니다.'}, status=status.HTTP_200_OK)

        except KeyError:    
           return JsonResponse({'error' : 'user_name field is required.'}, status=status.HTTP_400_BAD_REQUEST)

    @action(methods=['POST'], detail=False)
    def post(self, request):
        data = json.loads(request.body)
        
        user = User()
        try:
            user.user_img_url = data['user_img_url']
        except KeyError:
            pass
        
        try:
            user.user_id = data['user_id']
            user.user_name = data['user_name']
            user.password = data['password']
            
            user.save()
            res = JsonResponse({'message' : '회원가입이 완료되었습니다.'}, status=status.HTTP_201_CREATED)
            
            return res

        except KeyError:
            return JsonResponse({'error' : 'all form must be filled.'}, status=status.HTTP_400_BAD_REQUEST)


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
                res =  JsonResponse({
                    'message' : f'{user.user_name}님, 로그인 성공.',
                    'User' : serializer.data,
                    'jwt_token': {
                        'access_token' : access_token,
                        'refresh_token' : refresh_token },
                    },
                    status=status.HTTP_200_OK)

                res.set_cookie('access_token', access_token, httponly=True)
                res.set_cookie('refresh_token', refresh_token, httponly=True)

                return res
                
            else:
                return JsonResponse({'message' : '비밀번호가 틀립니다. 다시한번 확인해주세요'}, status=status.HTTP_400_BAD_REQUEST)
        
        return JsonResponse({'message' : '등록되지 않은 아이디입니다.'}, status=status.HTTP_400_BAD_REQUEST)
