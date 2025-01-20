import 'dart:ffi';

import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:notes/modules/notePage.dart';
import 'package:notes/shared/style/style.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class AllNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                AppCubit.get(context).edit = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotePage()),
                );
              },
              backgroundColor: HexColor("#202530"),
              child: const Icon(
                Icons.edit_note_sharp,
                color: Colors.orange,
                size: 35,
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(top: 15, right: 15, left: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Tasks Today',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (cubit.todayTasks.isEmpty) ...[
                              Icon(Icons.info_outline,color: Colors.grey.shade600,),
                              const SizedBox(width: 10,),
                              const Expanded(
                                child:  Text(
                                  'No Tasks Yet',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ] else ...[
                              Expanded(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        today(cubit, index, context),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 10),
                                    itemCount: cubit.todayTasks.length > 3
                                        ? 4
                                        : cubit.todayTasks.length),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                            CircularPercentIndicator(
                              animation: true,
                              center: Text(
                                '% ${cubit.percent.toInt().toString()}',
                                style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              radius: 50,
                              percent: cubit.percent / 100,
                              backgroundColor: Colors.grey.shade800,
                              progressColor: Colors.orange,
                            ),
                          ],
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: TextButton(
                            onPressed: () {
                              DefaultTabController.of(context)?.animateTo(1);
                            },
                            child: const Text(
                              'Tap to see all tasks',
                              style: TextStyle(color: Colors.greenAccent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  searchField(context),
                  const SizedBox(
                    height: 20,
                  ),
                  BuildCondition(
                    builder: (context) => Column(
                      children: [
                        Text(
                          '${cubit.note.length}${cubit.note.length > 1 ? ' notes' : ' note'}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 20),
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
                              cubit.note.length,
                              (index) =>
                                  taskItem(context, cubit.note[index], index)),
                        ),
                      ],
                    ),
                    condition: cubit.note.isNotEmpty,
                    fallback: (context) => fallBack(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
