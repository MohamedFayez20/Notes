import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/shared/style/style.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class Trash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Trash'),
          actions: [
            TextButton(
              onPressed: () {
                deleteDialog(context, cubit.deleteAllFromDataBase);
              },
              child: const Text(
                'Empty',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
        body: BuildCondition(
          builder: (context) => Column(
            children: [
              Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.all(20.0),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => trash(context, index),
                    separatorBuilder: (context, index) => Container(
                          height: .9,
                          color: Colors.white12,
                          margin: const EdgeInsets.all(20),
                        ),
                    itemCount: cubit.trash.length),
              ),
            ],
          ),
          condition: cubit.trash.isNotEmpty,
          fallback: (context) => fallBack(),
        ),
      ),
    );
  }
}
