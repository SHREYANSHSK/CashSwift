import 'dart:developer';
import 'dart:io';

import 'package:cash_swift/UiHelper.dart';
import 'package:cash_swift/signUp_Page.dart';
import 'package:cash_swift/verify_Code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class login_Page extends StatefulWidget {
  const login_Page({super.key});

  @override
  State<login_Page> createState() => _login_PageState();
}

class _login_PageState extends State<login_Page> {
  Color labelTextColor = Colors.black;
  Color bglabelColor = Colors.black12;
  String PhnoErrorText = "";
  TextEditingController Phno = TextEditingController();
  File? pickedImage;

  Future showAlert() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Pick Image from",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Camera",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      ImagePick(ImageSource.camera);
                      Navigator.pop(context);
                    }),
                ListTile(
                    leading: const Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    title: const Text("Gallery",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      ImagePick(ImageSource.gallery);
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }

  ImagePick(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final tempImage = File(image.path);
      setState(() {
        pickedImage = tempImage;
      });
    } catch (ex) {
      log(ex.toString());
    }
  }


  Future checkUser()async {
    DocumentSnapshot snapshot =await FirebaseFirestore.instance.collection("users").doc(Phno.text.toString()).get();
    if(snapshot.exists){
      return true;
    }
    else {
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
              Colors.black,
              Color.fromRGBO(26, 26, 26, 1),
              Color.fromRGBO(51, 51, 51, 1)
            ])),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 130,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/images/Untitled design.png",
                  fit: BoxFit.cover,
                  height: 100,
                  width: 300,
                ),
              ),
              InkWell(
                  onTap: () {
                    showAlert();
                  },
                  child: pickedImage == null
                      ? const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ))
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(pickedImage!),
                        )),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            onTap: () {
                              labelTextColor = Colors.yellowAccent;
                              bglabelColor = Colors.black.withOpacity(0.6);
                              setState(() {});
                            },
                            controller: Phno,
                            keyboardType: TextInputType.number,
                            onTapOutside: (PointerDownEvent) {
                              labelTextColor = Colors.black;
                              bglabelColor = Colors.black12;

                              setState(() {});
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (phno) {
                              phno.isNotEmpty
                                  ? PhnoErrorText = ""
                                  : PhnoErrorText = PhnoErrorText;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.account_circle_outlined,
                                size: 40,
                                color: Colors.white70,
                              ),
                              fillColor: Color.fromRGBO(11, 13, 16, 1),
                              filled: true,
                              labelText: "phone number",
                              errorText:
                                  PhnoErrorText.isEmpty ? null : PhnoErrorText,
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(46, 50, 60, 1),
                                  fontSize: 15),
                              hintText: "enter your phone number",
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(46, 50, 60, 1),
                                  fontSize: 15),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(39, 43, 51, 1))),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),

                          Animate(
                            effects: const [
                              FadeEffect(
                                  duration: Duration(milliseconds: 1000),
                                  delay: Duration(milliseconds: 1100))
                            ],
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12)),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (Phno.text.toString() == "") {
                                    PhnoErrorText = "REQUIRED";
                                    setState(() {});
                                  } else {
                                    checkUser().then((value) async{
                                      if(value==true){
                                        await FirebaseAuth.instance.verifyPhoneNumber(
                                          phoneNumber: '+91${Phno.text.toString()}',
                                          verificationCompleted:
                                              (PhoneAuthCredential
                                          credential) async {
                                            await FirebaseAuth.instance
                                                .signInWithCredential(credential);
                                          },
                                          verificationFailed:
                                              (FirebaseAuthException e) {
                                            UiHelper().snackBar(
                                                titleMsg: "ERROR!",
                                                subTitleMsg: e.message.toString(),
                                                bgColor: Colors.red,
                                                iconData:
                                                Icons.error_outline_outlined);
                                          },
                                          codeSent: (String verificationId,
                                              int? resendToken) {
                                            Get.to(codeVerification_Page(verificationId: verificationId,PHONE_NUMBER: Phno.text.toString(),));
                                          },
                                          codeAutoRetrievalTimeout:
                                              (String verificationId) {},
                                        );
                                      }
                                      else{
                                        await FirebaseAuth.instance.verifyPhoneNumber(
                                          phoneNumber: '+91${Phno.text.toString()}',
                                          verificationCompleted:
                                              (PhoneAuthCredential
                                          credential) async {
                                            await FirebaseAuth.instance
                                                .signInWithCredential(credential);
                                          },
                                          verificationFailed:
                                              (FirebaseAuthException e) {
                                            UiHelper().snackBar(
                                                titleMsg: "ERROR!",
                                                subTitleMsg: e.message.toString(),
                                                bgColor: Colors.red,
                                                iconData:
                                                Icons.error_outline_outlined);
                                          },
                                          codeSent: (String verificationId,
                                              int? resendToken) {
                                            Get.to(signUp_Page(PHONE_NUMBER: Phno.text.toString(),));
                                          },
                                          codeAutoRetrievalTimeout:
                                              (String verificationId) {},
                                        );
                                      }
                                    });

                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    maximumSize: const Size(200, 50),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: Center(
                                  child: Text(
                                    "Verify",
                                    style: GoogleFonts.roboto(
                                        fontSize: 32,
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          // Animate(
                          //   effects: const [
                          //     FadeEffect(
                          //         duration: Duration(milliseconds: 1000),
                          //         delay: Duration(milliseconds: 1100))
                          //   ],
                          //   child: Container(
                          //     decoration: BoxDecoration(color: Color.fromRGBO(64, 64, 64, 1),borderRadius: BorderRadius.circular(12)),
                          //     child: ElevatedButton(
                          //       onPressed: () {
                          //         Navigator.push(
                          //             context,
                          //         MaterialPageRoute(
                          //         builder: (context) => signUp_Page()));
                          //       },
                          //       style: ElevatedButton.styleFrom(
                          //           maximumSize: const Size(200, 50),
                          //           backgroundColor: Colors.transparent,shadowColor: Colors.transparent,
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(12))),
                          //       child: Center(
                          //         child: Text(
                          //           "SignUp",
                          //           style: GoogleFonts.roboto(
                          //               fontSize: 32,
                          //               color: Colors.black,
                          //               letterSpacing: 1,
                          //               fontWeight: FontWeight.bold),
                          //         ),
                          //
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
