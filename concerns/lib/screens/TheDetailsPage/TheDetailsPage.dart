import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/index.dart';
import '../../util/index.dart';
import '../../services/services.dart';
import '../../screens/TheInputForm/TheInputForm.dart';
import '../../screens/TheAdminDialog/TheAdminDialog.dart';


Future<int> _asyncConfirmDialog(BuildContext context, String msg) async {
  return showDialog<int>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Please Confirm'),
        content: Text(
            'Are you sure you want to '+ msg+ '?'),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
          FlatButton(
            child: const Text('PROCEED'),
            onPressed: () {
              Navigator.of(context).pop(1);
            },
          )
        ],
      );
    },
  );
}

class TheDetailsPage extends StatefulWidget {
  TheDetailsPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _TheDetailsPageState createState() => _TheDetailsPageState();
}

class _TheDetailsPageState extends State<TheDetailsPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Widget _buildListItems(BuildContext context, DocumentSnapshot document,
      Firestore instance, int type) {
    //Get Data from Cloud
    Data data = new Data();

    if (type == 1) {
      data.mStr1 = document['name'].toString();
      data.mStr2 = document['balance'].toString();
    }

    if (type == 2) {
      data.mStr1 = Util.padIt(document['category'].toString(), 20) +
          Util.padIt(document['amount'].toString(), 10) +
          "     " +
          document['what'].toString();
      data.mStr2 = Util.DDMMM(document['when']);
    }

    //UI
    var mTheme = Theme.of(context).textTheme;
    return new ListTile(
      title: Row(
        children: [
          Expanded(
              child: Text(
            data.mStr1,
            style: mTheme.headline,
          )),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xaaddaaff),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(data.mStr2, style: mTheme.display1),
          ),
        ],
      ),
      //HANDLER
      onTap: () async {
        print("onTap");
        final int ii = await _asyncConfirmDialog(context, "delete this record " + document['what'].toString() + "(" +document['amount'].toString() + ")");
        
        if (ii == 1) {
          int amount = int.parse(document['amount'].toString());
          instance.runTransaction((Transaction transaction) async {
            Firestore.instance.collection('expences-records').document(document.documentID).delete();
          });
          instance.runTransaction((Transaction transaction) async {
            QuerySnapshot a = await Firestore.instance.collection('expences').where('name',isEqualTo: category).snapshots().first;
              DocumentSnapshot dd = a.documents.first;
              int bal = dd['balance'];
              await dd.reference.updateData({'balance': (bal+ amount)});
            });
       }
      },
      onLongPress: () {
        print("onLongPress");
        if (type == 1) showAdminDialog(context, data.mStr2, document, instance);
      },
    );
  }

  StreamBuilder listFromDb(String collectionName, int type) {
    return StreamBuilder(
        stream: Firestore.instance.collection(collectionName).where('category',isEqualTo: category).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) => _buildListItems(context,
                snapshot.data.documents[index], Firestore.instance, type),
          ); //ListViewBuilder
        });
  }
  int viewMode = 2;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    if (viewMode == 1)
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: listFromDb('expences', 1), //listFromDb('expences-records', 2),
        // floatingActionButton: FloatingActionButton(
        //  onPressed: _incrementCounter,
        //  tooltip: 'Increment',
        //   child: Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      );

    if (viewMode == 2)
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: RaisedButton(
            child: Text(
              '<< DETAILS of ' + category + ' >>'
            ),
            onPressed: () {
           //   Navigator.pop(context);
            },
          ),
        ),
        body: listFromDb('expences-records', 2),
      );

    // floatingActionButton: FloatingActionButton(
    //  onPressed: _incrementCounter,
    //  tooltip: 'Increment',
    //   child: Icon(Icons.add),listFromDb('expences-records', 2),
    // ), // This trailing comma makes auto-formatting nicer for build methods.
  }
}


