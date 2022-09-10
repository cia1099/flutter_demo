import 'package:intl/intl.dart';

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
    final date = DateFormat.MMMMd().format(DateTime.parse(obj["createdAt"]));
    return Note(obj["id"], obj["title"], obj["photo"], items, obj["iconCode"],
        obj["description"], date, obj["getItems"], obj["goal"]);
  }
}
