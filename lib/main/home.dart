
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_albums/AddedPets/AddedPetsScreen.dart';
import 'package:shared_albums/MyPets/MyPetsScreen.dart';

import '../UserScreen.dart';
import 'AllPicturesScreen.dart';



class HomePage extends StatefulWidget {

  HomePage({Key key, this.title, this.uid}) : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController taskTitleInputController2;
  TextEditingController taskTitleInputController;
  TextEditingController taskTitleInputController3;

  FirebaseUser currentUser;
  String completeName;
  String email;

  @override
  initState() {
    taskTitleInputController3 = new TextEditingController();
    taskTitleInputController2 = new TextEditingController();
    taskTitleInputController = new TextEditingController();

    this.getCurrentUser();
    super.initState();

  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();

    // Get current user's name
    var user = await FirebaseAuth.instance.currentUser();
    var userQuery = Firestore.instance.collection('users').where('email', isEqualTo: user.email).limit(1);
    userQuery.getDocuments().then((data){
      if (data.documents.length > 0){
        setState(() {
          completeName = data.documents[0].data['fname'] + " " + data.documents[0].data['surname'];
          email = data.documents[0].data['email'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
        length: 4,
        child: Scaffold(backgroundColor: Color(0xff121212),
          appBar: AppBar(
            backgroundColor: Color(0xff121212),
            elevation: 0,
            flexibleSpace: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                TabBar(
                  isScrollable: true,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,


                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xff272727)),
                    tabs: [
                      Tab(

                        child: Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("ALL"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("MY ALBUMS"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("ADDED ALBUMS"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          width: 30,
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.account_circle),
                          ),
                        ),
                      ),
                    ]),
              ],

            ),
          ),
          body: TabBarView(children: [
            AllPicturesScreen(uid: widget.uid,),
            MyPetsScreen(uid: widget.uid, completeName: completeName,),
            AddedPetsScreen(uid: widget.uid, completeName: completeName,),
            UserScreen(completeName: completeName, email: email,)
          ]
          ),

        )
    );
  }

}