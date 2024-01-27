import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do/news_app.dart';

import 'constant/bloc_observer.dart';

void main()
{
  BlocOverrides.runZoned(
        () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomeLayout(),
      home: ToDOApp(),
    );
  }
}


