import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

showAlertDialogYesNo(BuildContext context) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text("Are you sure you want to reset allocation to defaults ?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

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
              showAlertDialogYesNo(context);
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