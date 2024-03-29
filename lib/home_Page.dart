import 'dart:developer';

import 'package:cash_swift/UiHelper.dart';
import 'package:cash_swift/pay_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

String profilePic = "";

class home_Page extends StatefulWidget {
  String PHONE_NUMBER;
  home_Page({super.key, required this.PHONE_NUMBER});

  @override
  State<home_Page> createState() => home_PageState();
}

class home_PageState extends State<home_Page> {
  List<Map<String, dynamic>> transactionList =
      []; // Define an empty list to store transaction data

  String _scanBarcode = 'Unknown';
  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', "", true, ScanMode.QR);
      _scanBarcode = barcodeScanRes;
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occured while scanning QR code")));
      barcodeScanRes = 'Unable to scan';
    }
    if (!mounted) {
      return;
    } else if (mounted) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_scanBarcode)
          .get()
          .then((value) => {
                if (value.exists)
                  {Get.to(pay_page(_scanBarcode, widget.PHONE_NUMBER))}
                else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Make Sure reciever has CashSwift")))
                  }
              });
    }
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 10, 10, 1),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(widget.PHONE_NUMBER)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                print(GetStorage().read("PHONE_NUMBER"));
                return SafeArea(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "   Welcome,",
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 18),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "   ${(snapshot.data!["Name"]).toString().toUpperCase()}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        scanQR();
                                      },
                                      child: Card(
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: const Color.fromRGBO(
                                                        46, 115, 110, 1)),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons
                                                        .document_scanner_outlined,
                                                    color: Colors.white60,
                                                    size: 50,
                                                  ),
                                                )),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              "Scan",
                                              style: TextStyle(
                                                  color: Colors.white60),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        DialogBoxValue.clear();
                                        UiHelper().showPayNUmberBox(
                                            context, widget.PHONE_NUMBER);
                                      },
                                      child: Card(
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: const Color.fromRGBO(
                                                      46, 115, 110, 1),
                                                ),
                                                height: 70,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.payment_outlined,
                                                    color: Colors.white60,
                                                    size: 50,
                                                  ),
                                                )),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              "Pay",
                                              style: TextStyle(
                                                  color: Colors.white60),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        UiHelper().showAddBalanceBox(context,
                                            balance: snapshot.data!["balance"]);
                                      },
                                      child: Card(
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: const Color.fromRGBO(
                                                      46, 115, 110, 1),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    FontAwesomeIcons.wallet,
                                                    color: Colors.white60,
                                                    size: 50,
                                                  ),
                                                )),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              "Add balance",
                                              style: TextStyle(
                                                  color: Colors.white60),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                //ACCOUNT BALANCE CARD

                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Stack(clipBehavior: Clip.antiAlias,
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned(
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Container(
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      28, 53, 69, 0.6),
                                                  Color.fromRGBO(
                                                      25, 47, 62, 1),
                                                  Color.fromRGBO(
                                                      12, 40, 50, 0.7),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        right: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15.0),
                                          child: Image(
                                            colorBlendMode: BlendMode.overlay,
                                            image: const AssetImage(
                                                "assets/images/CardBackground.png"),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 30,
                                        left: 30,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Account Balance",
                                              style: GoogleFonts.robotoMono(
                                                textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.currency_rupee_outlined,
                                                  size: 30,
                                                  applyTextScaling: true,
                                                ),
                                                Text(
                                                  "${snapshot.data!["balance"]}",
                                                  style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  foregroundColor: Colors.white,
                                                  side: const BorderSide(
                                                      color: Colors.black38,
                                                      style:
                                                          BorderStyle.solid),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),)
                                              ),




                                              onPressed: () {
                                                UiHelper().showQrCode(context,
                                                    widget.PHONE_NUMBER);
                                              },
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.qr_code,
                                                  ),
                                                  Text(
                                                    "UPI ID: ${snapshot.data!["phoneNumber"]}@CodeSwift",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //TRANSACTION HISTORY

                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Recent Transaction",
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 25)),
                                    ),
                                  ),
                                  Expanded(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("transaction")
                                          .where('senderID',
                                              isEqualTo: widget.PHONE_NUMBER)
                                          .orderBy("timestampTime",
                                              descending: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ));
                                        }

                                        final transactionDocs =
                                            snapshot.data!.docs;
                                        return ListView.builder(
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final transaction =
                                                transactionDocs[index];
                                            final amount =
                                                transaction['amount'];
                                            final RecieverName =
                                                transaction['RecieverName'];
                                            final date =
                                                transaction['timestampDate'];
                                            final profilePicUrl =
                                                transaction["profilePicUrl"];

                                            return ListTile(
                                              leading: Container(
                                                height: 40,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black,
                                                  image: DecorationImage(
                                                      image: profilePicUrl !=
                                                              null
                                                          ? NetworkImage(
                                                              profilePicUrl)
                                                          : const NetworkImage(
                                                              "assets/images/default_profile_pic.png"),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              title: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Amount: ',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                      text: '$amount',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              subtitle: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Reciever: ',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                      text: '$RecieverName',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              trailing: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Date:\n',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                      text: '$date',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Add other transaction details as needed
                                            );
                                          },
                                          itemCount: transactionDocs.length,
                                          shrinkWrap: true,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Text("Error in fetching data");
              }
            } else {
              return const Text("Error occured");
            }
          }),
      bottomNavigationBar: UiHelper().showNavBar(),
    );
  }
}
