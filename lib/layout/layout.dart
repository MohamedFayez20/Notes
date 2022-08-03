import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:notes/modules/allNotes.dart';
import 'package:notes/modules/favorite.dart';
import 'package:notes/modules/tasks.dart';
import 'package:notes/modules/trash.dart';
import 'package:notes/shared/style/style.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 20,
            actions: [
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                position: PopupMenuPosition.under,
                color: HexColor('#303030'),
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Trash(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Favorite(),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                      value: 1,
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 18),
                      child: menu('Trash', Icons.delete_outline_outlined)),
                  PopupMenuItem(
                      value: 2,
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 18),
                      child: menu('Favorites', Icons.favorite_border)),
                ],
              ),
            ],
            centerTitle: true,
            title: const Text('Notes'),
            automaticallyImplyLeading: false,
            bottom: TabBar(
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              padding: const EdgeInsets.only(left: 30, right: 30),
              indicatorColor: Colors.orange,
              splashBorderRadius: BorderRadius.circular(10),
              tabs: const <Widget>[
                Tab(
                  icon: Icon(Icons.note_alt_outlined),
                ),
                Tab(
                  icon: Icon(Icons.task_alt),
                )
              ],
            ),
          ),
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              AllNotes(),
              Tasks(),
            ],
          ),
        ),
      ),
    );
  }
}
