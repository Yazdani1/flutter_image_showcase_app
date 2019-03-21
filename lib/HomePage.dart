import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {

  StreamSubscription<QuerySnapshot>subscription;
  List<DocumentSnapshot>walpapers;

 final CollectionReference collectionReference=Firestore.instance.collection("images");

  @override
  void initState() {

    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot){
      setState(() {
        walpapers=datasnapshot.documents;
      });
    });
  }
  @override
  void dispose() {
    subscription.cancel();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: new AppBar(
        title: new Text("Image Show Case App"),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[

          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: ()=>debugPrint("search")
          ),
          new IconButton(
              icon: new Icon(Icons.add),
              onPressed: ()=>debugPrint("add")
          )
        ],
      ),

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[

            new UserAccountsDrawerHeader(
                accountName: new Text("Code With Ydc"),
                accountEmail: new Text("ydc@gmail.com"),
              decoration: new BoxDecoration(
                color: Colors.redAccent
              ),
            ),
            new ListTile(
              title: new Text("First Page"),
              leading: new Icon(Icons.search,color: Colors.redAccent,),
            ),
            new ListTile(
              title: new Text("Second Page"),
              leading: new Icon(Icons.add,color: Colors.green,),
            ),
            new ListTile(
              title: new Text("Third Page"),
              leading: new Icon(Icons.cake,color: Colors.orange,),
            ),
            new ListTile(
              title: new Text("Fourth Page"),
              leading: new Icon(Icons.print,color: Colors.purple,),
            ),
            new Divider(
              height: 10.0,
              color: Colors.purple,
            ),
            new ListTile(
              title: new Text("Close"),
              trailing: new Icon(Icons.close,color: Colors.red,),
              onTap: (){
                Navigator.of(context).pop();
              },
            )

          ],
        ),
      ),
      //drawer end here..

//      body: new ListView.builder(
//          itemCount: walpapers.length,
//          itemBuilder: (context,index){
//            return new Card(
//              margin: EdgeInsets.all(10.0),
//
//              elevation: 10.0,
//              child: new Container(
//                padding: EdgeInsets.all(10.0),
//                child: new Text(walpapers[index].data["title"],
//                  style: TextStyle(fontSize: 24.0,color: Colors.orange,),
//                ),
//              ),
//
//            );
//          }),

      
      body: walpapers !=null?
      new StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8.0),
          crossAxisCount: 4,
          itemCount: walpapers.length,
        itemBuilder: (conext,i){

          String imagPath=walpapers[i].data["url"];

          return new Material(
            elevation: 8.0,
            borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
            child: new InkWell(
              child: new Hero(
                  tag: imagPath,
                  child: new FadeInImage(
                      placeholder: new AssetImage("assets/c.jpg"),
                      image: new NetworkImage(imagPath),
                      fit: BoxFit.cover,
                  )
              ),
            ),

          );

        },
        staggeredTileBuilder: (i)=>new StaggeredTile.count(2, i.isEven?2:3),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ):new Center(
        child: new CircularProgressIndicator(),
      )
      
    );
  }
}
