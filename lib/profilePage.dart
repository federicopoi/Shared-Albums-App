import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {

  final title;
  ProfilePage({Key key, this.title, this.uid, this.groupTitle, this.completeName}) : super(key: key); //update this to include the uid in the constructor


  final String uid;
  final String groupTitle;
  final String completeName;


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseUser currentUser;

  File _selectedPicture;

  bool keepSubmiting = false;

  @override
  initState() {


    this.getCurrentUser();

    actionPressed();



    super.initState();
  }
  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();


  }
  submitButton() async{
    if (_selectedPicture != null) {


      var imageName = Uuid().v1();

      var imagePath = '/users/${currentUser.uid}/ownProjects/${widget.title}/${widget.title}/$imageName.jpg';


      final StorageReference storageReference = FirebaseStorage().ref().child(
          imagePath);

      final StorageUploadTask uploadTask = storageReference.putFile(
          _selectedPicture);

      var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      var url = downUrl.toString();

      Firestore.instance.collection('users')
          .document(widget.uid)
          .collection('ownProjects')
          .document(widget.title)
          .collection(widget.title)
          .document(imageName)
          .setData(({

        'url':url,
        'date':DateTime.now(),
        'owner':"Uploaded By ${widget.completeName}"

      }));

      Firestore.instance.collection('users')
          .document(widget.uid)
          .collection('allProjects')
          .document(imageName)
          .setData(({

        'url':url,
        'date':DateTime.now(),
        'owner':"Uploaded By ${widget.completeName}"

      }));









    }


  }




  @override
  Widget build(BuildContext context) {
    setState(() {
      obternerPreferencias();
    });
    return Scaffold(backgroundColor: Color(0xff121212),
      appBar: AppBar(

        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Upload Image to ' + widget.title),

      ),
      body: Center(
        child: Padding(padding: EdgeInsets.all(50),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff272727)
                ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        tristate: false,
                        value: keepSubmiting,
                        onChanged: (bool value) {
                          setState(() {
                            keepSubmiting = value;
                            guardarPreferencias();
                          });
                        },
                      ),
                      Text('Keep Uploading', style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Monserrat'),)
                    ],
                  ),
                ),
              SizedBox(
                height: 10,
              ),

              if(_selectedPicture != null)
                Container(color: Color(0xff272727),
                    width: 400, height: 400,alignment: Alignment.center,
                    child:
                          ClipRect(

                            child: Align(
                                alignment: Alignment.center,
                                heightFactor: 1,
                                widthFactor: 1,
                                child: Image.file(_selectedPicture)

                          ),

                          )

                ),

              SizedBox(
                height: 20,
              ),

              if(_selectedPicture != null)
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        submitButton();
                        if(keepSubmiting == false){
                          Navigator.of(context).popUntil((route) => route.isFirst);

                        }else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(

                                    title: widget.title,
                                    uid: widget.uid,
                                    completeName: widget.completeName,


                                  )));
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff272727),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), topLeft: Radius.circular(20))
                          ),
                          width: 150,
                          height: 60,
                          child: Center(
                            child: Text(
                              'Submit', style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: () async{
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery);

                        setState(() {
                          _selectedPicture = image;

                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff272727),
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), topRight: Radius.circular(20))
                          ),
                          width: 150,
                          height: 60,
                          child: Center(
                            child: Text(
                              'Upload Other', style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                      ),
                    )
                  ],
                )


            ],
          ),
        ),
      ),


    );
  }
  Future obternerPreferencias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      keepSubmiting = (prefs.getBool('keepSubmiting') ?? false);

    });
  }

  guardarPreferencias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('keepSubmiting', keepSubmiting);

  }
  void actionPressed() async{
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery);

    setState(() {
      _selectedPicture = image;

    });
  }
}