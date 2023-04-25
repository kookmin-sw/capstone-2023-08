from django.db import models

class Goods(models.Model):
    id = models.IntegerField(primary_key=True)
    goods_name = models.CharField(max_length=100)
    brand_name = models.CharField(max_length=100)
    s3_img_url = models.URLField()
    detail_page_url = models.URLField()
