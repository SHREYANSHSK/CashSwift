
import 'dart:developer';

import 'package:CashSwift/navBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import 'UiHelper.dart';

class codeVerification_Page extends StatefulWidget {
  final String verificationId;
   final String PHONE_NUMBER;

  codeVerification_Page({super.key, required this.verificationId,required this.PHONE_NUMBER});

  @override
  State<codeVerification_Page> createState() => _codeVerification_PageState();
}

class _codeVerification_PageState extends State<codeVerification_Page> {


  String ErrorText = "";
  var isErrorFocus=false;

  final pinController = TextEditingController();



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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Verify OTP",
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Pinput(
                controller: pinController,
                onChanged: (val){val.isNotEmpty?isErrorFocus=false:isErrorFocus=true; setState(() {
                });},
                length: 6,
                keyboardType: TextInputType.number,
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
                errorText:   ErrorText.isEmpty ? null : ErrorText,
                errorTextStyle: const TextStyle(color: Colors.red),
                errorPinTheme: PinTheme(
                    textStyle: const TextStyle(
                        fontSize: 30,
                        color: Colors.red,
                        fontWeight: FontWeight.w600),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red),
                        color: Colors.black26)),
                autofocus: true,
                forceErrorState: isErrorFocus,
                defaultPinTheme: PinTheme(
                    textStyle: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white54),
                        color: Colors.black26)),
                focusedPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.white),
                    )),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12)),
              child: ElevatedButton(
                onPressed: () async {
                  if (pinController.text.toString() == "") {
                    setState(() {ErrorText = "REQUIRED";isErrorFocus=true;});
                  } else {
                    try {
                      PhoneAuthCredential credential =
                          await PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: pinController.text.toString());
                      FirebaseAuth.instance
                          .signInWithCredential(credential)
                          .then((value) {
                        UiHelper().snackBar(
                            titleMsg: "Success",
                            subTitleMsg: "Logged in Successfully",
                            bgColor: Color.fromRGBO(17, 130, 20, 0.8),
                            iconData: Icons.verified_outlined);
                        GetStorage().write("PHONE_NUMBER", widget.PHONE_NUMBER.toString());
                        GetStorage().write("isLoggedIn", true);
                        Get.to(navBar());
                      }).catchError((error, stackTrace) {
                        log(error.toString());
                        UiHelper().snackBar(
                            titleMsg: "Login Failed",
                            subTitleMsg: error.toString().substring(42),
                            bgColor:  Color.fromRGBO(140, 13, 1, 0.8),
                            iconData: Icons.error_outline_outlined);

                      });
                    } on FirebaseException catch (ex) {
                        UiHelper().snackBar(
                            titleMsg: 'Failed',
                            subTitleMsg: 'Failed to login',
                            bgColor:  Color.fromRGBO(140, 13, 1, 0.8),
                            iconData: Icons.cancel_outlined);
                      log(ex.toString());
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    maximumSize: const Size(200, 50),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Center(
                    child: Text(
                  "Proceed",
                  style: GoogleFonts.roboto(
                      fontSize: 35,
                      color: Colors.black,
                      letterSpacing: 5,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
