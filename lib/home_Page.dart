
import 'package:cash_swift/pay_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class home_Page extends StatefulWidget {
  String PHONE_NUMBER;
  home_Page({super.key, required this.PHONE_NUMBER});

  @override
  State<home_Page> createState() => _home_PageState();
}

class _home_PageState extends State<home_Page> {
  TextEditingController DialogBoxValue = TextEditingController();
  String _scanBarcode = 'Unknown';
  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      _scanBarcode=barcodeScanRes;
      Get.to(pay_page(_scanBarcode));
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error occured while scanning QR code")));
      barcodeScanRes = 'Unable to scan';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(15, 15, 15, 1),
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
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color.fromRGBO(52, 131, 118, 1),
                                Color.fromRGBO(23, 78, 75, 1)
                              ]),
                              borderRadius: BorderRadius.circular(50)),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.label_important_outlined,
                                      color: Colors.white54,
                                    ),
                                    title: const Text(
                                      "Welcome",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(197, 199, 199, 1)),
                                    ),
                                    subtitle: Text(
                                      "${snapshot.data!["Name"]}".toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    trailing: const Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 225,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.horizontal(
                                              left: Radius.circular(12),
                                              right: Radius.circular(12)),
                                        ),
                                        foregroundDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: const Border(
                                                right: BorderSide(
                                                    strokeAlign: 3, width: 10),
                                                left: BorderSide(
                                                    strokeAlign: 3,
                                                    width: 10))),
                                        child: InkWell(onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return SizedBox(height: 300,width: 300,
                                                child: AlertDialog(
                                                  backgroundColor: const Color.fromRGBO(
                                                      15, 15, 15, 1),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(color:
                                                    Colors.black38!), borderRadius:
                                                  const BorderRadius
                                                      .all(
                                                      Radius.circular(
                                                          15)),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      const Text(
                                                        "Scan QR code",
                                                        style: TextStyle(
                                                            color:
                                                            Colors.white,
                                                            fontWeight:
                                                            FontWeight
                                                                .w900,
                                                            fontSize: 30),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(width: 200,height: 200,child: QrImageView(data: widget.PHONE_NUMBER,size: 100,backgroundColor: Colors.white,gapless: true,)),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(padding: EdgeInsets.all(1),
                                                            backgroundColor:
                                                            Colors.white,fixedSize: Size(90, 50)
                                                        ),
                                                        child: const Text(
                                                          'Copy',
                                                          style: TextStyle(
                                                            color:
                                                            Colors.black,
                                                            fontWeight:
                                                            FontWeight
                                                                .w700,
                                                            fontSize: 28,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Clipboard.setData(ClipboardData(text: "${widget.PHONE_NUMBER.toString()}+@CodeSwift")).then((_){
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email address copied to clipboard")));
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
                                        },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.qr_code),
                                              Text(
                                                  "UPI ID: ${snapshot.data!["phoneNumber"]}@CodeSwift"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0, left: 8.0),
                                    child: Text(
                                      "Current Balance",
                                      style: GoogleFonts.arimo(
                                          textStyle: const TextStyle(
                                              color: Colors.white54)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3.0, left: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.currency_rupee,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                        Text(
                                          "${snapshot.data!["balance"]}",
                                          style: GoogleFonts.arimo(
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 37,
                                                  fontWeight: FontWeight.w700)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                  top: 200,
                                  height: 100,
                                  width: 250,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(onTap: (){scanQR();},
                                        child: const Card(
                                          color: Colors.black54,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.qr_code_scanner_outlined,
                                                  size: 30,
                                                  color: Colors.white70,
                                                ),
                                                Text("Scan QR \n   code",
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: const Color.fromRGBO(
                                                    15, 15, 15, 1),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(color:
                                                  Colors.black38!), borderRadius:
                                                const BorderRadius
                                                    .all(
                                                    Radius.circular(
                                                        15)),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: <Widget>[
                                                    const Text(
                                                      "Enter the number",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w900,
                                                          fontSize: 30),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextField(
                                                      controller:
                                                      DialogBoxValue,
                                                      keyboardType:
                                                      TextInputType
                                                          .number,
                                                      style:
                                                      const TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize: 20,
                                                          letterSpacing:
                                                          3),
                                                      autofocus: true,
                                                      decoration:
                                                      InputDecoration(filled: true,
                                                          focusColor:
                                                          Colors.white,
                                                          focusedBorder: const OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                          border:
                                                          OutlineInputBorder(
                                                            borderSide: const BorderSide(color: Colors.white,
                                                                width: 5),
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                12),
                                                          ),
                                                          fillColor: Colors.black),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                          backgroundColor:
                                                          Colors.white,fixedSize: Size(90, 50)
                                                      ),
                                                      child: const Text(
                                                        'Pay',
                                                        style: TextStyle(
                                                          color:
                                                          Colors.black,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    )
                                                  ],
                                                ),
                                                elevation: 0,
                                              );
                                            },
                                          );
                                        },
                                        child: const Card(
                                          color: Colors.black54,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.alternate_email,
                                                  size: 30,
                                                  color: Colors.white70,
                                                ),
                                                Text(
                                                  "Pay UPI ID \n or number",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),

                      //QUICK SEND SECTION
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "quick send",
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  borderOnForeground: true,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  clipBehavior: Clip.hardEdge,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: ClipRRect(
                                        child: Image.asset(
                                      "assets/images/img.png",
                                      fit: BoxFit.cover,
                                    )),
                                  ),
                                );
                              },
                              itemCount: 7,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          //TRANSACTION HISTORY SECTION
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "history",
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.shortestSide,
                            child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: 8,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    color: Colors.black54,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Image.asset(
                                              "assets/images/img_1.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: const Text(
                                            "NAme",
                                            style: (TextStyle(
                                                color: Colors.white)),
                                          ),
                                          subtitle: const Text("DAte",
                                              style: (TextStyle(
                                                  color: Colors.white24))),
                                        ),
                                        const SizedBox(
                                          height: 60,
                                        ),
                                        Text(
                                          "  + ₹200",
                                          style: GoogleFonts.arimo(
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.w700)),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return const Text("Error in fetching data");
              }
            } else {
              return const Text("Error occured");
            }
          }),
      bottomNavigationBar: const BottomAppBar(
        height: 60,
        color: Colors.transparent,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Icon(
            Icons.home,
            color: Colors.white70,
          ),
          Icon(
            Icons.dashboard,
            color: Colors.white70,
          ),
          Icon(
            Icons.category,
            color: Colors.white70,
            size: 30,
          ),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/img_1.png"),
          )
        ]),
      ),
    );
  }
}
