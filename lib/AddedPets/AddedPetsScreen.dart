import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CustomCardTwo.dart';

import 'package:fluttertoast/fluttertoast.dart';

class AddedPetsScreen extends StatefulWidget {
  AddedPetsScreen({Key key, this.uid, this.completeName}) : super(key: key); //update this to include the uid in the constructor

  final String uid; //include this
  final String completeName;



  @override
  _AddedPetsScreenState createState() => _AddedPetsScreenState();
}

class _AddedPetsScreenState extends State<AddedPetsScreen> {
  TextEditingController taskTitleInputController2;
  TextEditingController taskTitleInputController3;


  @override
  initState() {

    taskTitleInputController2 = new TextEditingController();
    taskTitleInputController3 = new TextEditingController();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xff121212),
      body: Center(
        child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("users")
                        .document(widget.uid)
                        .collection('addedProject')
                        .snapshots(),

                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new Center(child: new CircularProgressIndicator());
                        default:
                          return new ListView(
                            children: snapshot.data. documents
                                .map((DocumentSnapshot document) {
                              return new Column(
                                children: <Widget>[
                                  CustomCard2(
                                    title: document['title'],
                                    uid: document['uid'],
                                    completeName: widget.completeName,
                                      actualUid: widget.uid

                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              );

                            }).toList(),
                          );

                      }
                    },
                  )
              ),
            ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        elevation: 4.0,
        icon: const Icon(Icons.add, color: Colors.white,),
        label: const Text('Add Existing Album', style: TextStyle(color: Colors.white),),
        onPressed: () {
          _showDialog2();
        },
      ),
      bottomNavigationBar: BottomAppBar(

        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            Container(

              height: 60,
            )

          ],
        ),
        shape: CircularNotchedRectangle(),
        color: Color(0xff121212),
      ),
    );
  }
  _showDialog2() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        title: Center(child: Text("Add an existing album")),
        content: Wrap(
          children: <Widget>[
            Container(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Name of the album *'),
                controller: taskTitleInputController2,
              ),
            ),
            Container(
              child: TextField(
                autofocus: true,

                decoration: InputDecoration(labelText: 'Code Id *'),
                controller: taskTitleInputController3,

              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                taskTitleInputController2.clear();
                taskTitleInputController3.clear();

                Navigator.pop(context);
              }),
          FlatButton(
              child: Text('Add'),
              onPressed: () async{

                final snapShot2 = await Firestore.instance
                    .collection('users')
                    .document(taskTitleInputController3.text)
                    .collection('ownProjects')
                    .document(taskTitleInputController2.text)
                    .get();

                final snapShot = await Firestore.instance
                    .collection('users')
                    .document(taskTitleInputController3.text)
                    .get();

                if (snapShot == null || !snapShot.exists && snapShot2 == null || !snapShot2.exists) {

                  Fluttertoast.showToast(
                    msg: "Name or ID is not valid",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,

                  );



                }else{
                  if (taskTitleInputController2.text.isNotEmpty && taskTitleInputController3.text.isNotEmpty
                      && taskTitleInputController3.text != widget.uid) {



                    Firestore.instance
                        .collection("users")
                        .document(widget.uid)
                        .collection('addedProject')
                        .document(taskTitleInputController2.text)
                        .setData({
                      "title": taskTitleInputController2.text,
                      "uid": taskTitleInputController3.text
                    })
                        .then((result) => {
                      Navigator.pop(context),
                      taskTitleInputController2.clear(),
                      taskTitleInputController3.clear(),
                    })
                        .catchError((err) => print(err));
                  }
                }



              })
        ],
      ),


    );
  }
}

