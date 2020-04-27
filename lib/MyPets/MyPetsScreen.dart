import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'customCard.dart';

class MyPetsScreen extends StatefulWidget {
  MyPetsScreen({Key key, this.uid, this.completeName}) : super(key: key); //update this to include the uid in the constructor

  final String uid; //include this
  final String completeName;

  @override
  _MyPetsScreenState createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {




  TextEditingController taskTitleInputController;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  initState() {

    taskTitleInputController = new TextEditingController();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xff121212),


      body: Center(
        child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("users")
                        .document(widget.uid)
                        .collection('ownProjects')
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
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return new Column(
                                children: <Widget>[
                                  CustomCard(
                                    title: document['title'],
                                    uid: widget.uid,
                                    completeName: widget.completeName,


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
        label: const Text('New Album', style: TextStyle(color: Colors.white),),
        onPressed: () {
          _showDialog();
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
  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        title: Center(child: Text("Add a new Album")),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(labelText: 'Name of the Album *'),
          controller: taskTitleInputController,
        ),

        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                taskTitleInputController.clear();

                Navigator.pop(context);
              }),
          FlatButton(
              child: Text('Add'),
              onPressed: () {


                if (taskTitleInputController.text.isNotEmpty) {
                  Firestore.instance
                      .collection("users")
                      .document(widget.uid)
                      .collection('ownProjects')
                      .document(taskTitleInputController.text)
                      .setData({
                    "title": taskTitleInputController.text,
                  })
                      .then((result) => {
                    Navigator.pop(context),
                    taskTitleInputController.clear(),
                  })
                      .catchError((err) => print(err));
                }
              })
        ],
      ),


    );
  }

}

