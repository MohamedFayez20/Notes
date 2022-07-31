import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:notes/modules/allNotes.dart';
import 'package:notes/modules/favorite.dart';
import 'package:notes/modules/tasks.dart';
import 'package:notes/modules/trash.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../shared/style/style.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => DefaultTabController(
        initialIndex: 0,
        length: 3,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Trash()),
                  );
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    height: 60,
                    value: 1,
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 18),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Trash'),
                      ],
                    ),
                  ),
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
                  icon: Icon(Icons.favorite_border),
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
              const Favorite(),
              Tasks(),
            ],
          ),
        ),
      ),
    );
  }
}
