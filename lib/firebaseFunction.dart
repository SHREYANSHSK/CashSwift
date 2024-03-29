import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class firebaseFunction {

    final CollectionReference transaction = FirebaseFirestore.instance.collection("transaction");
    
Future addTransaction({required String senderID, required String RecieverName, required String recieverID, required String amount,  String? type,required String profilePicUrl}){
  return transaction.add({
    "senderID":senderID,
    "recieverID":recieverID,
    "RecieverName":RecieverName,
    "amount":amount,
    "type":type,
    "timestampTime":DateFormat("jm").format(DateTime.now()),
    "timestampDate":DateFormat("yMMMMd").format(DateTime.now()),
    "profilePicUrl":profilePicUrl
  });
}

    Future<QuerySnapshot<Object?>> getTransactions({required String senderID}) {
      return transaction.where('sender', isEqualTo: senderID).get();
    }

}