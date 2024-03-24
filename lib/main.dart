import 'package:cash_swift/home_Page.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Money Transfer',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: false
      ),
      home: home_Page(),

    );
  }
}
