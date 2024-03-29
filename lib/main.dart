
import 'package:cash_swift/firebase_options.dart';
import 'package:cash_swift/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';


void main() async
{ await GetStorage.init();
GetStorage().writeIfNull("isLoggedIn", false);
  WidgetsFlutterBinding.ensureInitialized();
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
        primarySwatch: Colors.teal,
        useMaterial3: false
      ),
      home: splashScreen()

    );
  }
}
