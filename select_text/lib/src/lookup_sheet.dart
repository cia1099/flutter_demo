import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html_flutter/src/db_dictionary.dart';

class LookUpSheet extends StatelessWidget {
  final String word;
  const LookUpSheet({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final html = DBDictionary().lookUp(word);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 300,
      // color: Colors.green,
      child: HtmlWidget(
        html,
        customStylesBuilder: (element) {
          for (final className in element.classes) {
            return cssMap[className];
          }
          return null;
        },
        onTapUrl: (url) {
          print('tapped $url');
          return true;
        },
        textStyle: const TextStyle(
          fontSize: 32,
        ),
      ),
    );
  }

  final cssMap = const {
    'ml-1em': {'margin-left': '1em'},
    'ml-2em': {'margin-left': '2em'},
    'color-navy': {'color': 'navy'},
    'color-purple': {'color': 'purple'},
    'color-darkslategray': {
      'color': 'darkslategray',
      'font-weight': 'bold',
      'font-style': 'italic'
    },
    'color-gray': {'color': 'gray'},
    'color-blue': {'color': 'blue'},
    'color-dodgerblue': {'color': 'dodgerblue'},
    'bold': {'font-weight': 'bold'},
    'italic': {'font-style': 'italic'}
  };
}
