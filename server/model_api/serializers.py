from django.core import serializers
from rest_framework import serializers
from .models import StoragePath

"""
class StoragePathSerializer(serializers.ModelSerializer):
    class Meta:
        model = StoragePath
        fields = ['user_id', 
                  'human_img_path',
                  'cloth_img_path',
                  'preprocessing_human_img_path',
                  'preprocessing_cloth_img_path',
                  'human_parsing_keypoints_path',
                  'result_img_path']
        
    user_id = serializers.CharField(max_length=100)
    human_img_path = serializers.CharField(max_length=100)
    cloth_img_path = serializers.CharField(max_length=100)
    preprocessing_human_img_path = serializers.CharField(max_length=100)
    preprocessing_cloth_img_path = serializers.CharField(max_length=100)
    human_parsing_keypoints_path = serializers.CharField(max_length=100)
    result_img_path = serializers.CharField(max_length=100)
"""