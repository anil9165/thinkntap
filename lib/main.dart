import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinktap/views/splash/splash_screen.dart';
import 'package:thinktap/views/task/task_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'thinkNtap',
      debugShowCheckedModeBanner:false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
