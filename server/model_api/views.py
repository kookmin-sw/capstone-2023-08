from django.shortcuts import render
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response

from .utils import PreprocessingHumanImg, InferenceImg
from .models import StoragePath
from .serializers import StoragePathSerializer


class HumanParsing(APIView):
    def get(self, request):
        storage_path = StoragePath.objects.all()
        serializer = StoragePathSerializer(storage_path, many=True)
        return Response(serializer.data)

    def post(self, request):
        info = StoragePathSerializer(data=request.data)
        human = PreprocessingHumanImg(info['user_id'],
                                      info['human_img_path'],
                                      info['preprocessing_human_img_path'],
                                      info['human_parsing_keypoints_path']
                                      )
        try:
            human.parsing_human_pose()
        except:  
            return Response("failed", status=status.HTTP_400_BAD_REQUEST)

        return Response("success", status=status.HTTP_201_CREATED)  


class Inference(APIView):
    def get(self, request):
        storage_path = StoragePath.objects.all()
        serializer = StoragePathSerializer(storage_path, many=True)
        return Response(serializer.data)

    def post(self, request):
        info = StoragePathSerializer(data=request.data)
        cloth = InferenceImg(info['user_id'],
                             info['cloth_img_path'],
                             info['preprocessing_cloth_img_path'],
                             info['result_img_path']
                             )
        try:
            cloth.preprocessing_cloth()
            cloth.inference()
        except:  
            return Response("failed", status=status.HTTP_400_BAD_REQUEST)

        return Response("success", status=status.HTTP_201_CREATED)  