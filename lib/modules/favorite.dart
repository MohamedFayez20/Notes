import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/shared/style/style.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class Favorite extends StatelessWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        body: BuildCondition(
          builder: (context) => SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '${cubit.favorite.length}${cubit.favorite.length > 1 ? ' notes' : ' note'}',
                  style: const TextStyle(color: Colors.grey, fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                GridView.count(
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.70,
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(
                      cubit.favorite.length,
                      (index) =>
                          taskItem(context, cubit.favorite[index], index)),
                ),
              ],
            ),
          ),
          condition: cubit.favorite.isNotEmpty,
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
