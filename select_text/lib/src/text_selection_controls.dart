import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CustomTextSelectionControls extends CupertinoTextSelectionControls {
  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset selectionMidpoint,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ValueListenable<ClipboardStatus>? clipboardStatus,
      Offset? lastSecondaryTapDownPosition) {
    // TODO: implement buildToolbar
    // 计算 primaryAnchor 和 secondaryAnchor
    final primaryAnchor = globalEditableRegion.topLeft +
        selectionMidpoint +
        getHandleAnchor(TextSelectionHandleType.left, textLineHeight)
            .scale(1, 0.1);
    final secondaryAnchor = globalEditableRegion.topLeft +
        selectionMidpoint -
        getHandleAnchor(TextSelectionHandleType.right, textLineHeight)
            .scale(1, 0.1);
    return CupertinoAdaptiveTextSelectionToolbar.buttonItems(
      buttonItems: [
        ContextMenuButtonItem(
          label: '复制',
          type: ContextMenuButtonType.copy,
          onPressed: () {
            handleCopy(delegate);
          },
        ),
        ContextMenuButtonItem(
          label: 'Search',
          type: ContextMenuButtonType.searchWeb,
          onPressed: () {
            final selection = delegate.textEditingValue.selection;
            final text = delegate.textEditingValue.text
                .substring(selection.start, selection.end);
            print(text);
          },
        ),
        ContextMenuButtonItem(
          label: '粘贴',
          type: ContextMenuButtonType.paste,
          onPressed: () {
            // editableTextState.pasteText(SelectionChangedCause.keyboard);
          },
        ),
        ContextMenuButtonItem(
          label: '自定义操作',
          onPressed: () {
            // 你可以在这里添加自定义逻辑
            print('自定义操作');
          },
        ),
      ],
      anchors: TextSelectionToolbarAnchors(
          primaryAnchor: primaryAnchor, secondaryAnchor: secondaryAnchor),
    );
  }
}

// -: MARK usage
/**
SelectableRegion(
              focusNode: FocusNode(),
              selectionControls: CustomTextSelectionToolbar(),
              child: HtmlWidget(
                key: selectedKey,
                html,
                customStylesBuilder: (element) {
                  final cssMap = {
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
                  for (final className in element.classes) {
                    return cssMap[className];
                  }
                  return null;
                },
                onTapUrl: (url) {
                  print('tapped $url');
                  return true;
                },
                textStyle: TextStyle(
                  fontSize: 32,
                ),
              ),
            ),
 */
