import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../shared/style/style.dart';

class Tasks extends StatelessWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            inputDialog(context, false);
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
          condition: AppCubit.get(context).tasks.isNotEmpty,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    deleteDialog(
                        context, AppCubit.get(context).deleteAllFromTasks);
                  },
                  child: const Text(
                    'Empty',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => task(
                        context, AppCubit.get(context).tasks[index], index),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                    itemCount: AppCubit.get(context).tasks.length)
              ],
            ),
          ),
          fallback: (context) => const Center(
            child: Text(
              'No Items',
              style: TextStyle(
                color: Colors.white12,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
