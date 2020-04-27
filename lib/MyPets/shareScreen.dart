import 'package:flutter/material.dart';

class ShareScreen extends StatefulWidget {
  ShareScreen({Key key, this.uid, this.title}) : super(key: key); //update this to include the uid in the constructor

  final String uid;
  final String title;
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xff121212),
      appBar: AppBar(

      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Title', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),),
            SizedBox(
              height: 10,
            ),
            SelectableText(widget.title, style: TextStyle(color: Colors.white ,fontSize: 20),),
            SizedBox(
              height: 20,
            ),
            Text('ID', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),),
            SizedBox(
              height: 10,
            ),
            SelectableText(widget.uid,style: TextStyle(color: Colors.white, fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
