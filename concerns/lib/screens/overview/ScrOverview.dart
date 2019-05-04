import 'package:flutter/material.dart';

class ScrOverview extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold( // 1
      appBar: new AppBar( //2
        title: new Text("Auth"),
      ),
      body: new Container(
      // decoration: new BoxDecoration(color: Colors.white),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('child1'),
              new Padding(
                padding: new EdgeInsets.all(8.0),
                child: new Text('Padded Child2')
              )
            ],
          )
        )
      )
    );
  }
}