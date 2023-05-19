from django.shortcuts import render
from django.http import FileResponse
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import action, authentication_classes, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication


from .utils import S3Client, HumanImgPreprocessing, ImgInference, store_img

import json
from PIL import Image


@authentication_classes([JWTAuthentication])
@permission_classes([IsAuthenticated])
class HumanParsing(APIView):
    def post(self, request):
        data = json.loads(request.body)
        user_id = request.user

        bucket_name = "user-human-img"
        s3 = S3Client(bucket_name,
                      user_id)
        
        s3.load_human_image(data['human_img_path'])

        human = HumanImgPreprocessing(user_id)

        try:
            human.parsing_human_pose()
        except:  
            return Response("failed", status=status.HTTP_400_BAD_REQUEST)

        return Response("success", status=status.HTTP_201_CREATED)  


@authentication_classes([JWTAuthentication])
@permission_classes([IsAuthenticated])
class Inference(APIView):
    def post(self, request):
        data = json.loads(request.body)
        user_id = request.user

        bucket_name = 'user-cloth-img'
        s3 = S3Client(bucket_name,
                      user_id)
        
        s3.load_cloth_image(data['cloth_img_path'])

        cloth = ImgInference(user_id)

        try:
            cloth.preprocessing_cloth()
            result_path = cloth.inference()

            return FileResponse(open(result_path, 'rb'), content_type='image/png')

        except:
            return Response("failed", status=status.HTTP_400_BAD_REQUEST)


@authentication_classes([JWTAuthentication])
@permission_classes([IsAuthenticated])
class ResultFeedback(APIView):
    def post(self, request):
        data = json.load(request)
        user_id = request.user

        try:
            store_img(user_id)
        except:  
            return Response("failed", status=status.HTTP_400_BAD_REQUEST)

        return Response("success", status=status.HTTP_201_CREATED)
