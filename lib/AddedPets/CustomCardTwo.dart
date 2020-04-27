import 'package:flutter/material.dart';
import 'ProfileScreen2.dart';

class CustomCard2 extends StatefulWidget {
  CustomCard2({@required this.title, this.uid, this.completeName, this.actualUid});

  final title;
  final String completeName;
  final actualUid;


  final String uid;

  @override
  _CustomCard2State createState() => _CustomCard2State();
}

class _CustomCard2State extends State<CustomCard2> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        /** Push a new page while passing data to it */
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen2(
                    title: widget.title,
                    uid: widget.uid,
                    completeName: widget.completeName,
                    actualUid: widget.actualUid

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
            child: Text(widget.title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
          )
      ),
    );
  }
}