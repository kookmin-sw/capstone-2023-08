from django.shortcuts import render
from django.http import JsonResponse
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response

from .utils import S3Client, HumanImgPreprocessing, ImgInference

import json


class HumanParsing(APIView):
    def post(self, request):
        data = json.loads(request.body)

        s3 = S3Client('bucket_name',
                      data['user_id'])
        
        s3.load_human_image(data['human_img_path'])

        human = HumanImgPreprocessing(data['user_id'])

        try:
            human.parsing_human_pose()
        except:  
            return Response("failed", status=status.HTTP_400_BAD_REQUEST)

        return Response("success", status=status.HTTP_201_CREATED)  


class Inference(APIView):
    def post(self, request):
        data = json.loads(request.body)

        s3 = S3Client('bucket_name',
                      data['user_id'])
        
        s3.load_cloth_image(data['cloth_img_path'])

        cloth = ImgInference(data['user_id'])
        
        try:
            cloth.preprocessing_cloth()
            cloth.inference()
        except:  
            return Response("failed", status=status.HTTP_400_BAD_REQUEST)

        return Response("success", status=status.HTTP_201_CREATED)  