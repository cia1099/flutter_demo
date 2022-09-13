import 'package:flutter/material.dart';
import 'package:notes_app/app_colors.dart';
import 'package:notes_app/views/home_view.dart';
import 'package:notes_app/views/note_widget.dart';

class LandingView extends StatelessWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            flex: 5,
            child: NoteWidget(),
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            'Daily Notes',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColors.white),
          ),
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56),
            child: Text(
              'Take notes, reminders, set targets, collect resources and secure privacy',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppColors.white),
            ),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          ElevatedButton(
            onPressed: () {
              //ref. https://stackoverflow.com/questions/67812878/navigation-within-tab-view-body-flutter
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeView(
                  navKey: GlobalKey<NavigatorState>(),
                ),
              ));
            },
            child: Text(
              'Get started',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Expanded(
            flex: 3,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
