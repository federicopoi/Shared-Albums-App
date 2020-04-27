import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:shared_albums/MyPets/shareScreen.dart';


import 'ProfileScreen.dart';

class CustomCard extends StatefulWidget {
  CustomCard({@required this.title, this.uid, this.completeName});

  final title;
  final completeName;
  final String uid;

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: (){
              /** Push a new page while passing data to it */
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        title: widget.title,
                        uid: widget.uid,
                        completeName: widget.completeName,

                      )));
            },
            child: Container(
                width: 500,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xff272727),

                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),

                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(widget.title, style: TextStyle(fontSize: 30,  color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Monserrat'),),
                )),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xff272727),

            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[

              GestureDetector(
                onTap: (){
                  /** Push a new page while passing data to it */
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShareScreen(
                            title: widget.title,
                            uid: widget.uid,

                          )));
                },
                child: Container(
                  height: 100,
                  width: 50,
                  child: Icon(Icons.share, color: Colors.white,),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}