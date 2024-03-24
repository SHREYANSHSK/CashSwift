import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class login_Page extends StatefulWidget {
  const login_Page({super.key});

  @override
  State<login_Page> createState() => _login_PageState();
}

class _login_PageState extends State<login_Page> {
  Color labelTextColor = Colors.black;
  Color bglabelColor = Colors.black12;
  String netIdErrorText = "";
  String passwordErrorText = "";
  TextEditingController netId = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomLeft,end: Alignment.topRight,colors: [
          Colors.black,
          Color.fromRGBO(26, 26, 26, 1),
          Color.fromRGBO(51, 51, 51, 1)
        ])),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(width: double.infinity,
              child: Image.asset(
                "assets/images/Untitled design.png",
               fit: BoxFit.cover,
              ),
            ),
            Center(
              child: SingleChildScrollView(
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
                            controller: netId,
                            onTapOutside: (PointerDownEvent) {
                              labelTextColor = Colors.black;
                              bglabelColor = Colors.black12;

                              setState(() {});
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (netId) {
                              netId.isNotEmpty
                                  ? netIdErrorText = ""
                                  : netIdErrorText = netIdErrorText;
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
                              errorText: netIdErrorText.isEmpty
                                  ? null
                                  : netIdErrorText,
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(46, 50, 60, 1), fontSize: 15),
                              hintText: "enter your phone number",
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(46, 50, 60, 1), fontSize: 15),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(39, 43, 51, 1))),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: password,
                            onTap: () {
                              labelTextColor = Colors.yellowAccent;
                              bglabelColor =
                                  bglabelColor = Colors.black.withOpacity(0.6);
                              setState(() {});
                            },
                            onTapOutside: (PointerDownEvent) {
                              labelTextColor = Colors.black;
                              bglabelColor = bglabelColor = Colors.black12;
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {});
                            },
                            onChanged: (password) {
                              password.isNotEmpty
                                  ? passwordErrorText = ""
                                  : passwordErrorText = passwordErrorText;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                size: 40,
                                color: Colors.white70,
                              ),
                              fillColor: Color.fromRGBO(11, 13, 16, 1),
                              filled: true,
                              labelText: "Password",
                              errorText: passwordErrorText.isEmpty
                                  ? null
                                  : passwordErrorText,
                              labelStyle: const TextStyle(
                                  color: Color.fromRGBO(46, 50, 60, 1), fontSize: 20),
                              hintText: "enter your Password",
                              hintStyle: const TextStyle(
                                  color: Color.fromRGBO(46, 50, 60, 1), fontSize: 15),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 2)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(39, 43, 51, 1))),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Animate(
                            effects: const [
                              FadeEffect(
                                  duration: Duration(milliseconds: 1000),
                                  delay: Duration(milliseconds: 1100)),
                              SlideEffect(
                                  duration: Duration(milliseconds: 1000))
                            ],
                            child: Container(
                              decoration:  BoxDecoration(color: Color.fromRGBO(64, 64, 64, 1),borderRadius: BorderRadius.circular(12)),

                              child: ElevatedButton(
                                onPressed: () {
                                  if (netId.text.isEmpty) {
                                    netIdErrorText = "REQUIRED";
                                    setState(() {});
                                  } else if (password.text.isEmpty) {
                                    passwordErrorText = "REQUIRED";
                                    setState(() {});
                                  } else if (!netId.text.isEmpty) {
                                    Get.snackbar(
                                      "SUCESS",
                                      "Logged-in Successfully",
                                      borderRadius: 12,
                                      isDismissible: true,
                                      dismissDirection:
                                          DismissDirection.startToEnd,
                                      colorText: Colors.black,
                                      backgroundColor: Colors.yellow.shade700,
                                      icon: const Icon(
                                        Icons.check_circle_outline_sharp,
                                        color: Colors.green,
                                        size: 50,
                                      ),
                                      animationDuration:
                                          const Duration(milliseconds: 800),
                                      overlayBlur: 2,
                                      forwardAnimationCurve:
                                          Curves.easeInOutCubicEmphasized,
                                    );
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) => MyHomePage()));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    maximumSize: const Size(200, 50),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12))),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 7.0),
                                  child: Text(
                                    "LOGIN",
                                    style: GoogleFonts.roboto(
                                        fontSize: 35,
                                        color: Colors.white,
                                        letterSpacing: 5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Animate(
                            effects: const [
                              FadeEffect(
                                  duration: Duration(milliseconds: 1000),
                                  delay: Duration(milliseconds: 1100))
                            ],
                            child: Container(
                              decoration: BoxDecoration(color: Color.fromRGBO(64, 64, 64, 1),borderRadius: BorderRadius.circular(12)),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  // MaterialPageRoute(
                                  // builder: (context) => registration_page()));
                                },
                                style: ElevatedButton.styleFrom(
                                    maximumSize: const Size(200, 50),
                                    backgroundColor: Colors.transparent,shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12))),
                                child: Center(
                                  child: Text(
                                    "Sign UP",
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
