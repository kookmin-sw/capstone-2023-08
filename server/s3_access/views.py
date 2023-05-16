import json
import boto3
import botocore
from rest_framework.viewsets import ModelViewSet
from rest_framework.decorators import action, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.http import JsonResponse

@permission_classes([IsAuthenticated])
class CreatePresignedUrl(ModelViewSet):

    @action(methods=['get'], detail=False)
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
