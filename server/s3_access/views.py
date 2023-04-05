import json
import boto3
import botocore
from django.views import View
from django.http import JsonResponse

BUCKET_NAME = "user-human-img"

class CreatePresignedUrl(View):
    def get(self, request):
        # get user_id
        data = json.loads(request.body)
        user_id = data['user_id']

        image_path = f"{user_id}.jpg"

        client = boto3.client('s3',config=botocore.client.Config(signature_version='s3v4'))
        presigned_url = client.generate_presigned_url(ClientMethod='put_object',
                                                      Params={'Bucket' : BUCKET_NAME,
                                                                'Key' : image_path},
                                                      ExpiresIn=300)
        
        return JsonResponse({'data' : presigned_url}, status=200)