import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class categoryTransaction extends StatefulWidget {
  final String PHONE_NUMBER;
  final String category;
  categoryTransaction({super.key ,required String this.PHONE_NUMBER,required String this.category});

  @override
  State<categoryTransaction> createState() {
    return _categoryTransactionState();
  }
}

class _categoryTransactionState extends State<categoryTransaction> {

   int totalAmountSpent=0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromRGBO(10, 10, 10, 1),
      body: Container(height: double.maxFinite,width: double.maxFinite,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("transaction").where('senderID', isEqualTo: widget.PHONE_NUMBER).where("type",isEqualTo: widget.category.toLowerCase()).orderBy("timestampTime",descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.white,));
          }

          final transactionDocs = snapshot.data!.docs;
          for(final transaction in transactionDocs){
            totalAmountSpent+=int.parse(transaction["amount"]);}
          return SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    Hero(tag: widget.category,child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(widget.category,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 40),),
                    )),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Total Amount spend: ",
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 18),
                          children: [
                            TextSpan(
                              text: '$totalAmountSpent',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300)

                            ),
                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: 30,),
                    ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final transaction = transactionDocs[index];
                        final amount = transaction['amount'];
                        final RecieverName = transaction['RecieverName'];
                        final date = transaction['timestampDate'];
                        final profilePicUrl = transaction["profilePicUrl"];



                
                        return Card(color: Color.fromRGBO(27, 50, 65, 0.7),margin: EdgeInsets.all(10),elevation: 12,shape: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile( 
                            leading: CircleAvatar(backgroundColor:Colors.black,radius: 20, backgroundImage: profilePicUrl != null ? NetworkImage(profilePicUrl) : NetworkImage("assets/images/default_profile_pic.png") ),
                            title: Text.rich(TextSpan(children: [const TextSpan(
                              text: 'Amount: ',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                              TextSpan(
                                text: '$amount',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                            ),
                            ),
                            subtitle: Text.rich(TextSpan(children: [const TextSpan(
                              text: 'Reciever: ',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                              TextSpan(
                                text: '$RecieverName',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                            ),
                            ),
                                          
                            trailing:Text.rich(TextSpan(children: [const TextSpan(
                              text: 'Date:\n',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                              TextSpan(
                                text: '$date',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                            ),
                            ),
                            // Add other transaction details as needed
                          ),
                        );
                      },
                      itemCount: transactionDocs.length,
                      shrinkWrap: true,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),),
    );
  }
}
