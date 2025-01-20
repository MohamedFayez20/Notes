import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:notes/shared/cubit/cubit.dart';

import 'layout/layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: HexColor("#0E121B"),
                statusBarIconBrightness: Brightness.light
              ),
              backgroundColor: HexColor("#0E121B"),
              centerTitle: true,
              titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
              elevation: 0.0,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            primaryColor: HexColor("#202530"),
            primarySwatch: Colors.grey,
            scaffoldBackgroundColor: HexColor("#0E121B")),
        home: const Layout(),
      ),
    );
  }
}
