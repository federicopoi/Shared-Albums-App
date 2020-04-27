import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../profilePage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'imageDetail.dart';


class ProfileScreen extends StatefulWidget {

  ProfileScreen({Key key, this.title, this.uid, this.completeName}) : super(key: key); //update this to include the uid in the constructor

  final title;
  final String uid;
  final String completeName;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // Grid size counter
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
              return Center(child: new Text('Not connected to the Stream or null', style: TextStyle(color: Colors.white),));

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
                          child: Card(color: Color(0xff272727),

                              child: GestureDetector(
                                onTap: (){



                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ImageDetail(
                                            date: pictures[index].data['date'],
                                            url: pictures[index].data['url'],
                                            completeName: pictures[index].data['owner'],
                                            id: pictures[index].documentID,
                                            title: widget.title,
                                            uid: widget.uid,
                                          )));
                                },
                                child: Container(
                                  color: Color(0xff272727),

                                    width: 400, height: 400,alignment: Alignment.center,

                                      child: ClipRect(

                                        child: Align(

                                            alignment: Alignment.center,

                                            child: new CachedNetworkImage(

                                              imageBuilder: (context, imageProvider) => Container(
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
                          style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        child: Text(
                          "Once you uploaded a \npicture, wait around 20 seconds",
                          style: TextStyle(color: Colors.white, fontSize: 20, ),textAlign: TextAlign.center,

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

    return Scaffold(backgroundColor: Color(0xff121212),
      appBar: AppBar(
        backgroundColor: Color(0xff272727),
        title: Text("${widget.title}'s Pictures"),
        actions: <Widget>[
          RaisedButton(
            color: Color(0xff272727),
            child: Text('DELETE', style: TextStyle(color: Colors.white),),
            onPressed: ()async{



              Firestore.instance.collection("users").document(widget.uid)
                  .collection("ownProjects")
                  .document(widget.title)
                  .delete();

              Firestore.instance.collection('users').document(widget.uid)
                  .collection("ownProjects")
                  .document(widget.title).collection(widget.title).getDocuments().then((snapshot) {
                for (DocumentSnapshot ds in snapshot.documents){
                  ds.reference.delete();
                }});




              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: pictures,
            ),

          ],
        )
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
                if(axisCounter != 1){
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
        label: const Text('Upload Image', style: TextStyle(color: Colors.white),),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(

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
}



