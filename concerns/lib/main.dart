import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './designs.dart';
/*
import 'package:map_view/map_view.dart';


var _mapView = new MapView();

void showMap() {
    _mapView.show(new MapOptions(showUserLocation: true));
}
*/
 void main() {
  //   MapView.setApiKey("AIzaSyBRRVZQb0kK9_Tvy3u_D84zPSJbZ0RbjNo");
     runApp(new MyApp());
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
        fontFamily: "Consolas"
      ),
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


 Widget _buildListItems(BuildContext context, DocumentSnapshot document) {
    //Get Data from Cloud
    Data d = new Data();
    d.mCategory = document['name'].toString();
    d.mBalance = document['balance'].toString();
    
    //UI
    return Designs().getListBox(context, d);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('expences').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading');
            return ListView.builder(
               itemExtent: 80.0,
               itemCount: snapshot.data.documents.length,
               itemBuilder: (context, index) => 
                  _buildListItems(context, snapshot.data.documents[index]),
            );//ListViewBuilder
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}