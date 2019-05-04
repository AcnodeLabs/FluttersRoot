import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/Data.dart';

class TheInputForm extends StatefulWidget {
  void setInputs(
      String category0, DocumentSnapshot document0, Firestore instance0) {
    category = category0;
    document = document0;
    instance = instance0;
  }

  @override
  _TheInputFormState createState() => new _TheInputFormState();
}

Future<void> showInputForm(BuildContext context, String category,
    DocumentSnapshot document, Firestore instance) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      TheInputForm a = new TheInputForm();
      a.setInputs(category, document, instance);
      return a;
    },
  );
}

class _TheInputFormState extends State<TheInputForm> {
  TextEditingController textEditingController1 = new TextEditingController();
  TextEditingController textEditingController2 = new TextEditingController();
  // textEditingController1.text = '0';

  Widget mTitle() {
    return Text('Enter Expence Details');
  }

  Widget mContent(TextField txtAmount, TextField txtDesc) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text('Please Enter the Amount Spent in ' + category.toUpperCase()),
          txtAmount,
          Text('\n\nDescription (Optional)'),
          txtDesc,
        ],
      ),
    );
  }

  List<Widget> mActionBar() {
    return <Widget>[
      FlatButton(
        child: Text('<VIEW>'),
        onPressed: () {
          Navigator.of(context).pop();
          //   setViewMode(2);
        },
      ),
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
          instance.runTransaction((Transaction transaction) async {
            CollectionReference reference =
                instance.collection('expences-records');
            int newBal =
                document['balance'] - int.parse(textEditingController1.text);
            await document.reference.updateData({'balance': newBal});
            await reference.add({
              "amount": textEditingController1.text,
              "what": textEditingController2.text,
              "category": category,
              "when": Timestamp.now()
            });
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    TextField txtAmount = TextField(
      keyboardType: TextInputType.number,
      controller: textEditingController1,
    );
    TextField txtDesc = TextField(
      keyboardType: TextInputType.text,
      controller: textEditingController2,
    );

    return AlertDialog(
      title: mTitle(),
      content: mContent(txtAmount, txtDesc),
      actions: mActionBar(),
    );
  }
}
