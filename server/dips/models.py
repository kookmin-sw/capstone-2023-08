from django.db import models
from accounts.models import User
from musinsa_list.models import Goods


class Dips(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    goods = models.ForeignKey(Goods, on_delete=models.CASCADE)
