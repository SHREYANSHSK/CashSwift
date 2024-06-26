import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'UiHelper.dart';
import 'firebaseFunction.dart';

class pay_page extends StatefulWidget {
 final String scanBarcode;
 final String PHONE_NUMBER;

  pay_page(
    String this.scanBarcode,
    this.PHONE_NUMBER, {
    super.key,
  });

  @override
  State<pay_page> createState() => _pay_pageState();
}

class _pay_pageState extends State<pay_page> {
  TextEditingController payAmount = TextEditingController();
  TextEditingController typeValue = TextEditingController();
  var payerBalance;
  @override
  Widget build(BuildContext context) {
    log(widget.scanBarcode);
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(widget.scanBarcode)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: const Color.fromRGBO(15, 15, 15, 1),
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(
                                "${snapshot.data!["profilePicUrl"]}"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "PAYING TO",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 30),
                          ),
                          Text(
                            "${snapshot.data!["Name"]}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "${widget.scanBarcode}@CodeSwift",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(width: 190,
                            child: TextField(
                              controller: typeValue,
                              style: const TextStyle(overflow: TextOverflow.clip,
                                  color: Colors.white, fontSize: 20, letterSpacing: 3),

                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.category,color: Colors.white60,),
                                  filled: true,
                                  focusColor: Colors.white,labelText: "Type",labelStyle: TextStyle(color: Colors.white60),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white)),
                                  border: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Colors.white, width: 5,style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  fillColor: Colors.black38),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  (Icons.currency_rupee_outlined),
                                  color: Colors.white,
                                  size: 30,
                                ),
                                TextField(
                                  controller: payAmount,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.arimo(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          letterSpacing: 3)),
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      fillColor: Colors.black45,
                                      constraints:
                                          const BoxConstraints(maxWidth: 200),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        gapPadding: 5,
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.white,
                                            width: 1),
                                      ),
                                      border: OutlineInputBorder(
                                        gapPadding: 5,
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.white60,
                                            width: 3),
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                    height: 50,
                                    width: 60,
                                    child: FloatingActionButton.large(
                                      onPressed: () async {
                                        if (payAmount.text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text("Enter Amount")));
                                        } else {
                                            try {
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(widget.PHONE_NUMBER)
                                                  .get()
                                                  .then((DocumentSnapshot
                                                      documentSnapshot) async {
                                                if (documentSnapshot.exists) {
                                                  Map<String, dynamic> payerData =
                                                      documentSnapshot.data()
                                                          as Map<String,
                                                              dynamic>;

                                                    payerBalance = payerData['balance'];

                                                    if(int.parse(payerBalance)>=0 && int.parse(payerBalance)>=int.parse(payAmount.text.toString()))
                                                        {
                                                          //UPDATING BALANCE IN PAYER ACCOUNT
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(widget.PHONE_NUMBER
                                                          .toString())
                                                      .update({
                                                    "balance": (int.parse(
                                                                payerBalance) -
                                                            int.parse(
                                                                payAmount.text))
                                                        .toString(),
                                                  }).then((value) => (Timer(
                                                              const Duration(
                                                                  milliseconds:
                                                                      1000),
                                                              () {
                                                            UiHelper().snackBar(
                                                              titleMsg:
                                                                  "Payment sent",
                                                              bgColor:
                                                              Color.fromRGBO(
                                                                  17, 130, 20, 0.8),
                                                              subTitleMsg:
                                                                  "Your current balance: ₹${int.parse(payerData["balance"]) - int.parse(payAmount.text)}",
                                                            );
                                                          })));

                                                  //UPDATING BALANCE IN RECIEVER ACCOUNT
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(widget.scanBarcode
                                                          .toString())
                                                      .update({
                                                    "balance": (int.parse(
                                                                snapshot.data![
                                                                    "balance"]) +
                                                            int.parse(
                                                                payAmount.text))
                                                        .toString(),
                                                  }).then((value)  {UiHelper().snackBar(
                                                    
                                                          titleMsg:
                                                              "Payment Sucess",
                                                          subTitleMsg:
                                                              "₹${payAmount.text} is transfered to ${snapshot.data!["Name"]}",
                                                          bgColor: Color.fromRGBO(
                                                              17, 130, 20, 0.8),
                                                          iconData: Icons
                                                              .verified_outlined);
                                                    firebaseFunction().addTransaction(senderID: payerData["phoneNumber"], RecieverName: snapshot.data!["Name"], recieverID: snapshot.data!["phoneNumber"], amount: payAmount.text,type: typeValue.text.toString().trim(), profilePicUrl: snapshot.data!["profilePicUrl"]);
                                                  });
                                                }

                                                    else{
                                                      ScaffoldMessenger.of(context)
                                                          .showMaterialBanner(
                                                          MaterialBanner(
                                                              content: Text(
                                                                  "Not Enough Money \n Your current balance is ${payerData["balance"]}"),
                                                              backgroundColor:
                                                              Colors.redAccent,
                                                              actions: [
                                                                TextButton(
                                                                    onPressed: () {
                                                                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                                                    },
                                                                    child: Text("Ok",style: TextStyle(color: Colors.black),))
                                                              ]));

                                                    }
                                              }
                                              });


                                            } on FirebaseException catch (e) {
                                              UiHelper().snackBar(
                                                  titleMsg: "Payment failed",
                                                  subTitleMsg:
                                                      e.message.toString(),
                                                  bgColor:  Color.fromRGBO(140, 13, 1, 0.8),
                                                  iconData: Icons
                                                      .error_outline_outlined);
                                            } catch (e) {
                                              UiHelper().snackBar(
                                                  titleMsg: "Payment failed",
                                                  subTitleMsg: "error",
                                                  bgColor:  Color.fromRGBO(140, 13, 1, 0.8),
                                                  iconData: Icons
                                                      .error_outline_outlined);
                                            }

                                        }
                                        FocusScope.of(context).unfocus();
                                      },
                                      backgroundColor: Colors.white,
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: const Text(
                                        "Pay",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );





              } else {
                return const Center(child: Text("Error in fetching data"));
              }
            } else {
              return const Center(child: CircularProgressIndicator(color: Colors.white,));
            }
          },
        ));
  }
}
