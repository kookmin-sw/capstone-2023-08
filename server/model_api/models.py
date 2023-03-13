from django.db import models

class StoragePath(models.Model):
    user_id = models.AutoField(primary_key=True)
    human_img_path = models.CharField(max_length=100, blank=True, default='')
    cloth_img_path = models.CharField(max_length=100, blank=True, default='')
    preprocessing_human_img_path = models.CharField(max_length=100, blank=True, default='')
    preprocessing_cloth_img_path = models.CharField(max_length=100, blank=True, default='')
    human_parsing_keypoints_path = models.CharField(max_length=100, blank=True, default='')

    result_img_path = models.CharField(max_length=100, blank=True, default='')