import 'package:spritewidget/spritewidget.dart';
import 'package:path/path.dart' as p;

class ChatModel {
  static final List<String> _contents = [
    '不要抱怨${'\n' * 10}抱我',
    '你知道你和星星有什么区别吗?\n星星在天上${'\n' * 5}你在我心里',
    '你最近是不是又胖了?${'\n' * 1}那为什么在我心里的分量越来越重了?',
    '这是我的手背\n这是我的脚背${'\n' * 5}你是我的宝贝',
    '你知道你像什么人吗?${'\n' * 6}我的女人',
    '莫文蔚的阴天\n孙燕姿的雨天\n周杰伦的晴天${'\n' * 3}都不如你和我聊天',
    '面对你\n我不仅善解人意${'\n' * 5}我还善解人衣',
    '我还是喜欢你${'\n' * 3}像小时候吃辣条\n不看日期',
    '我很能干但有一件事不会${'\n' * 3}什么?${'\n' * 1}不会离开你',
    '你今天特别讨厌${'\n' * 3}讨人喜欢和百看不厌',
    '你知道世界上最冷的地方是哪吗?${'\n' * 2}是没有你的地方'
  ];
  static String talk() {
    return _contents[randomInt(_contents.length)];
  }

  static final List<String> _images = [
    'mmexport1561098690550.jpg',
    'mmexport1563787385524.jpg',
    'IMG_1200.jpg',
    'mmexport1561665919018.jpg',
    'IMG_20191214_095109.jpg',
    'IMG_20191210_120725.jpg',
    'IMG_20191024_190440.jpg',
    'IMG_20191213_135708.jpg',
    'IMG_20191213_135911.jpg',
    'IMG_20191213_142643.jpg',
    'IMG_20191211_121124.jpg',
  ];
  static String getImage() {
    return p.join('assets/img', _images[randomInt(_images.length)]);
  }
}
