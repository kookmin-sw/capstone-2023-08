from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response

from .utils import S3Client, HumanImgPreprocessing, ImgInference, store_img

import json
from PIL import Image


class HumanParsing(APIView):
    def post(self, request):
        data = json.loads(request.body)

        bucket_name = "user-human-img"
        s3 = S3Client(bucket_name,
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

        bucket_name = 'user-cloth-img'
        s3 = S3Client(bucket_name,
                      data['user_id'])
        
        s3.load_cloth_image(data['cloth_img_path'])

        cloth = ImgInference(data['user_id'])

        try:
            cloth.preprocessing_cloth()
            result_path = cloth.inference()

            response = HttpResponse(mimetype="image/png")
            img = Image.open(result_path)
            img.save(response,'png')
            return response
            # try:
            #     with open(valid_image, "rb") as f:
            #         return HttpResponse(f.read(), content_type="image/jpeg")
            # except IOError:
            #     red = Image.new('RGBA', (1, 1), (255,0,0,0))
            #     response = HttpResponse(content_type="image/jpeg")
            #     red.save(response, "JPEG")
            #     return response
        except:
            return Response("failed", status=status.HTTP_400_BAD_REQUEST)


class ResultFeedback(APIView):
    def post(self, request):
        data = json.load(request)

        try:
            store_img(data['user_id'],
                      data['cloth_img_path'],
                      data['human_img_path'])
        except:  
            return Response("failed", status=status.HTTP_400_BAD_REQUEST)

        return Response("success", status=status.HTTP_201_CREATED)
        