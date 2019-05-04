import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data/index.dart';
import 'util/index.dart';
import 'screens/TheInputForm/TheInputForm.dart';

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

//DESIGN
class Designs {
  ListTile getListBox(BuildContext context, Data c, DocumentSnapshot document,
      Firestore instance, int type) {
    var mTheme = Theme.of(context).textTheme;
    return new ListTile(
      title: Row(
        children: [
          Expanded(
              child: Text(
            c.mStr1,
            style: mTheme.headline,
          )),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xaaddaaff),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(c.mStr2, style: mTheme.display1),
          ),
        ],
      ),
      //HANDLER
      onTap: () {
        print("onTap");
        if (type == 1)
          showInputForm(context, c.mStr1, document, instance);
      },
      onLongPress: () {
        print("onLongPress");
        if (type == 1) _adminDialog(context, c.mStr2, document, instance);
      },
    );
  }
}

int viewMode = 1;
MyApp app1;

void setViewMode(int mode) {
  viewMode = mode;
}

void main() {
  //   MapView.setApiKey("AIzaSyBRRVZQb0kK9_Tvy3u_D84zPSJbZ0RbjNo");
  app1 = new MyApp();
  runApp(app1);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Expences',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.deepPurple,
          fontFamily: "Consolas"),
      home: MyHomePage(title: 'Our Home Expences App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      data.mStr1 = padIt(document['category'].toString(), 20) +
          padIt(document['amount'].toString(), 10) +
          "     " +
          document['what'].toString();
      data.mStr2 = readTimestamp(document['when']);
    }

    //UI
    return Designs().getListBox(context, data, document, instance, type);
  }

  StreamBuilder listFromDb(String collectionName, int type) {
    return StreamBuilder(
        stream: Firestore.instance.collection(collectionName).snapshots(),
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
          title: FlatButton(
            child: Text('<< BACK'),
            onPressed: () {
              Navigator.of(context).pop();
              setViewMode(1);
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
