from django.db import models

class Goods(models.Model):
    
    id = models.IntegerField(primary_key=True)
    goods_name = models.CharField(max_length=100)
    s3_img_url = models.URLField()
    detail_pate_url = models.URLField()
    is_latest = models.BooleanField()


    