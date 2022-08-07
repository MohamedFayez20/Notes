import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:notes/modules/notePage.dart';
import '../../layout/layout.dart';
import '../../modules/search.dart';
import '../cubit/cubit.dart';

Widget taskItem(context, Map model, index) => Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  showAlertDialog(context, 'Move one note to trash',
                      'Move to trash', 'trash', model['id']);
                },
                splashColor: Colors.transparent,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              IconButton(
                onPressed: () {
                  if (model['status'] == 'favorite') {
                    showAlertDialog(context, 'remove from favorite',
                        'Move to all notes', 'new', model['id']);
                  } else {
                    showAlertDialog(context, 'Move one note to favorite',
                        'Move to favorite', 'favorite', model['id']);
                  }
                },
                splashColor: Colors.transparent,
                icon: Icon(
                  model['status'] == 'favorite'
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotePage(note: model)));

                AppCubit.get(context).edit = true;

                AppCubit.get(context).getIndex(index);
              },
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: HexColor("#202530"),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    layText(model, 'title', 18, Colors.white, 1),
                    const SizedBox(
                      height: 20,
                    ),
                    layText(model, 'body', 16, Colors.grey, 5),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white10),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          layText(model, 'time', 12, Colors.grey.shade600, 1),
                          const Spacer(),
                          layText(model, 'date', 12, Colors.grey.shade600, 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
Widget titleItem(context, controller) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        style: const TextStyle(color: Colors.white, fontSize: 28),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 28),
          hintText: 'Title',
        ),
      ),
    );
Widget layText(model, String t, double s, Color c, int n) => Text(
      model[t],
      maxLines: n,
      style: TextStyle(
        color: c,
        fontSize: s,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
        height: 1.5,
      ),
    );
showAlertDialog(
    BuildContext context, String content, String text, String dest, int id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
          content,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.orange),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              text,
              style: const TextStyle(color: Colors.orange),
            ),
            onPressed: () {
              AppCubit.get(context).moveTo(dest, id);
              Navigator.pop(context);
            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
        backgroundColor: Colors.white10,
      );
    },
  );
}

Widget trash(context, index) => Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        AppCubit.get(context)
            .deleteFromDataBase(AppCubit.get(context).trash[index]['id']);
      },
      key: Key(AppCubit.get(context).trash[index]['id'].toString()),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white10),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, right: 15, left: 15),
                decoration: BoxDecoration(
                    color: HexColor("#202530"),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 90,
                          child: Text(
                            AppCubit.get(context).trash[index]['title'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          AppCubit.get(context).trash[index]['date'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppCubit.get(context).trash[index]['time'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Drag to delete',
                          style: TextStyle(color: Colors.white38),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white38,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showAlertDialog(context, 'Restore one note', 'Restore', 'new',
                    AppCubit.get(context).trash[index]['id']);
              },
              icon: const Icon(
                Icons.replay_sharp,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
Widget searchField(context) => TextFormField(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Search(),
          ),
        );
        AppCubit.get(context).searchList = [];
      },
      readOnly: true,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: HexColor("#202530"),
        hintText: "Search",
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white38,
        ),
      ),
    );
Widget task(context, model, index) => Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              AppCubit.get(context).getIndex(index);

              if (model['status'] == 'done') {
                AppCubit.get(context).done('new', model['id']);
              } else {
                AppCubit.get(context).done('done', model['id']);
              }
            },
            icon: model['status'] == 'done'
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.orange,
                  )
                : const Icon(
                    Icons.radio_button_off_outlined,
                    color: Colors.orange,
                  ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                AppCubit.get(context).getIndex(index);

                inputDialog(context, true);
              },
              child: Text(
                model['body'],
                style: TextStyle(
                  color: model['status'] == 'done' ? Colors.grey : Colors.white,
                  fontSize: 18,
                  overflow: AppCubit.get(context).ind == index
                      ? AppCubit.get(context).overflow
                      : TextOverflow.ellipsis,
                  decoration: model['status'] == 'done'
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).getIndex(index);

              AppCubit.get(context).expand();
            },
            icon: AppCubit.get(context).ind == index
                ? AppCubit.get(context).icon
                : const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.orange,
                  ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).deleteFromTasks(model['id']);
            },
            icon: const Icon(
              Icons.delete_outline_outlined,
              size: 20,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
var formKey = GlobalKey<FormState>();
inputDialog(BuildContext context, bool isEdit) {
  var taskController = TextEditingController(
      text: isEdit
          ? AppCubit.get(context).tasks[AppCubit.get(context).ind!]['body']
          : '');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Task',
          style: TextStyle(color: Colors.greenAccent),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: taskController,
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Must not be empty';
              }
            },
            decoration: const InputDecoration(
              hintText: 'Type task...',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.orange),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.orange),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (isEdit) {
                  AppCubit.get(context).updateTasks(
                      taskController.text,
                      AppCubit.get(context).tasks[AppCubit.get(context).ind!]
                          ['id']);
                } else {
                  AppCubit.get(context).insertToTasks(taskController.text);
                }
                taskController.clear();
                Navigator.pop(context);
              }
            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
        backgroundColor: HexColor("#202530"),
      );
    },
  );
}

deleteDialog(BuildContext context, Function method) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text(
          'Delete all items permanently',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            child: const Text(
              "No",
              style: TextStyle(color: Colors.orange),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            onPressed: () {
              method();
              Navigator.pop(context);
            },
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
        backgroundColor: Colors.white10,
      );
    },
  );
}

Widget fallBack() => Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.menu,
            size: 50,
            color: Colors.white12,
          ),
          Text(
            'No Items',
            style: TextStyle(
              color: Colors.white12,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
Widget menu(String text, IconData icon) => Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(text),
      ],
    );
Widget today(cubit, index, context) => Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          cubit.todayTasks[index]['status'] == 'done'
              ? Icons.check_circle
              : Icons.circle_outlined,
          color: Colors.grey.shade600,
          size: 15,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            cubit.todayTasks[index]['body'],
            style: TextStyle(
              color: Colors.grey.shade600,
              overflow: TextOverflow.ellipsis,
              decoration:
                  AppCubit.get(context).todayTasks[index]['status'] == 'done'
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
