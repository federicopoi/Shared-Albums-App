import 'registerPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(

              child: SingleChildScrollView(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: <Widget>[
                        Text('Welcome Back!',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Monserrat',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(

                          decoration: new InputDecoration(

                            labelText: "Email",

                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(


                              ),
                            ),
                            //fillColor: Colors.green
                          ),

                          controller: emailInputController,
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          decoration: new InputDecoration(
                            labelText: "Password",
                            fillColor: Colors.red,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                            //fillColor: Colors.green
                          ),
                          controller: pwdInputController,

                          validator: pwdValidator,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(

                          child: Text("Login", style: TextStyle(fontSize: 15),),

                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),

                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            if (_loginFormKey.currentState.validate()) {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: pwdInputController.text)
                                  .then((currentUser) => Firestore.instance
                                  .collection("users")
                                  .document(currentUser.uid)
                                  .get()
                                  .then((DocumentSnapshot result) =>
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(
                                            title: 'My Pets',
                                            uid: currentUser.uid,
                                          )))
                              )
                                  .catchError((err) => print(err)))
                                  .catchError((err) => print(err));
                            }
                          },
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("New User?"),

                            FlatButton(
                              child: Text("Create an account.", style: TextStyle(color: Colors.blue),),
                              onPressed: () {
                                Navigator.pushNamed(context, "/register");
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ))),
        ));
  }
}