import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/app_colors.dart';
import 'package:notes_app/views/all_view.dart';
import 'package:notes_app/views/folder_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isSearch = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              actions: _isSearch
                  ? null
                  : [
                      TextButton(
                        child: Text(
                          'Edit',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: AppColors.lightTextColor),
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isSearch = true;
                          });
                        },
                        icon: const Icon(CupertinoIcons.search),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.ellipsis_circle),
                      )
                    ],
              leadingWidth: 0,
              leading: const SizedBox.shrink(),
              title: _isSearch
                  ? SizedBox(
                      // height: 40,
                      child: Row(
                        children: [
                          const Icon(Icons.search_outlined),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: TextField(
                              autofocus: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.grey)),
                                contentPadding: EdgeInsets.all(8.0),
                              ),
                              onSubmitted: (value) {
                                setState(() {
                                  _isSearch = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text('Notes'),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'All',
                  ),
                  Tab(
                    text: 'Folder',
                  ),
                ],
              )),
          body: const TabBarView(
            children: [AllView(), FolderView()],
          ),
        ));
  }
}
