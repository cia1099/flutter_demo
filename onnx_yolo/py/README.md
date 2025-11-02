# How Start
* One comment to install virtual environment
```sh
uv sync
```

* Appoint virtual environment name
```sh
uv venv venv --python 3.13
source venv/bin/activate
uv pip install -e .
```

---

### Preprocess image

1. img = cv2.resize(im0, imgsz)
目的: 调整图像尺寸。
变化: 将原始尺寸 (H, W, 3) 的图像直接缩放（或拉伸）到模型输入尺寸 (640, 640, 3)。
注意: 这里的注释写的是 "Padded resize" (带边框的缩放)，但代码实现的是 cv2.resize，这是一种直接缩放，可能会导致图像比例失真。标准的 YOLOv5 detect.py 会使用 letterbox 方式进行带边框的缩放来保持原始比例。对于这个简化脚本，直接缩放更简单。

2. img = img.transpose((2, 0, 1))
目的: 调整维度顺序。
变化: 将 (H, W, C) 格式变为 (C, H, W) 格式。图像尺寸从 (640, 640, 3) 变为 (3, 640, 640)。这是 PyTorch 框架处理图像的通用格式。

3. img = np.expand_dims(img, 0)
目的: 增加批次维度 (Batch Dimension)。
变化: 模型总是期望接收一个批次 (batch) 的数据进行处理，即使这个批次里只有一张图片。此操作在最前面增加一个维度，使图像尺寸从 (3, 640, 640) 变为 (1, 3, 640, 640)。这里的 1 就是批次大小。

4. img = np.ascontiguousarray(img)
目的: 确保内存连续。
变化: transpose 操作可能会导致 NumPy 数组在内存中的存储变得不连续。这一步将它转换成连续的内存块，可以提高后续 PyTorch 操作的效率。

5. img = torch.from_numpy(img).to(model.device)
目的: 转换为 PyTorch 张量。
变化: 将 NumPy 数组 img 转换为 PyTorch 的 Tensor 数据结构，并将其发送到指定的计算设备（如 CPU 或 GPU）。

6. img = img.float()
目的: 转换数据类型。
变化: 将张量的数据类型从 uint8 (整数) 转换为 float32 (32位浮点数)。神经网络的计算通常使用浮点数。

7. img /= 255.0
目的: 归一化。
变化: 将像素值的范围从 0-255 缩放到 0.0-1.0。这是通过将每个像素值除以 255 实现的。归一化是神经网络训练和推理中的标准步骤，有助于模型的稳定和收敛。
总结：im0 vs img

特性	|原始图像 im0|	模型输入 img
--|--|--
数据结构|	NumPy Array|	PyTorch Tensor
尺寸/形状|	(H, W, C)|	(1, C, H, W) 即 (1, 3, 640, 640)
通道顺序|	BGR	|BGR (因为没有显式转换)
数据类型|	uint8	|float32
数值范围|	0 - 255	|0.0 - 1.0

经过这一系列转换，img 就变成了模型所期望的 [batch, channels, height, width] 格式的浮点数张量，可以被送入模型进行推理了。