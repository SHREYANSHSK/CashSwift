
import 'package:CashSwift/pay_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';


TextEditingController DialogBoxValue = TextEditingController();
TextEditingController addBalanceValue = TextEditingController();

class UiHelper {
  SnackbarController snackBar({
    required String titleMsg,
    required String subTitleMsg,
    Color? bgColor,
    IconData? iconData,
  }) {
    return Get.snackbar(
      titleMsg,
      subTitleMsg,
      borderRadius: 12,
      isDismissible: true,
      dismissDirection: DismissDirection.startToEnd,
      colorText: Colors.black,
      backgroundColor: bgColor,
      icon: iconData != null ? Icon(iconData) : null,
      animationDuration: const Duration(milliseconds: 500),
      overlayBlur: 2,
      forwardAnimationCurve: Curves.easeInOutCubicEmphasized,
    );
  }


  showAddBalanceBox(BuildContext context, {String? balance}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black45,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black38),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Enter the Amount",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 28),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: addBalanceValue,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, letterSpacing: 3),
                autofocus: true,
                decoration: InputDecoration(
                    filled: true,
                    focusColor: Colors.white,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.white, width: 5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fillColor: Colors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: const Size(90, 50)),
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(GetStorage().read("PHONE_NUMBER"))
                      .update({"balance": '${int.parse(balance!) + int.parse(addBalanceValue.text.toString())}'
                    }).then((value) =>  Get.snackbar("Success", "₹${addBalanceValue.text} Added Successfully",backgroundColor: Color.fromRGBO(
                      17, 130, 20, 0.8),icon: Icon(Icons.verified_outlined),snackPosition: SnackPosition.TOP));

                }
              )
            ],
          ),
          elevation: 0,
        );
      },
    );
  }



  showPayNUmberBox(BuildContext context, String PHONE_NUMBER) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black45,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black38),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Enter the number",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 28),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: DialogBoxValue,
                keyboardType: TextInputType.number,maxLength: 10,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, letterSpacing: 3),
                autofocus: true,
                decoration: InputDecoration(
                    filled: true,
                    focusColor: Colors.white,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fillColor: Colors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: const Size(90, 50)),
                child: const Text(
                  'Pay',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
                onPressed: () async {
                  navigator?.pop();
                  DocumentSnapshot snapshot = await FirebaseFirestore.instance
                      .collection("users")
                      .doc(DialogBoxValue.text.toString())
                      .get();
                  if (snapshot.exists) {
                    Get.to(
                        pay_page(DialogBoxValue.text.toString(), PHONE_NUMBER));
                  } else if (DialogBoxValue.text.toString().length >
                          10 ||
                      DialogBoxValue.text.toString().length < 10) {
                    Get.snackbar("Warning", "Make Sure the Phone number is correct",backgroundColor: Color.fromRGBO(140, 13, 1, 0.8),icon: Icon(Icons.warning),snackPosition: SnackPosition.TOP);
                  } else {
                    Get.snackbar("Warning", "Make Sure the Receiver has CashSwift",backgroundColor: Color.fromRGBO(140, 13, 1, 0.8),icon: Icon(Icons.warning),snackPosition: SnackPosition.TOP);
                  }
                },
              )
            ],
          ),
          elevation: 0,
        );
      },
    );
  }

  showQrCode(BuildContext context, String PHONE_NUMBER) {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          width: 300,
          child: AlertDialog(
            backgroundColor: const Color.fromRGBO(15, 15, 15, 1),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Scan QR code",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 30),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: 200,
                    height: 200,
                    child: QrImageView(
                      data: PHONE_NUMBER,
                      size: 100,
                      backgroundColor: Colors.white,
                      gapless: true,
                    )),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(1),
                      backgroundColor: Colors.white,
                      fixedSize: const Size(90, 50)),
                  child: const Text(
                    'Copy',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                            text: "${PHONE_NUMBER.toString()}+@CodeSwift"))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Email address copied to clipboard")));
                    });
                  },
                )
              ],
            ),
            elevation: 0,
          ),
        );
      },
    );
  }


}
