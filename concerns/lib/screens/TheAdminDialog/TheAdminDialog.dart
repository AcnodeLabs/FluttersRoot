import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/services.dart';



showAlertDialogYesNo(BuildContext context, String msg) {
  BuildContext bc;

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.pop(bc);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed:  () {
      Navigator.pop(bc);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text("Are you sure you want to "+ msg + " ?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      bc = context;
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
        backgroundColor: Colors.redAccent,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('\nPress RESET to reset to default allocations\n'),
              Text('\nPress ALLOCATE to change allocations\n'),
              Text('\nPress CANCEL to exit to normal\n'),
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
            child: Text('ALLOCATE'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('<<< RESET >>>'),
            onPressed: () {
              Navigator.of(context).pop();
              showAlertDialogYesNo(context, "reset allocations to Defaults");
              Services.act('Admin', 'Reset');
            },
          ),
          
        ],
      );
    },
  );
}