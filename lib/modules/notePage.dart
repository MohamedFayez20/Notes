import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:notes/shared/style/style.dart';

import '../layout/layout.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class NotePage extends StatelessWidget {
  NotePage({Map? note, Key? key}) : super(key: key) {
    nModel = note;
  }
  Map? nModel;
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    var titleController = TextEditingController(
      text: cubit.edit ? nModel!['title'] : '',
    );
    var bodyController =
        TextEditingController(text: cubit.edit ? nModel!['body'] : '');
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (cubit.available) {
          bodyController.text =
              nModel == null ? cubit.text! : nModel!['body'] + cubit.text!;
        }
        if (cubit.recognizedText != null) {
          bodyController.text =
              nModel == null ? cubit.recognizedText! : nModel!['body'] + cubit.recognizedText!;
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Layout()));
              cubit.edit = false;
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (cubit.edit) {
                  cubit.updateData(
                    titleController.text,
                    bodyController.text,
                    nModel!['id'],
                  );
                } else {
                  cubit.insertToDataBase(
                      DateTime.now().toString().split(' ').first,
                      DateFormat.jm().format(DateTime.now()).toString(),
                      bodyController.text,
                      titleController.text);
                }
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Layout()),
                    (route) => false);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.orange, fontSize: 18),
              ),
            ),
            IconButton(
              onPressed: () {
                cubit.getImage();
              },
              icon: Icon(
                Icons.camera_alt_outlined,
                color: Colors.orange,
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: cubit.isListening,
          glowColor: Colors.orangeAccent,
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          child: FloatingActionButton(
            backgroundColor: Colors.white10,
            child: const Icon(
              Icons.mic,
              color: Colors.orange,
            ),
            onPressed: () {
              cubit.edit = false;
              cubit.startSpeech();
            },
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleItem(context, titleController),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: TextFormField(
                controller: bodyController,
                maxLines: null,
                minLines: null,
                expands: true,
                autofocus: true,
                cursorColor: Colors.white,
                style: const TextStyle(
                    color: Colors.white, fontSize: 19, height: 1.8),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor("#202530"),
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
