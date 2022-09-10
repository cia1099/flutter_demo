import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/app_colors.dart';
import 'package:notes_app/views/all_view.dart';

class Note {
  final int id;
  final String title;
  final String photo;
  final List<String> items;
  final String iconCode;
  final String description;
  final String date;
  final String goal;
  final int getItems;

  Note(this.id, this.title, this.photo, this.items, this.iconCode,
      this.description, this.date, this.getItems, this.goal);

  factory Note.fromJson(Map<String, dynamic> obj) {
    List<String> items =
        obj["items"].substring(0, obj["items"].length - 1).split(" ");
    items.removeWhere((item) => item.length < 3);
    final date = DateFormat.MMMd().format(DateTime.parse(obj["createdAt"]));
    return Note(obj["id"], obj["title"], obj["photo"], items, obj["iconCode"],
        obj["description"], date, obj["getItems"], obj["goal"]);
  }

  List<Widget> createQuoteList(BuildContext context) {
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
      DateFooter(date: date, footerText: goal),
    ];
  }

  List<Widget> createCheckList(BuildContext context) {
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
      DateFooter(date: date, footerText: goal),
    ];
  }

  List<Widget> createPaintList() {
    return [
      Container(
          height: 150,
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: Image.network(
            photo,
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
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: DateFooter(date: date, footerText: goal),
      ),
      const SizedBox(
        height: 16,
      ),
    ];
  }
}
