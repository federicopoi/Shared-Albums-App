import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CopyDataScreen extends StatefulWidget {

  CopyDataScreen({Key key, this.actualUid, this.uid, this.title}) : super(key: key); //update this to include the uid in the constructor


  final actualUid;
  final title;
  final uid;

  @override
  _CopyDataScreenState createState() => _CopyDataScreenState();
}

class _CopyDataScreenState extends State<CopyDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('users').document(widget.uid).collection('ownProjects')
          
              .document(widget.title)
              .collection(widget.title)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Text('Loading...');
              default:
                return new ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                    return Center(
                      child: new RaisedButton(
                          child: Text('Copy Data'),
                          onPressed: ()async{
                            var imageName = Uuid().v1();
                            Firestore.instance.collection('users')
                                .document(widget.actualUid)
                                .collection('allProjects')
                                .document(imageName)
                                .setData(({

                              'url':document['url'],
                              'date':document['date'],
                              'owner':document['owner']

                            }));
                          }
                      ),
                    );
                  }).toList(),
                );
            }
          },
        ),
      ),
    );
  }
}

