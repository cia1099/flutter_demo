import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_app/app_colors.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/views/curved_box.dart';
import 'package:http/http.dart' as http;
import 'package:notes_app/views/note_card.dart';

class AllView extends StatefulWidget {
  const AllView({Key? key}) : super(key: key);
  static const url = "https://mockend.com/cia1099/temp_demo/posts";
  @override
  State<AllView> createState() => _AllViewState();
}

class _AllViewState extends State<AllView> {
  late final List<Note> allNotes;
  final currNote = <Note>[];
  @override
  void initState() {
    // http.get(Uri.parse(AllView.url)).then((value) {
    //   allNotes = json.decode(value.body);
    // });
    Future.delayed(Duration.zero, () async {
      final response = await http.get(Uri.parse(AllView.url));
      allNotes = json.decode(response.body);
    });
    for (int i = 0; i < 3; i++) {
      currNote.add(allNotes[Random().nextInt(allNotes.length)]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          FontAwesomeIcons.notesMedical,
          color: AppColors.white,
        ),
      ),
      body: AnimationLimiter(
        child: MasonryGridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: currNote.length,
            itemBuilder: (context, i) {
              final note = currNote[i];
              late List<Widget> childrens;
              if (note.goal == "Daily Life") {
                childrens =
                    createPaintList(note.photo, note.title, note.description);
              } else if (note.getItems < note.items.length &&
                  note.goal != "Quote") {
                childrens = createCheckList(
                    context, note.title, note.items, note.getItems);
              } else {
                childrens =
                    createQuoteList(context, note.title, note.description);
              }
              return AnimationConfiguration.staggeredGrid(
                  position: i,
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                        child: NoteCard(
                      note: note,
                      padding:
                          note.goal != "Daily Life" ? null : EdgeInsets.zero,
                      children: childrens,
                    )),
                  ));
            }),
      ),
    );
  }
}

class _ListTileRow extends StatelessWidget {
  const _ListTileRow({Key? key, required this.isChecked, required this.text})
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

class DateFooter extends StatelessWidget {
  const DateFooter({Key? key, required this.date, required this.footerText})
      : super(
          key: key,
        );
  final String date, footerText;
  final TextStyle style = const TextStyle(color: AppColors.lightGrey);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          date,
          style: style,
        ),
        Text(
          footerText,
          style: style,
        )
      ],
    );
  }
}
