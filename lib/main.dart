import 'package:cash_swift/home_Page.dart';
import 'package:cash_swift/login_page.dart';
import 'package:cash_swift/signUp_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Money Transfer',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: false
      ),
      home: signUp_Page(),

    );
  }
}
