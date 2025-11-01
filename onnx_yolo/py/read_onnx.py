import yaml
import onnxruntime as ort
import numpy as np
import cv2
from pathlib import Path


# ---------- 1. 模型初始化 ----------
model_path = "../assets/models/yolo11n.ort"
session = ort.InferenceSession(model_path, providers=["CPUExecutionProvider"])
input_name = session.get_inputs()[0].name
output_name = session.get_outputs()[0].name

# ---------- 2. 前处理 ----------
img_path = "img/bus.jpg"
orig_img = cv2.imread(img_path)
h0, w0 = orig_img.shape[:2]

# resize 到 640x640 并做归一化
img = cv2.resize(orig_img, (640, 640))
# pimg = Path(img_path)
# cv2.imwrite(f"{pimg.parent}/yolo_sized_{pimg.name}", img)
img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
img = img.astype(np.float32) / 255.0
print(np.round(img[0, 0:10, 0], 2))
img = np.transpose(img, (2, 0, 1))  # HWC -> CHW
img = np.expand_dims(img, axis=0)  # NCHW


# ---------- 3. 推理 ----------
pred = session.run([output_name], {input_name: img})[0]

# 输出形状说明
# YOLO11 输出是 [1, 84, N]
if pred.shape[1] <= 85:
    pred = np.transpose(pred, (0, 2, 1))
# 每个框格式为 [x, y, w, h, conf, cls0, cls1, ..., cls79]
pred = np.squeeze(pred)  # [84, N,]

# ---------- 4. 后处理 ---------- older version e.g. yolov5s
boxes = pred[:, :4]
print(boxes[0, :])
# scores = pred[:, 4] #objectness
# class_probs = pred[:, 5:] #objectness
class_probs = pred[:, 4:]
class_ids = np.argmax(class_probs, axis=1)
# confidences = scores * class_probs[np.arange(len(class_probs)), class_ids]


# 计算类别置信度和类别ID for 11n
# class_ids = np.argmax(class_probs, axis=1)
confidences = np.max(class_probs, axis=1)

# 筛选置信度阈值
conf_threshold = 0.25
nms_threshold = 0.45
mask = confidences > conf_threshold
boxes = boxes[mask]
confidences = confidences[mask]
class_ids = class_ids[mask]

# 将 xywh 转为 xyxy（左上角 + 右下角）
boxes_xyxy = np.zeros_like(boxes)
boxes_xyxy[:, 0] = boxes[:, 0] - boxes[:, 2] / 2  # x1
boxes_xyxy[:, 1] = boxes[:, 1] - boxes[:, 3] / 2  # y1
boxes_xyxy[:, 2] = boxes[:, 0] + boxes[:, 2] / 2  # x2
boxes_xyxy[:, 3] = boxes[:, 1] + boxes[:, 3] / 2  # y2

# ---------- 5. NMS（非极大值抑制） ----------
indices = cv2.dnn.NMSBoxes(
    boxes_xyxy.tolist(),
    confidences.tolist(),
    conf_threshold,
    nms_threshold=nms_threshold,
)

with open("coco.yaml", encoding="utf-8") as f:
    data = yaml.load(f, Loader=yaml.FullLoader)
class_map = data["names"]

# ---------- 6. 画框 ----------
print(f"Slected indices: {indices}")
print(f"Detected object: {", ".join([class_map[i] for i in class_ids[indices]])}")
for i in indices:
    i = int(i)
    box = boxes_xyxy[i]
    x1, y1, x2, y2 = box
    # 缩放回原始图片尺寸
    x1 = int(x1 * w0 / 640)
    y1 = int(y1 * h0 / 640)
    x2 = int(x2 * w0 / 640)
    y2 = int(y2 * h0 / 640)
    cls_id = int(class_ids[i])
    cls_name = class_map[cls_id]
    conf = confidences[i]

    cv2.rectangle(orig_img, (x1, y1), (x2, y2), (0, 255, 0), 2)
    cv2.putText(
        orig_img,
        # f"ID:{cls_id} {conf:.2f}",
        f"{cls_name}: {conf:.2f}",
        (x1, y1 - 5),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.6,
        (255, 255, 255),
        2,
    )

cv2.imshow("YOLO Prediction", orig_img)
cv2.waitKey(0)
cv2.destroyAllWindows()
