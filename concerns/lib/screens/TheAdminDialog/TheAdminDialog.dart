import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> showAdminDialog(BuildContext context, String category,
    DocumentSnapshot document, Firestore instance) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      TextEditingController textEditingController1 =
          new TextEditingController();
      TextEditingController textEditingController2 =
          new TextEditingController();
      // textEditingController1.text = '0';
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
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Reset'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Data'),
            onPressed: () {
              Navigator.of(context).pop();
              //      performUpdate(category, textEditingController2.text,
              //         textEditingController1.text, document, instance);
            },
          ),
        ],
      );
    },
  );
}