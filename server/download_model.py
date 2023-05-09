import gdown  # !pip install gdown


# 포즈 예측 모델
url_pose_estimation = 'https://drive.google.com/uc?id=1hOHMFHEjhoJuLEQY0Ndurn5hfiA9mwko'
gdown.download(url_pose_estimation, 'pose_iter_440000.caffemodel', quiet=False)

# human 세그멘테이션 마스크 생성 모델
url_human_segmentation = 'https://drive.google.com/uc?id=1k4dllHpu0bdx38J7H28rVVLpU-kOHmnH'
gdown.download(url_human_segmentation, 'lip_final.pth', quiet=False)

# 옷 mask 추출 모델
url_u2netp = 'https://drive.google.com/uc?id=1rbSTGKAE-MTxBYHd-51l2hMOQPT_7EPy'
url_u2net = 'https://drive.google.com/uc?id=1ao1ovG1Qtx4b7EoskHXmi2E9rp5CHLcZ'
gdown.download(url_u2netp, 'u2netp.pth', quiet=False)
gdown.download(url_u2net, 'u2net.pth', quiet=False)

# ACGPN 모델
url_acgpn = 'https://drive.google.com/uc?id=1UWT6esQIU_d4tUm8cjxDKMhB8joQbrFx'
gdown.download(url_acgpn, 'ACGPN_checkpoints.zip', quiet=False)
