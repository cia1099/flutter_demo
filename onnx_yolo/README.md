# onnx_yolo

A deployment model on Flutter project.

## Getting Started

```sh
flutter create --org com.cia1099 --platforms=ios,android onnx_yolo
```

### Transform models to ONNX format

[Download models](https://github.com/ultralytics/yolov5?tab=readme-ov-file#pretrained-checkpoints)
[ultralytics tutorial](https://github.com/ultralytics/yolov5?tab=readme-ov-file#pretrained-checkpoints)


#### Prerequire
```sh
source py/.venv/bin/activate
pip install ultralytics onnx onnxsim 
```
直接下载[yolo11n](https://docs.ultralytics.com/zh/integrations/onnx/#installation)并且直接用Ultralytic转换为`.onnx`格式。下面不必看
```sh
yolo export model=yolo11n.pt format=onnx
```
COCO classes names
```py
COCO_CLASSES = [
    "person", "bicycle", "car", "motorcycle", "airplane", "bus", "train", "truck",
    "boat", "traffic light", "fire hydrant", "stop sign", "parking meter", "bench",
    "bird", "cat", "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra",
    "giraffe", "backpack", "umbrella", "handbag", "tie", "suitcase", "frisbee",
    "skis", "snowboard", "sports ball", "kite", "baseball bat", "baseball glove",
    "skateboard", "surfboard", "tennis racket", "bottle", "wine glass", "cup",
    "fork", "knife", "spoon", "bowl", "banana", "apple", "sandwich", "orange",
    "broccoli", "carrot", "hot dog", "pizza", "donut", "cake", "chair", "couch",
    "potted plant", "bed", "dining table", "toilet", "tv", "laptop", "mouse",
    "remote", "keyboard", "cell phone", "microwave", "oven", "toaster", "sink",
    "refrigerator", "book", "clock", "vase", "scissors", "teddy bear", "hair drier",
    "toothbrush"
]
```
