import 'dart:async';

import 'package:cash_swift/home_Page.dart';
import 'package:cash_swift/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:typewritertext/typewritertext.dart';

class splashScreen extends StatefulWidget {
  
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  
  @override
  void initState() {
    // TODO: implement initState

Timer(Duration(milliseconds: 1300), () { checkIfUserLoggedIn();});

  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Colors.black,
        body: Center(
          child: RotatedBox(quarterTurns: 3,
          child: TypeWriterText(text: Text("CashSwift",style: GoogleFonts.raleway(textStyle: const TextStyle(fontSize:100,color: Colors.white)),), duration: Duration(milliseconds: 140),) ),
        ),
    );
  }

  void checkIfUserLoggedIn() {
    print("splash"+GetStorage().read("PHONE_NUMBER"));
    if(GetStorage().read("isLoggedIn")){Get.offAll(home_Page(PHONE_NUMBER: GetStorage().read("PHONE_NUMBER").toString()));}
    else{Get.offAll(const login_Page());}
    
  }
}




