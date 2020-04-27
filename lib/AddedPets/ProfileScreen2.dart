import 'dart:ui';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../imageDetail2.dart';
import '../profilePage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ProfileScreen2 extends StatefulWidget {

  ProfileScreen2({Key key, this.title, this.uid, this.completeName, this.actualUid}) : super(key: key); //update this to include the uid in the constructor

  final title;
  final String uid;
  final String completeName;
  final actualUid;

  @override
  _ProfileScreen2State createState() => _ProfileScreen2State();
}

class _ProfileScreen2State extends State<ProfileScreen2> {

  int axisCounter = 1;

  @override
  Widget build(BuildContext context) {
    // Pictures widget template

    Widget pictures = new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users')
            .document(widget.uid)
            .collection('ownProjects')
            .document(widget.title)
            .collection(widget.title)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return new Text(
                'Error in receiving pictures: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                  child: new Text('Not connected to the Stream or null', style: TextStyle(color: Colors.white),));

            case ConnectionState.waiting:
              return Center(child: new Text('Awaiting for interaction', style: TextStyle(color: Colors.white),));

            case ConnectionState.active:
              print("Stream has started but not finished");

              var totalPhotosCount = 0;
              List<DocumentSnapshot> pictures;

              if (snapshot.hasData) {
                pictures = snapshot.data.documents;
                totalPhotosCount = pictures.length;

                if (totalPhotosCount > 0) {
                  return new GridView.builder(
                      itemCount: totalPhotosCount,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      reverse: true,
                      primary: false,
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: axisCounter),
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                print('Tapped on thumbnail.');
                                print(
                                    'Photo doc id: ${pictures[index]
                                        .documentID}');
                              },
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ImageDetail2(

                                                url: pictures[index]
                                                    .data['url'],
                                                completeName: pictures[index]
                                                    .data['owner'],
                                                id: pictures[index].documentID,
                                                title: widget.title,
                                                date: pictures[index]
                                                    .data['date'],
                                                actualUid: widget.actualUid,
                                                uid: widget.uid,
                                              )));
                                },
                                child: Container(
                                  color: Color(0xff272727),
                                  width: 400,
                                  height: 400,
                                  alignment: Alignment.center,
                                  child:
                                  ClipRect(

                                    child: Align(
                                        alignment: Alignment.center,

                                        child: new CachedNetworkImage(
                                          imageBuilder: (context,
                                              imageProvider) =>
                                              Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,

                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                          placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                          imageUrl:
                                          pictures[index].data['url'],
                                        )),

                                  ),

                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
              }


              return new Center(

                  child: Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(50.0),
                      ),
                      Center(
                        child: new Text(
                          "Your pictures will be here",
                          style: TextStyle(color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        child: Text(
                          "Once you uploaded a \npicture, wait around 20 seconds",
                          style: TextStyle(color: Colors.white, fontSize: 20,),
                          textAlign: TextAlign.center,

                        ),
                      )
                    ],
                  ));

            case ConnectionState.done:
              return new Text('Streaming is done');
          }

          return Container(
            child: new Text("No pictures found."),
          );
        });

    return Scaffold(
      backgroundColor: Color(0xff121212),
      appBar: AppBar(
        backgroundColor: Color(0xff272727),
        title: Text("${widget.title}'s Pictures"),
        actions: <Widget>[
          RaisedButton(
            color: Color(0xff272727),
            child: Text('DELETE', style: TextStyle(color: Colors.white),),
            onPressed: ()async{



              Firestore.instance.collection("users").document(widget.actualUid)
                  .collection("addedProject")
                  .document(widget.title)
                  .delete();


              Navigator.pop(context);
            },
          )
        ],

      ),
      body: SingleChildScrollView(
        child: Container(
          child: pictures,
        ),
      ),
      bottomNavigationBar: BottomAppBar(

        color: Color(0xff272727),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.remove, color: Colors.white,),
              onPressed: () {
                if (axisCounter != 1) {
                  setState(() {
                    axisCounter--;
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.white,),
              onPressed: () {
                setState(() {
                  axisCounter++;
                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        elevation: 4.0,
        icon: const Icon(Icons.add, color: Colors.white,),
        label: const Text(
          'Upload Image', style: TextStyle(color: Colors.white),),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfilePage(

                        title: widget.title,
                        uid: widget.uid,
                        completeName: widget.completeName,



                      )));
        },
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

    );
  }
  void getData()async{

  }
}

