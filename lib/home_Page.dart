

import 'package:CashSwift/pay_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'UiHelper.dart';

String profilePic = "";

class home_Page extends StatefulWidget {
  final String PHONE_NUMBER;
  home_Page({super.key, required this.PHONE_NUMBER});

  @override
  State<home_Page> createState() => home_PageState();
}

class home_PageState extends State<home_Page> {






  List<Map<String, dynamic>> transactionList = [];

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
          Get.snackbar("Warning", "Make Sure the Receiver has CashSwift",backgroundColor: Color.fromRGBO(140, 13, 1, 0.8),icon: Icon(Icons.warning),snackPosition: SnackPosition.BOTTOM)
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
          .doc(widget.PHONE_NUMBER.toString())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

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
                                      children: [
                                        Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12),
                                                color: const Color.fromRGBO(
                                                    25, 47, 62, 0.8)),
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

                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: const Color.fromRGBO(
                                                  25, 47, 62, 0.8),
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
                                        balance: snapshot.data!["balance"].toString());
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
                                                  25, 47, 62, 0.8),
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

                            Container(margin: EdgeInsets.all(10),
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
                                        width: MediaQuery.of(context).size.width,
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
                                        MediaQuery.of(context).size.width-27,
                                    right: 1,
                                    child: Image(
                                      colorBlendMode: BlendMode.overlay,
                                      image: const AssetImage(
                                          "assets/images/CardBackground.png"),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                    ),
                                  ),
                                  Positioned(
                                    top: 30,
                                    left: 30,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,mainAxisSize: MainAxisSize.min,
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
                                          height: 15,
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
                                      .where(Filter.or(Filter('senderID',
                                      isEqualTo: widget.PHONE_NUMBER),Filter("recieverID", isEqualTo: widget.PHONE_NUMBER)))
                                      .orderBy("timestampDate",
                                          descending: true).orderBy("timestampTime",descending: true)
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
                                      itemBuilder: (BuildContext context, int index) {
                                        final transaction = transactionDocs[index];
                                        final amount = transaction['amount'];
                                        final receiverName = transaction['RecieverName'];
                                        final senderID = transaction["senderID"];
                                        final receiverID = transaction["recieverID"];
                                        final date = transaction['timestampDate'];
                                        final profilePicUrl = transaction["profilePicUrl"];


                                        final bool isSender = senderID == widget.PHONE_NUMBER;
                                        final bool isReceiver = receiverID == widget.PHONE_NUMBER;


                                        return ListTile(
                                          leading: Container(
                                            height: 40,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.black,
                                              image: profilePicUrl != null
                                                  ? DecorationImage(
                                                image: NetworkImage(profilePicUrl),
                                                fit: BoxFit.cover,
                                              )
                                                  : null,
                                            ),
                                          ),
                                          title: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Amount: ',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                isSender?TextSpan(
                                                  text: '-$amount',
                                                  style: const TextStyle(color: Colors.white),
                                                ):TextSpan(
                                                  text: '+$amount',
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          subtitle: Text.rich(
                                            TextSpan(
                                              children: [
                                                 isReceiver? TextSpan(
                                                     text: 'Sender: ',
                                                     style: TextStyle(
                                                       color: Colors.white,
                                                       fontWeight: FontWeight.bold,
                                                     )
                                                 ):TextSpan(
                                                     text: 'Recipient: ',
                                                     style: TextStyle(
                                                       color: Colors.white,
                                                       fontWeight: FontWeight.bold,
                                                     )
                                                 ),
                                                isReceiver? TextSpan(
                                                  text:  senderID,
                                                  style: const TextStyle(color: Colors.white),
                                                ):TextSpan(
                                                  text: receiverName,
                                                  style: const TextStyle(color: Colors.white),
                                                )
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
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '$date',
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: transactionDocs.length,
                                      shrinkWrap: true,
                                    );
                                    ;
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
          } else if(snapshot.hasError) {
            return  Text("Error in fetching data");
          }
          else{return Center(child: CircularProgressIndicator());}
        } else {
          return  Text("Error occured");
        }
      }),
    );
  }
}
