import jwt
from .settings import SECRET_KEY

class jwt_decode:
    def get_payload(request):
        authroization = request.META['HTTP_AUTHORIZATION']
        access_token = authroization.split(' ')[1]
        payload = jwt.decode(
                access_token, SECRET_KEY, algorithms=['HS256'])
        
        return payload