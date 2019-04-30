import 'package:flutter/material.dart';
//DATA
class Data {
    String mCategory;
    String mBalance;
}

void performUpdate(String cat, String desc, String amount) {
  
}

//DIALOGS
Future<void> _inputExpenceDialog(BuildContext context, String category) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      TextEditingController textEditingController1 = new TextEditingController();
      TextEditingController textEditingController2 = new TextEditingController();
      textEditingController1.text = '0';
      TextField txtAmount = TextField(keyboardType: TextInputType.number, controller: textEditingController1,);
      TextField txtDesc = TextField(keyboardType: TextInputType.text, controller: textEditingController2,);
      
      return AlertDialog(
        title: Text('Enter Expence Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please Enter the Amount Spent in ' + category.toUpperCase()),
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
              performUpdate(category, textEditingController2.text, textEditingController1.text);
            },
          ),
        ],
      );
    },
  );
}

//DESIGN
class Designs  {
    ListTile getListBox (BuildContext context, Data c) {
    var mTheme = Theme.of(context).textTheme;
    return new ListTile(
      title: Row(
        children: [
          Expanded( child: Text( c.mCategory, style: mTheme.headline,)),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xaaddaaff),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(c.mBalance , style: mTheme.display1),
          ), 
        ],
      ),
      //HANDLER
      onTap: () {
        print("onTap");
        _inputExpenceDialog(context, c.mCategory);
      },
    );
  }
}