import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:notes/modules/notePage.dart';
import 'package:notes/shared/style/style.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class AllNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotePage()),
                );
              },
              elevation: 20,
              backgroundColor: HexColor("#202530"),
              child: const Icon(
                Icons.edit_note_sharp,
                color: Colors.orange,
                size: 35,
              ),
            ),
            body: BuildCondition(
              builder: (context) => SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    searchField(context),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${AppCubit.get(context).note.length}${AppCubit.get(context).note.length > 1 ? ' notes' : ' note'}',
                      style: const TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                    GridView.count(
                      padding: const EdgeInsets.only(top: 20),
                      shrinkWrap: true,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.70,
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(
                          AppCubit.get(context).note.length,
                          (index) => taskItem(context,
                              AppCubit.get(context).note[index], index)),
                    ),
                  ],
                ),
              ),
              condition: AppCubit.get(context).note.isNotEmpty,
              fallback: (context) => fallBack(),
            ),
          );
        });
  }
}
