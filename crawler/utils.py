import torch
import torch.nn as nn
import torchvision.models as models
import torchvision.transforms as transforms
from PIL import Image


class ClassificationModel:
    def __init__(self, weight_path):
        self.model = models.resnet101(weights=None)
        self.model.fc = nn.Linear(self.model.fc.in_features, 2)
        self.weight = weight_path
        self.model.load_state_dict(torch.load(weight_path, map_location=torch.device('cpu')))

    def inference(self, img_path):
        img = transforms.Compose([
                transforms.Resize(256),
                transforms.ToTensor(),
                transforms.Normalize(
                mean=[0.485, 0.456, 0.406],
                std=[0.229, 0.224, 0.225]
                )
            ])(Image.open(img_path))

        self.model.eval()
        with torch.no_grad():
            output = self.model(img.unsqueeze(0).cpu())
            prediction = torch.argmax(output, dim=1)
        # 0: bad, 1: good
        return prediction.item()

