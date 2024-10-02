import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ClickableText extends StatefulWidget {
  final String text;
  final Future<T?> Function<T>(String)? onTap;
  final TextStyle? style;
  final TextOverflow? overflow;
  const ClickableText(
      {super.key, required this.text, this.onTap, this.style, this.overflow});

  @override
  State<ClickableText> createState() => _ClickableTextState();
}

class _ClickableTextState extends State<ClickableText> {
  int? _selectedIndex;
  late final words = widget.text
      .split(RegExp(r'(?=\s+|[,.!?])|(?<=\s+|[,.!?])'))
      .where((w) => w.isNotEmpty)
      .toList();
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
          children:
              List.generate(words.length, (i) => assignWord(words[i], i))),
      style: widget.style,
      overflow: widget.overflow,
    );
  }

  TextSpan assignWord(String word, int index) {
    return TextSpan(
        text: word,
        style: _selectedIndex != index
            ? null
            : TextStyle(
                backgroundColor: Theme.of(context).primaryColor,
                color: Colors.white),
        recognizer: word.contains(RegExp(r'(?=\s+|[,.!?])'))
            ? null
            : TapGestureRecognizer()
          ?..onTap = () {
            setState(() {
              _selectedIndex = index;
            });
            widget.onTap?.call(word).then((_) => setState(() {
                  _selectedIndex = null;
                }));
          });
  }
}
