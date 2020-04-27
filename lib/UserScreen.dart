import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key key, this.completeName, this.email}) : super(key: key); //update this to include the uid in the constructor
  final String completeName;
  final String email; //include this
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xff121212),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Text('User Information', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),),
              SizedBox(height: 30,),

              Align(
                alignment: Alignment.centerLeft,
                child: SelectableText('Email: ${widget.email}', style: TextStyle(color: Colors.white ,fontSize: 20),),
              ),
              SizedBox(height: 25,),

              Align(
                alignment: Alignment.centerLeft,
                child: SelectableText('Name: ${widget.completeName}', style: TextStyle(color: Colors.white ,fontSize: 20),),
              ),
              SizedBox(height: 30,),
              RaisedButton(
                color: Colors.white,
                child: Text('LogOut', style: TextStyle(fontFamily: 'Monserrat', fontWeight: FontWeight.bold),),
                onPressed: ()async{
                  FirebaseAuth.instance.signOut();

                  Navigator.pushReplacementNamed(context, "/login");
                },
              ),
              SizedBox(height: 10,),
              RaisedButton(
                color: Colors.redAccent,
                child: Text('Delete Account', style: TextStyle(fontFamily: 'Monserrat', fontWeight: FontWeight.bold)),
                onPressed: ()async{
                },
              ),
            ],
          )
        ),
      ),
    );
  }


}

