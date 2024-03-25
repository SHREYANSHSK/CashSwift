import 'package:cash_swift/firebase_options.dart';
import 'package:cash_swift/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';


void main() async
{ WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

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
      home: login_Page()

    );
  }
}
