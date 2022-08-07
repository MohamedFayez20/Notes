import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:notes/shared/style/style.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class Search extends StatelessWidget {
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: searchController,
                style: const TextStyle(color: Colors.white,fontSize: 20),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    cubit.search(value);
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  filled: true,
                  fillColor: HexColor("#202530"),
                  hintText: "Search",
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white38,
                  ),
                ),
              ),
              BuildCondition(
                builder: (context) => Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.only(top: 20),
                    shrinkWrap: true,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.70,
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(
                        cubit.searchList.length,
                        (index) =>
                            taskItem(context, cubit.searchList[index], index)),
                  ),
                ),
                condition: State is! SearchState,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
