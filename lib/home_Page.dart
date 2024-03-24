import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class home_Page extends StatefulWidget {
  const home_Page({super.key});

  @override
  State<home_Page> createState() => _home_PageState();
}

class _home_PageState extends State<home_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(15, 15, 15, 1),
      body: SingleChildScrollView(
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
                        const ListTile(
                          leading: Icon(
                            Icons.label_important_outlined,
                            color: Colors.white54,
                          ),
                          title: Text(
                            "Welcome",
                            style: TextStyle(
                                color: Color.fromRGBO(197, 199, 199, 1)),
                          ),
                          subtitle: Text(
                            "NAme",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 225,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(12),
                                    right: Radius.circular(12)),
                              ),
                              foregroundDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: const Border(
                                      right: BorderSide(
                                          strokeAlign: 3, width: 10),
                                      left: BorderSide(
                                          strokeAlign: 3, width: 10)
                                  )),
                              child: const Row(
                                children: [
                                  Icon(Icons.qr_code),
                                  Text("UPI ID: 9829530356@CodeSwift"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                          child: Text(
                            "Current Balance",
                            style: GoogleFonts.arimo(
                                textStyle:
                                    const TextStyle(color: Colors.white54)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0, left: 6),
                          child: Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.currency_rupee,
                                color: Colors.white,
                                size: 35,
                              ),
                              Text(
                                "1000.00",
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
                    const Positioned(
                        top: 200,
                        height: 100,
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              color: Colors.black54,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.qr_code_scanner_outlined,
                                      size: 30,
                                      color: Colors.white70,
                                    ),
                                    Text("Scan QR \n   code",
                                        style: TextStyle(color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Card(
                              color: Colors.black54,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.alternate_email,
                                      size: 30,
                                      color: Colors.white70,
                                    ),
                                    Text(
                                      "Pay UPI ID \n or number",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
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
                        margin: const EdgeInsets.symmetric(horizontal: 5),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: 8,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: Colors.black54,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: (TextStyle(color: Colors.white)),
                                ),
                                subtitle: const Text("DAte",
                                    style: (TextStyle(color: Colors.white24))),
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
      ),
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
