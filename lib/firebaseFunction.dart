import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class firebaseFunction {

    final CollectionReference transaction = FirebaseFirestore.instance.collection("transaction");
    
Future addTransaction(String senderID,String recieverID,String amount,String type){
  return transaction.add({
    "senderID":senderID,
    "recieverID":recieverID,
    "amount":amount,
    "type":type,
    "timestampTime":DateFormat("jm").format(DateTime.now()),
    "timestampDate":DateFormat("yMMMMd").format(DateTime.now())
  });
}

    CollectionReference<Object?> getTransactions() {
      return transaction;
    }

}