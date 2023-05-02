import os
import time
import subprocess

from PIL import Image
from ACGPN.predict_pose import generate_pose_keypoints

import ACGPN.U2Net.u2net_load as u2net_load
import ACGPN.U2Net.u2net_run as u2net_run


u2net = u2net_load.model(model_name='u2netp')

cloth_name = f'cloth_{int(time.time())}.png'
cloth_path = os.path.join('ACGPN/inputs/cloth', sorted(os.listdir('ACGPN/inputs/cloth'))[0])
cloth = Image.open(cloth_path)
cloth = cloth.resize((192, 256), Image.BICUBIC).convert('RGB')
cloth.save(os.path.join('ACGPN/Data_preprocessing/test_color', cloth_name))

u2net_run.infer(u2net, 'ACGPN/Data_preprocessing/test_color', 'ACGPN/Data_preprocessing/test_edge')

Image.open(f'ACGPN/Data_preprocessing/test_edge/{cloth_name}')

img_name = f'img_{int(time.time())}.png'
img_path = os.path.join('ACGPN/inputs/img', sorted(os.listdir('ACGPN/inputs/img'))[0])
img = Image.open(img_path)
img = img.resize((192,256), Image.BICUBIC)

img_path = os.path.join('ACGPN/Data_preprocessing/test_img', img_name)
img.save(img_path)

subprocess.run("python3 ACGPN/Self-Correction-Human-Parsing-for-ACGPN/simple_extractor.py\
                --dataset 'lip'\
                --model-restore 'lip_final.pth'\
                --input-dir 'Data_preprocessing/test_img'\
                --output-dir 'Data_preprocessing/test_label'",\
                shell=True)

pose_path = os.path.join('ACGPN/Data_preprocessing/test_pose', img_name.replace('.png', '_keypoints.json'))
generate_pose_keypoints(img_path, pose_path)

subprocess.run("rm -rf ACGPN/Data_preprocessing/test_pairs.txt", shell=True)
with open('ACGPN/Data_preprocessing/test_pairs.txt', 'w') as f:
    f.write(f'{img_name} {cloth_name}')

subprocess.run("ACGPN/python3 test.py", shell=True)