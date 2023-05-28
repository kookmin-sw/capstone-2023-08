from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager

class UserManager(BaseUserManager) :
    # define user creation
    use_in_migrations = True    # for serialization

    def create_user(self, user_id, password, user_name, user_img_url) :
        if not user_id : 
            raise ValueError('must have user id')
        if not password :
            raise ValueError('must have password')
        if not user_name : 
            raise ValueError('must have user name')
    
        user = self.model(user_id=user_id,  
                          user_name=user_name, 
                          user_img_url=user_img_url
                        )
        user.set_password(password)
        user.save(using=self._db)

        return user
    
    def create_superuser(self, user_id, password, user_name) :
        user = self.create_user(
            user_id=user_id,
            password=password,
            user_name=user_name,
            user_img_url='None'
        )

        user.is_admin = True
        user.is_superuser = True
        user.save(using=self._db)

        return user

class User(AbstractBaseUser) :
    USERNAME_FIELD='user_id'

    objects = UserManager()

    user_id = models.CharField(max_length=20, unique=True, primary_key=True)
    password = models.CharField(max_length=20)
    user_name = models.CharField(max_length=10, unique=True)
    user_img_url = models.URLField(unique=True, null=True)

    is_admin = models.BooleanField(default=False)

    USERNAME_FIELD = 'user_id'      # 실제 로그인시 사용되는 id field
    REQUIRED_FIELDS = ['user_name']            # 어드민 계정 만들시 입력받을 정보

    def _str_(self) :
        return "<%d %s %s>" %(self.pk, self.user_id, self.user_name)
        