import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/app_colors.dart';
import 'package:notes_app/views/all_view.dart';
import 'package:notes_app/views/curved_box.dart';

class FolderView extends StatelessWidget {
  const FolderView({Key? key, required this.navKey}) : super(key: key);
  final GlobalKey<NavigatorState> navKey;

  @override
  Widget build(BuildContext context) {
    const filters = ["ToDo", "Quote", "Daily Life", "My Targets", "Freelancer"];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          FontAwesomeIcons.plus,
          color: AppColors.white,
        ),
      ),
      body: MasonryGridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemCount: 5,
          itemBuilder: (context, index) => InkWell(
                onTap: () => navKey.currentState!.push(MaterialPageRoute(
                    builder: ((context) => AllView(
                          filter: filters[index],
                        )))),
                child: CurvedBox(children: [
                  Lottie.asset('assets/folder.json', repeat: false),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      index == 0
                          ? Text(
                              'ToDo',
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          : index == 1
                              ? Text(
                                  'Quotes',
                                  style: Theme.of(context).textTheme.titleLarge,
                                )
                              : index == 2
                                  ? Text(
                                      'Daily Life',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    )
                                  : index == 3
                                      ? Text(
                                          'My Targets',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        )
                                      : index == 4
                                          ? Text(
                                              'Freelancer',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            )
                                          : const SizedBox.shrink()
                    ],
                  )
                ]),
              )),
    );
  }
}
