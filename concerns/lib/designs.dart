import 'package:flutter/material.dart';
//DATA
class Concerns {
    String mBy;
    String mCat;
    String mDesc;
    String mLoc;
    String mStatus;
    String mWhen;
}
//DESIGN
class Designs  {
    ListTile getListBox (BuildContext context, Concerns c) {
    var mTheme = Theme.of(context).textTheme;
    return new ListTile(
      title: Row(
        children: [
          Expanded( child: Text( c.mBy, style: mTheme.headline,)),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xaaddaaff),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(c.mWhen,style: mTheme.display1),
          ), 
        ],
      ),
      //HANDLER
      onTap: () {
        print("onTap");
      },
    );
  }
}