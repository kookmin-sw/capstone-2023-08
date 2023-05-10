import os
import time
import subprocess
import boto3

import ACGPN.U2Net.u2net_load as u2net_load
import ACGPN.U2Net.u2net_run as u2net_run

from PIL import Image
from ACGPN.predict_pose import generate_pose_keypoints


class S3Client:
    def __init__(self, bucket, user_id):

        self.s3 = boto3.client('s3')

        self.bucket = bucket
        self.uid = user_id
    
    def load_cloth_image(self, s3_path):
        path = '/home/ubuntu/capstone/capstone-2023-08/server/ACGPN/Data_preprocessing/test_color'
        img_name = str(self.uid) + '_cloth.png'
        local_path = os.path.join(path, img_name)
        self.s3.download_file(self.bucket, s3_path, local_path)

    def load_human_image(self, s3_path):
        path = '/home/ubuntu/capstone/capstone-2023-08/server/ACGPN/Data_preprocessing/test_img'
        img_name = str(self.uid) + '_human.png'
        local_path = os.path.join(path, img_name)
        self.s3.download_file(self.bucket, s3_path, local_path)

    def upload_cloth_image(self, s3_path):
        path = '/home/ubuntu/capstone/capstone-2023-08/server/ACGPN/Data_preprocessing/test_color'
        img_name = str(self.uid) + '_cloth.png'
        local_path = os.path.join(path, img_name)
        self.s3.upload_file(local_path, self.bucket, s3_path)

    def upload_human_image(self, s3_path):
        path = '/home/ubuntu/capstone/capstone-2023-08/server/ACGPN/Data_preprocessing/test_img'
        img_name = str(self.uid) + '_human.png'
        local_path = os.path.join(path, img_name)
        self.s3.upload_file(local_path, self.bucket, s3_path)
        

class HumanImgPreprocessing:
    def __init__(self,
                 user_id,
                ):
        self.uid = user_id
        self.human_img_path = '/home/ubuntu/capstone/capstone-2023-08/server/ACGPN/Data_preprocessing/test_img'
        self.preprocessing_human_img_path = '/home/ubuntu/capstone/capstone-2023-08/server/ACGPN/Data_preprocessing/test_label'
        self.human_keypoints_path = '/home/ubuntu/capstone/capstone-2023-08/server/ACGPN/Data_preprocessing/test_pose'

    def parsing_human_pose(self):
        img_name = f'{self.uid}_human.png'
        img_path = os.path.join(self.human_img_path, img_name)

        
        try:
            img = Image.open(img_path)
            img = img.resize((192,256), Image.BICUBIC)
            img.save(img_path)
        except IOError as e:
            print("failed img resizing")
            print(e)

        try:
            subprocess.run(f"python3 ACGPN/Self-Correction-Human-Parsing-for-ACGPN/simple_extractor.py\
                            --dataset 'lip'\
                            --model-restore 'ACGPN/lip_final.pth'\
                            --input-dir {self.human_img_path}\
                            --output-dir {self.preprocessing_human_img_path}",
                            shell=True)
        except:
            print("failed img preprocessing")

        pose_path = os.path.join(self.human_keypoints_path, img_name.replace('.png', '_keypoints.json'))
        model_path = 'ACGPN/pose'
        try:
            generate_pose_keypoints(img_path, pose_path, model_path)
        except Exception as e:
            print(e)

        return True


class ImgInference:
    def __init__(self,
                 user_id
                 ):
        self.uid = user_id
        self.cloth_img_path = '/home/ubuntu/capstone/capstone-2023-08/server/ACGPN/Data_preprocessing/test_color'
        self.preprocessing_cloth_img_path = '/home/ubuntu/capstone/capstone-2023-08/server/ACGPN/Data_preprocessing/test_edge'

        self.model = u2net_load.model(model_name='u2netp')

    def preprocessing_cloth(self):
        self.cloth_name = str(self.uid) + '_cloth.png'
        cloth_path = os.path.join(self.cloth_img_path, self.cloth_name)

        try:
            cloth = Image.open(cloth_path)
            cloth = cloth.resize((192, 256), Image.BICUBIC).convert('RGB')
            cloth.save(cloth_path)
        except IOError:
            print("failed img resizing")

        u2net_run.infer(self.model, self.cloth_img_path, self.preprocessing_cloth_img_path)

        return True

    def inference(self):
        img_name = str(self.uid) + '_human.png'
        cloth_name = self.cloth_name

        subprocess.run("rm -rf ACGPN/Data_preprocessing/test_pairs.txt", shell=True)

        with open('ACGPN/Data_preprocessing/test_pairs.txt', 'w') as f:
            f.write(f'{img_name} {cloth_name}')

        subprocess.run("python3 ACGPN/test.py", shell=True)
        
        result_path = '/home/ubuntu/capstone/capstone-2023-08/server/results/test/try-on'
        user_result = os.path.join(result_path, img_name)
        return user_result



def store_img(user_id, cloth_img_path, human_img_path):
    cloth_s3_path = ''
    human_s3_path = ''

    s3 = S3Client('bucket_name', user_id)

    s3.upload_cloth_image(cloth_s3_path)
    s3.upload_human_image(human_s3_path)

    return True