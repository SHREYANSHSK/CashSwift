import 'dart:async';

import 'package:CashSwift/navBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:typewritertext/typewritertext.dart';

import 'login_page.dart';

class splashScreen extends StatefulWidget {
  
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  
  @override
  void initState() {

Timer(Duration(milliseconds: 2000), () { checkIfUserLoggedIn();});

  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Colors.black,
        body: Center(
          child: RotatedBox(quarterTurns: 3,
          child: TypeWriterText(text: Text("CashSwift",style: GoogleFonts.raleway(textStyle: const TextStyle(fontSize:100,color: Colors.white)),), duration: Duration(milliseconds: 100),) ),
        ),
    );
  }

  void checkIfUserLoggedIn() {
    if(GetStorage().read("isLoggedIn")){Get.offAll(navBar());}
    else{Get.offAll(const login_Page());}
    
  }
}




