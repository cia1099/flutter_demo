import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'all_view.dart';

import '../model/note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(
      {super.key, this.padding, required this.note, required this.children});
  final EdgeInsetsGeometry? padding;
  final List<Widget> children;
  final Note note;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...children,
            DateFooter(date: note.date, footerText: note.goal),
          ],
        ),
      ),
    );
  }
}

List<Widget> createQuoteList(
    BuildContext context, String title, String description) {
  return [
    Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(
      height: 8,
    ),
    Text(description),
    const SizedBox(
      height: 16,
    ),
  ];
}

List<Widget> createCheckList(
    BuildContext context, String title, List<String> items, int getItems) {
  return [
    Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(
      height: 8,
    ),
    for (int i = 0; i < items.length; i++)
      i < getItems
          ? ListTileRow(isChecked: true, text: items[i])
          : ListTileRow(
              isChecked: false,
              text: items[i],
            ),
    const SizedBox(
      height: 16,
    ),
  ];
}

List<Widget> createPaintList(String imgUrl, String title, String description) {
  return [
    Container(
        height: 150,
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: Image.network(
          imgUrl,
          fit: BoxFit.cover,
        )),
    const SizedBox(
      height: 16,
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.location,
            color: AppColors.lightGrey,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: TextStyle(color: AppColors.lightGrey),
          ),
        ],
      ),
    ),
    const SizedBox(
      height: 16,
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        description,
        style: TextStyle(color: AppColors.lightGrey),
      ),
    ),
    const SizedBox(
      height: 16,
    ),
    const SizedBox(
      height: 16,
    ),
  ];
}

class ListTileRow extends StatelessWidget {
  const ListTileRow({Key? key, required this.isChecked, required this.text})
      : super(key: key);
  final String text;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 32,
          width: 16,
          child: Checkbox(
            shape: const CircleBorder(
              side: BorderSide(
                width: 2,
                color: AppColors.white,
              ),
            ),
            value: isChecked,
            activeColor: AppColors.white,
            checkColor: AppColors.grey,
            onChanged: (bool? val) {},
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  decoration: isChecked ? TextDecoration.lineThrough : null)),
        )
      ],
    );
  }
}
