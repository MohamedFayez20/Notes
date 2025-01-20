import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  late Database dataBase;
  void createDataBase() {
    openDatabase('notes.db', version: 1, onCreate: (dataBase, version) {
      print('database created');
      dataBase
          .execute(
              'CREATE TABLE notes (id INTEGER PRIMARY KEY ,date TEXT,time TEXT ,body TEXT,title TEXT,status TEXT)')
          .then((value) {
        print("table notes created");
      }).catchError((error) {
        print(error);
      });
      dataBase
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY ,body TEXT,status TEXT,date TEXT)')
          .then((value) {
        print("table tasks created");
      }).catchError((error) {
        print(error);
      });
    }, onOpen: (dataBase) {
      getDataFromDataBase(dataBase);
      getDataFromTasks(dataBase, selectedDay.toString().split(' ').first);
      print("dataBase opened");
    }).then((value) {
      dataBase = value;
      emit(CreateDataBaseSuccessState());
    });
  }

  void insertToDataBase(
      String date, String time, String body, String title) async {
    await dataBase.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO notes (date,time,body,title,status) VALUES("$date","$time","$body","$title","new")')
          .then((value) {
        print("inserted successfully");
        getDataFromDataBase(dataBase);
        emit(InsertToDataBaseSuccessState());
      }).catchError((error) {
        print(error);
        emit(InsertToDataBaseErrorState());
      });
    });
  }

  List<Map> note = [];
  List<Map> trash = [];
  List<Map> favorite = [];
  void getDataFromDataBase(dataBase) {
    note = [];
    trash = [];
    favorite = [];

    dataBase.rawQuery('SELECT * FROM notes').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          note.add(element);
        } else if (element['status'] == 'trash') {
          trash.add(element);
        } else if (element['status'] == 'favorite') {
          favorite.add(element);
          note.add(element);
        }
      });
      emit(GetDataFromDataBaseState());
    });
  }

  bool edit = false;
  int? ind;
  void getIndex(int x) {
    ind = x;
  }

  void updateData(String title, String body, int id) {
    dataBase.rawUpdate('UPDATE notes SET title=?,body=? WHERE id=$id',
        [title, body]).then((value) {
      getDataFromDataBase(dataBase);
      emit(AppUpdateDataState());
    });
  }

  void moveTo(String status, int i) {
    dataBase.rawUpdate('UPDATE notes SET status=? WHERE id=$i', [status]).then(
        (value) {
      getDataFromDataBase(dataBase);
      emit(AppUpdateTrashDataState());
    });
  }

  void deleteFromDataBase(int i) async {
    await dataBase.rawDelete('DELETE FROM notes WHERE id = $i').then((value) {
      getDataFromDataBase(dataBase);
      emit(DeleteFromDataBaseState());
    });
  }

  void deleteAllFromDataBase() async {
    await dataBase.rawDelete(
        'DELETE FROM notes WHERE status =?', ['trash']).then((value) {
      getDataFromDataBase(dataBase);
      emit(DeleteAllFromDataBaseState());
    });
  }

  List<Map> searchList = [];
  void search(String t) {
    emit(SearchLoadingState());
    searchList = [];
    dataBase.rawQuery('SELECT * FROM notes').then((value) {
      searchList = [];
      value.forEach((element) {
        if (element['title']
                .toString()
                .toLowerCase()
                .contains(t.toLowerCase()) &&
            element['status'] != 'trash') {
          searchList.add(element);
          print(element);
        }
      });
      emit(SearchState());
    });
  }

  String? text;
  stt.SpeechToText speech = stt.SpeechToText();
  bool available = false;
  bool isListening = false;
  Future<void> startSpeech() async {
    available = await speech.initialize(
      debugLogging: true,
      onStatus: (s) {},
      onError: (e) {},
    );
    if (available) {
      speech.listen(onResult: (r) {
        text = speech.lastRecognizedWords;
        print(text);
        isListening = speech.isListening;
        emit(StartRecordingSuccessState());
      });
    }
  }

  void insertToTasks(String body) async {
    await dataBase.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks (body,status,date) VALUES("$body","new","${selectedDay.toString().split(' ').first}")')
          .then((value) {
        print("inserted successfully");
        getDataFromTasks(dataBase, selectedDay.toString().split(' ').first);
        emit(InsertToTasksSuccessState());
      }).catchError((error) {
        print(error);
        emit(InsertToTasksErrorState());
      });
    });
  }

  List<Map> tasks = [];
  List<Map> todayTasks = [];
  int doneTaNumber = 0;
  double taPercent = 0;
  void getDataFromTasks(dataBase, date) {
    tasks = [];
    doneTaNumber = 0;
    dataBase.rawQuery('SELECT * FROM tasks WHERE date="$date"').then((value) {
      value.forEach((element) {
        tasks.add(element);
        if (element['status'] == 'done') {
          doneTaNumber++;
        }
      });
      taPercent = (doneTaNumber / tasks.length) * 100;

      getTodayTasks();
      emit(GetDataFromTasksState());
    });
  }

  int doneNumber = 0;
  double percent = 0;
  void getTodayTasks() {
    doneNumber = 0;
    if (tasks.isEmpty) {
      todayTasks = [];
      percent = 0;
    } else {
      for (int x = 0; x < tasks.length; x++) {
        if (tasks[x]['date'] == DateTime.now().toString().split(' ').first) {
          if (x == 0) {
            todayTasks = [];
          }
          todayTasks.add(tasks[x]);
          if (todayTasks[x]['status'] == 'done') {
            doneNumber++;
          }
          if (x == tasks.length - 1) {
            percent = (doneNumber / todayTasks.length) * 100;
          }
        }
      }
    }

    print(todayTasks.length);
    emit(GetTodayTasksState());
  }

  void updateTasks(String body, int id) {
    dataBase.rawUpdate('UPDATE tasks SET body=? WHERE id=$id', [body]).then(
        (value) {
      getDataFromTasks(dataBase, selectedDay.toString().split(' ').first);
      emit(AppUpdateTasksState());
    });
  }

  bool isExpanded = false;
  Icon icon = const Icon(
    Icons.arrow_back_ios,
    color: Colors.orange,
    size: 20,
  );
  TextOverflow overflow = TextOverflow.ellipsis;
  void expand() {
    isExpanded = !isExpanded;
    if (isExpanded) {
      icon = const Icon(
        Icons.expand_more_sharp,
        color: Colors.orange,
        size: 30,
      );
      overflow = TextOverflow.visible;
    } else {
      icon = const Icon(
        Icons.arrow_back_ios,
        color: Colors.orange,
        size: 20,
      );
      overflow = TextOverflow.ellipsis;
    }
    emit(ExpandState());
  }

  void done(String status, int i) {
    dataBase.rawUpdate('UPDATE tasks SET status=? WHERE id=$i', [status]).then(
        (value) {
      getDataFromTasks(dataBase, selectedDay.toString().split(' ').first);
      emit(AppUpdateDoneState());
    });
  }

  void deleteFromTasks(int i) async {
    await dataBase.rawDelete('DELETE FROM tasks WHERE id = $i').then((value) {
      getDataFromTasks(dataBase, selectedDay.toString().split(' ').first);
      emit(DeleteFromTasksState());
    });
  }

  void deleteAllFromTasks() async {
    await dataBase
        .rawDelete(
            'DELETE FROM tasks WHERE date="${selectedDay.toString().split(' ').first}"')
        .then((value) {
      getDataFromTasks(dataBase,  selectedDay.toString().split(' ').first);
      emit(DeleteAllFromTasksState());
    });
  }

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  void selectDay(select, focus) {
    selectedDay = select;
    focusedDay = focus;
    getDataFromTasks(dataBase, select.toString().split(' ').first);
    emit(SelectDayState());
  }
  File? file;
  var picker =ImagePicker();
  Future getImage() async {
    final pickedImage=await picker.pickImage(source: ImageSource.gallery);
    if(pickedImage!=null)
    {
      file=File(pickedImage!.path);
      processImage();
      emit(GetImageSuccessState());
    }else
    {
      print("No image selected");
      emit(GetImageErrorState());
    }
  }
  TextRecognizer textRecognizer=TextRecognizer(script: TextRecognitionScript.latin);
  String? recognizedText;
  Future processImage() async {
    final inputImage=InputImage.fromFile(file!);
    final RecognizedText rText=await textRecognizer.processImage(inputImage);
    recognizedText=rText.text;
    print(recognizedText);
  }
}
