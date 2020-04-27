import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageDetail extends StatefulWidget {
  final url;
  final id;
  final title;
  final uid;
  final completeName;
  final date;
  ImageDetail({Key key, this.url, this.id, this.title, this.uid, this.completeName, this.date}) : super(key: key); //update this to include the uid in the constructor
  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {



  @override
  Widget build(BuildContext context) {


    return Scaffold(backgroundColor: Color(0xff121212),
      appBar: AppBar(
        actions: <Widget>[
          RaisedButton(
            elevation: 0,
            color: Colors.blue,
            child: Text('Delete', style: TextStyle(fontWeight: FontWeight.bold),),
            onPressed: () async{

              Firestore.instance.collection("users").document(widget.uid)
                  .collection("ownProjects")
                  .document(widget.title)
                  .collection(widget.title)
                  .document(widget.id)
                  .delete();

              Firestore.instance.collection("users").document(widget.uid)
                  .collection("allProjects")
                  .document(widget.id)
                  .delete();

              FirebaseStorage().ref().child(
                  '/users/${widget.uid}/ownProjects/${widget.title}/${widget.title}/${widget.id}.jpg').delete();

              Navigator.pop(context);

            },
          ),
          RaisedButton(
            elevation: 0,
            color: Colors.blue,
            child: Text('Download', style: TextStyle(fontWeight: FontWeight.bold),),
            onPressed: () async{


              if (await canLaunch(widget.url)) {
                await launch(widget.url);
              } else {
                throw 'Could not launch ${widget.url}';
              }

            },
          ),
          RaisedButton(
            elevation: 0,
            color: Colors.blue,
            child: Text('Details', style: TextStyle(fontWeight: FontWeight.bold),),
            onPressed: (){

            },
          ),
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child:
                      ClipRect(

                        child: Align(
                            alignment: Alignment.center,
                            heightFactor: 1,
                            widthFactor: 1,
                            child: PhotoView(
                              backgroundDecoration: BoxDecoration(color: Color(0xff121212)),
                              loadingBuilder: (context, event) => Center(
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    value: event == null
                                        ? 0
                                        : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                                  ),
                                ),
                              ),

                              imageProvider:  CachedNetworkImageProvider(


                                  '${widget.url}'
                              ),
                            )
                        ),

                      ),


            ),
            Text('${widget.completeName}', style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Monserrat'),),
            SizedBox(
              height: 20,
            )


          ],
        )
      ),

    );
  }


}

