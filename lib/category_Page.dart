
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'categoryTransaction_Page.dart';

class categoryPage extends StatefulWidget {
  final String PHONE_NUMBER;
  categoryPage({super.key, required String this.PHONE_NUMBER,});

  @override
  State<categoryPage> createState() => _categoryPageState();
}

class _categoryPageState extends State<categoryPage> {
  final querySnapshot = FirebaseFirestore.instance
      .collection('transactions')
      .where('sender', isEqualTo: "9829530356")
      .where('expenditureType', isEqualTo: 'groceries')
      .get;
  var type;
  var typeList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(15, 15, 15, 1),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("transaction")
              .where("senderID", isEqualTo: widget.PHONE_NUMBER)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                snapshot.data!.docs.forEach((DocumentSnapshot doc) {
                  String type = doc["type"].toString().toUpperCase();
                  if (!typeList.contains(type) && type.isNotEmpty) {
                    typeList.add(type);
                  }
                });

                return SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: const Color.fromRGBO(10, 10, 10, 1),
                    child: Column(
                      children: [const SizedBox(height: 30,),
                        const Text("Categories",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 40),),
                        Expanded(
                          child: GridView.builder(padding: const EdgeInsets.only(top: 50,right: 10,left: 10),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 12,mainAxisSpacing: 12,mainAxisExtent: 150,
                                crossAxisCount: 1),shrinkWrap: false,physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(onTap: (){Get.to(categoryTransaction(PHONE_NUMBER: widget.PHONE_NUMBER,category: typeList[index].toString(),));},
                                child: Hero(
                                  tag: typeList[index].toString(),
                                  child: Card(color:  Color.fromRGBO(
                                      27, 50, 65, 0.5),
                                    child: Center(
                                        child: Text(
                                            typeList[index].toString().toUpperCase(),style: const TextStyle(color: Colors.white,fontSize: 50,fontWeight: FontWeight.w300),)),
                                  ),
                                ),
                              );
                            },
                            itemCount: typeList.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: Text("error in fetching data"));
              }
            } else {
              return const Text("backend error");
            }
          }),
    );
  }
}
