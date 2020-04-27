import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


import '../MyPets/imageDetail.dart';
import '../imageDetailAllScreen.dart';

class AllPicturesScreen extends StatefulWidget {
  AllPicturesScreen({Key key, this.title, this.uid, this.completeName}) : super(key: key); //update this to include the uid in the constructor

  final title;
  final String uid;
  final String completeName;
  @override
  _AllPicturesScreenState createState() => _AllPicturesScreenState();
}

class _AllPicturesScreenState extends State<AllPicturesScreen> with AutomaticKeepAliveClientMixin<AllPicturesScreen>{



  // LAZY LOADING





  // OTHER

  @override
  Widget build(BuildContext context) {





    Widget pictures = new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users')
            .document(widget.uid)
            .collection('allProjects')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return new Text(
                'Error in receiving pictures: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: new Text('Not connected to the Stream or null', style: TextStyle(color: Colors.white),));

            case ConnectionState.waiting:
              return Center(child: new CircularProgressIndicator());

            case ConnectionState.active:
              print("Stream has started but not finished");

              var totalPhotosCount = 0;
              List<DocumentSnapshot> pictures;

              if (snapshot.hasData) {
                pictures = snapshot.data.documents;
                totalPhotosCount = pictures.length;

                if (totalPhotosCount > 0) {

                  return new GridView.builder(
                      itemCount: totalPhotosCount,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      addAutomaticKeepAlives: true,
                      primary: false,
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Card(color: Color(0xff272727),

                            child: GestureDetector(
                              onTap: (){



                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageDetailAllScreen(
                                          date: pictures[index].data['date'],
                                          url: pictures[index].data['url'],
                                          completeName: pictures[index].data['owner'],
                                          id: pictures[index].documentID,
                                          title: widget.title,
                                          uid: widget.uid,
                                        )));
                              },
                              child: Container(
                                color: Color(0xff272727),

                                width: 400, height: 400,alignment: Alignment.center,

                                child: ClipRect(

                                  child: Align(

                                      alignment: Alignment.center,

                                      child: new CachedNetworkImage(




                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,

                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                        new CircularProgressIndicator(),
                                        imageUrl:
                                        pictures[index].data['url'],
                                      )
                                  ),

                                ),

                              ),
                            ),

                          ),
                        );
                      });


                }
              }



              return new Center(



                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),


                      new Text(
                        "Your pictures will be here",
                        style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Text(
                        "Once you uploaded a \npicture, wait around 20 seconds",
                        style: TextStyle(color: Colors.white, fontSize: 20, ),textAlign: TextAlign.center,

                      ),
                    ],
                  ));

            case ConnectionState.done:
              return new Text('Streaming is done');
          }

          return Container(
            child: new Text("No pictures found."),
          );
        });

    return Scaffold(backgroundColor: Color(0xff121212),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: pictures
          ),
        )

    );
  }
  @override
  bool get wantKeepAlive => true;

}


