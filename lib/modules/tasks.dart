import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../shared/style/style.dart';

class Tasks extends StatelessWidget {
  PageController controller = PageController();
  TextStyle style =
      TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold);
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (AppCubit.get(context).tasks.isNotEmpty)
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
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: HexColor("#202530"),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 5,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: TableCalendar(
                  calendarFormat: CalendarFormat.week,
                  headerStyle: const HeaderStyle(
                      titleTextStyle: TextStyle(color: Colors.orange),
                      formatButtonVisible: false,
                      titleCentered: true),
                  focusedDay: AppCubit.get(context).focusedDay,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                    AppCubit.get(context).selectDay(selectDay, focusDay);
                  },
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(AppCubit.get(context).selectedDay, date);
                  },
                  daysOfWeekStyle:
                      DaysOfWeekStyle(weekdayStyle: style, weekendStyle: style),
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    defaultTextStyle: style,
                    weekendTextStyle: style,
                    outsideTextStyle: style,
                    selectedDecoration: BoxDecoration(
                        color: Colors.orange.shade800, shape: BoxShape.circle),
                  ),
                ),
              ),
              if(AppCubit.get(context).tasks.isNotEmpty)
                LinearPercentIndicator(
                progressColor: Colors.teal,
                barRadius: const Radius.circular(20),
                percent: AppCubit.get(context).taPercent/100,
                animation: true,
                backgroundColor: Colors.grey.shade800,
                leading: Text(
                  '% ${AppCubit.get(context).taPercent.toInt()}',
                  style: const TextStyle(color: Colors.greenAccent),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BuildCondition(
                condition: AppCubit.get(context).tasks.isNotEmpty,
                builder: (context) => ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => task(
                        context, AppCubit.get(context).tasks[index], index),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                    itemCount: AppCubit.get(context).tasks.length),
                fallback: (context) => fallBack(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
