import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main/home.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);


  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;



  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
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
                    key: _registerFormKey,
                    child: Column(
                      children: <Widget>[
                        Text('Register',
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Monserrat',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(

                          decoration: new InputDecoration(

                            labelText: "First Name",
                            hintText: 'John',

                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(


                              ),
                            ),
                            //fillColor: Colors.green
                          ),
                          controller: firstNameInputController,
                          validator: (value) {
                            if (value.length < 3) {
                              return "Please enter a valid first name.";
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(

                            decoration: new InputDecoration(

                              labelText: "Last Name",
                              hintText: 'Doe',

                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(


                                ),
                              ),
                              //fillColor: Colors.green
                            ),
                            controller: lastNameInputController,
                            validator: (value) {
                              if (value.length < 3) {
                                return "Please enter a valid last name.";
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(

                          decoration: new InputDecoration(

                            labelText: "Email",
                            hintText: 'john.doe@gmail.com',

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
                          height: 10,
                        ),
                        TextFormField(

                          decoration: new InputDecoration(

                            labelText: "Password",
                            hintText: "********",

                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(


                              ),
                            ),
                            //fillColor: Colors.green
                          ),
                          controller: pwdInputController,
                          obscureText: true,
                          validator: pwdValidator,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(

                          decoration: new InputDecoration(

                            labelText: "Confirm Password",
                            hintText: "********",

                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(


                              ),
                            ),
                            //fillColor: Colors.green
                          ),
                          controller: confirmPwdInputController,
                          obscureText: true,
                          validator: pwdValidator,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(

                          child: Text("Register"),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25.0),

                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            if (_registerFormKey.currentState.validate()) {
                              if (pwdInputController.text ==
                                  confirmPwdInputController.text) {
                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                    .then((currentUser) => Firestore.instance
                                    .collection("users")
                                    .document(currentUser.uid)
                                    .setData({
                                  "uid": currentUser.uid,
                                  "fname": firstNameInputController.text,
                                  "surname": lastNameInputController.text,
                                  "email": emailInputController.text,
                                })
                                    .then((result) => {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(
                                            title: 'My Pets',
                                            uid: currentUser.uid,
                                          )),
                                          (_) => false),
                                  firstNameInputController.clear(),
                                  lastNameInputController.clear(),
                                  emailInputController.clear(),
                                  pwdInputController.clear(),
                                  confirmPwdInputController.clear()
                                })
                                    .catchError((err) => print(err)))
                                    .catchError((err) => print(err));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text("The passwords do not match"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Already have an account?"),
                            FlatButton(
                              child: Text("Login here!", style: TextStyle(color: Colors.blue),),
                              onPressed: () {
                                Navigator.pop(context);
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