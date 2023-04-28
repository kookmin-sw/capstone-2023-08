from django.db import models
from accounts.models import User

class Goods(models.Model):
    id = models.IntegerField(primary_key=True)
    goods_name = models.CharField(max_length=100)
    brand_name = models.CharField(max_length=100)
    s3_img_url = models.URLField()
    detail_page_url = models.URLField()


class Dips(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    goods = models.ForeignKey(Goods, on_delete=models.CASCADE)
    