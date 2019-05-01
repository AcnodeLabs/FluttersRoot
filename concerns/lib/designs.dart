import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//DATA
class Data {
  String mCategory;
  String mBalance;
}

void performUpdate(String cat, String desc, String amount,
    DocumentSnapshot document, Firestore instance) {
  //push data to cloud
  //Update balance
  //Add record in 'expences-records'
  instance.runTransaction((Transaction transaction) async {
    CollectionReference reference = instance.collection('expences-records');
    int newBal = document['balance'] - int.parse(amount);
    await document.reference.updateData({'balance': newBal});
    await reference.add({
      "amount": int.parse(amount),
      "what": desc,
      "category": cat,
      "when": Timestamp.now()
    });
  });
}

//DIALOGS
Future<void> _inputExpenceDialog(BuildContext context, String category,
    DocumentSnapshot document, Firestore instance) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      TextEditingController textEditingController1 =
          new TextEditingController();
      TextEditingController textEditingController2 =
          new TextEditingController();
      textEditingController1.text = '0';
      TextField txtAmount = TextField(
        keyboardType: TextInputType.number,
        controller: textEditingController1,
      );
      TextField txtDesc = TextField(
        keyboardType: TextInputType.text,
        controller: textEditingController2,
      );

      return AlertDialog(
        title: Text('Enter Expence Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Please Enter the Amount Spent in ' + category.toUpperCase()),
              txtAmount,
              Text('\n\nDescription (Optional)'),
              txtDesc,
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('ADD'),
            onPressed: () {
              Navigator.of(context).pop();
              performUpdate(category, textEditingController2.text,
                  textEditingController1.text, document, instance);
            },
          ),
        ],
      );
    },
  );
}

Future<void> _adminDialog(BuildContext context, String category,
    DocumentSnapshot document, Firestore instance) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      TextEditingController textEditingController1 =
          new TextEditingController();
      TextEditingController textEditingController2 =
          new TextEditingController();
      textEditingController1.text = '0';
      TextField txtAmount = TextField(
        keyboardType: TextInputType.number,
        controller: textEditingController1,
      );
      TextField txtDesc = TextField(
        keyboardType: TextInputType.text,
        controller: textEditingController2,
      );

      return AlertDialog(
        title: Text('ADMIN DIALOG'),
        backgroundColor: Color(0xaaddaaff),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Help:\n    tap any category for daily use'),
              Text('\n    : long press any category to show this dialog\n\n'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('START NEW MONTH'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('SHOW TRANSACTIONS'),
            onPressed: () {
              Navigator.of(context).pop();
              performUpdate(category, textEditingController2.text,
                  textEditingController1.text, document, instance);
            },
          ),
        ],
      );
    },
  );
}


//DESIGN
class Designs {
  ListTile getListBox(BuildContext context, Data c, DocumentSnapshot document,
      Firestore instance) {
    var mTheme = Theme.of(context).textTheme;
    return new ListTile(
      title: Row(
        children: [
          Expanded(
              child: Text(
            c.mCategory,
            style: mTheme.headline,
          )),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xaaddaaff),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(c.mBalance, style: mTheme.display1),
          ),
        ],
      ),
      //HANDLER
      onTap: () {
        print("onTap");
        _inputExpenceDialog(context, c.mCategory, document, instance);
      },
      onLongPress: () {
        print("onLongPress");
        _adminDialog(context, c.mCategory, document, instance);
      },
    );
  }
}
