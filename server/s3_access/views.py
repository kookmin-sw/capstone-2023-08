import json
import boto3
import botocore
from django.views import View
from django.http import JsonResponse

class CreatePresignedUrl(View):
    def get(self, request):
        data = json.loads(request.body)
        
        bucket_name = data['bucket_name']
        file_path = data['file_path']

        client = boto3.client('s3',config=botocore.client.Config(signature_version='s3v4'))
        presigned_url = client.generate_presigned_url(ClientMethod='put_object',
                                                      Params={'Bucket' : bucket_name,
                                                                'Key' : file_path},
                                                      ExpiresIn=300)
        
        return JsonResponse({'data' : presigned_url}, status=200)
