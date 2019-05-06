import 'package:cloud_firestore/cloud_firestore.dart';

class HomeExpenceServices {
 
  static copyField(DocumentSnapshot doc, String from, String to) {
    if (doc.exists) {
      final DocumentReference postRef = doc.reference;
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          await tx.update(postRef,
              <String, dynamic>{to: postSnapshot.data[from]});
        }
      });
    }
  }

  static resetToDefaults() async {
    Firestore.instance
        .collection('expences')
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => copyField(doc, 'alloc', 'balance')));
  }
}

class Services {
  static act(String dialogName, String buttonText) {
    if (dialogName == 'Admin') if (buttonText == 'Reset')
      HomeExpenceServices.resetToDefaults();
  }
}
