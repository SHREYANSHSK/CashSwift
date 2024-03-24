import 'dart:async';
import 'dart:developer';
import 'dart:io';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class signUp_Page extends StatefulWidget {
  const signUp_Page({super.key});

  @override
  State<signUp_Page> createState() => _signUp_PageState();
}

class _signUp_PageState extends State<signUp_Page> {
  Color labelTextColor = Colors.black;
  TextEditingController phNo = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String phNoErrorText = "";
  String netIdErrorText = "";
  String passwordErrorText = "";
  String confirmPasswordErrorText = "";
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
                  onTap:(){ ImagePick(ImageSource.camera);
                  Navigator.pop(context);}
                ),
                ListTile(
                  leading: const Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  title: const Text("Gallery",
                      style: TextStyle(color: Colors.white)),
                  onTap: (){ImagePick(ImageSource.gallery);
                  Navigator.pop(context);
                  }
                )
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            showAlert();
                          },
                          child: pickedImage == null
                              ? const CircleAvatar(
                                  radius: 80,backgroundColor: Colors.black54,
                                  child: Icon(
                                    Icons.person,
                                    size: 80,color: Colors.white,
                                  ))
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      FileImage(pickedImage!),
                                )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: name,
                        onTapOutside: (PointerDownEvent) {
                          labelTextColor = Colors.black;
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {});
                        },
                        onTap: () {
                          labelTextColor = Colors.yellowAccent;
                          setState(() {});
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                            size: 40,
                            color: Colors.white70,
                          ),
                          fillColor: Colors.black12,
                          filled: true,
                          labelText: "Name",
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(46, 50, 60, 1),
                              fontSize: 20),
                          hintText: "enter your name",
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(46, 50, 60, 1),
                              fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(39, 43, 51, 1))),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your name.";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: phNo,
                        keyboardType: TextInputType.number,
                        onTapOutside: (PointerDownEvent) {
                          labelTextColor = Colors.black;
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {});
                        },
                        onTap: () {
                          labelTextColor = Colors.yellowAccent;
                          setState(() {});
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                            size: 40,
                            color: Colors.white70,
                          ),
                          fillColor: Colors.black12,
                          filled: true,
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(46, 50, 60, 1),
                              fontSize: 20),
                          hintText: "enter your phone number",
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(46, 50, 60, 1),
                              fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(39, 43, 51, 1))),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Phone No.";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        onTapOutside: (PointerDownEvent) {
                          labelTextColor = Colors.black;
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {});
                        },
                        onTap: () {
                          labelTextColor = Colors.yellowAccent;
                          setState(() {});
                        },
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter The Password";
                          }
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: 40,
                            color: Colors.white70,
                          ),
                          fillColor: Colors.black12,
                          filled: true,
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(46, 50, 60, 1),
                              fontSize: 20),
                          hintText: "Password",
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(46, 50, 60, 1),
                              fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(39, 43, 51, 1))),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        onTapOutside: (PointerDownEvent) {
                          labelTextColor = Colors.black;
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {});
                        },
                        onTap: () {
                          labelTextColor = Colors.yellowAccent;
                          setState(() {});
                        },
                        controller: confirmPassword,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Confirm Password";
                          }
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: 40,
                            color: Colors.white70,
                          ),
                          fillColor: Colors.black12,
                          filled: true,
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(46, 50, 60, 1),
                              fontSize: 20),
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(46, 50, 60, 1),
                              fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(39, 43, 51, 1))),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Get.snackbar(
                              "SUCCESS",
                              "Registered Successfully",
                              borderRadius: 12,
                              isDismissible: true,
                              margin: const EdgeInsets.all(20),
                              dismissDirection: DismissDirection.startToEnd,
                              colorText: Colors.black,
                              backgroundColor: Colors.yellow.shade700,
                              icon: const Icon(
                                Icons.check_circle_outline_sharp,
                                color: Colors.green,
                                size: 50,
                              ),
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              overlayBlur: 2,
                              forwardAnimationCurve:
                                  Curves.easeInOutCubicEmphasized,
                            );
                            // Timer(const Duration(milliseconds: 2000), () {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => login_page()));
                            // });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            maximumSize: const Size(200, 50),
                            backgroundColor:
                                const Color.fromRGBO(64, 64, 64, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text(
                            "REGISTER",
                            style: GoogleFonts.roboto(
                                fontSize: 32,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
