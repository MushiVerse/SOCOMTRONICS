import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:socomtronics/Loadings/loading.dart';
import 'package:socomtronics/Loadings/loading1.dart';
import 'package:socomtronics/Loadings/loading2.dart';
import 'package:socomtronics/MpesaPayment/mpesa.dart';
import 'package:socomtronics/Shared/showConcertDetails.dart';

class Concerts extends StatefulWidget {
  @override
  _ConcertsState createState() => _ConcertsState();
}

class _ConcertsState extends State<Concerts> {
  FirebaseFirestore ff = FirebaseFirestore.instance;

   navigateSoccaerContent(DocumentSnapshot post, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ShowConcertDetails(
              poost: post,
            )));
  }

  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              // image: DecorationImage(
              //     image: AssetImage("lib/Assets/musicpic2.jpg"),
              //     fit: BoxFit.cover)
                  ),
        ),

        FutureBuilder(
              future: ff.collection("Events").get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, i) {
            String name = snapshot.data.docs[i].data()['name'];
            DateTime time = snapshot.data.docs[i].data()['time'].toDate();
            String tim = time.toString();
            String status = snapshot.data.docs[i].data()["status"];
            String venue = snapshot.data.docs[i].data()["venue"];
            String pic = snapshot.data.docs[i].data()['pic'];
            String desc = snapshot.data.docs[i].data()['desc'];

            print(name);

            return ListTile(
              onTap: (){
                navigateSoccaerContent(
                                              snapshot.data.docs[i], context);
              },
              title: Padding(
                padding: EdgeInsets.all(0),
                child: new Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green[800]),
                      borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.all(2.0),
                  margin: EdgeInsets.all(0.0),
                  child: Column(
                    children: <Widget>[
                      ExpansionTile(
                        leading:  Image.network(pic),
                        title: Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(desc,
                        style: TextStyle(
                           color: Colors.white,
                        ),
                        ),
                        children: [
                          ListTile(
                            title: Text(tim,
                            style: TextStyle(
                             color: Colors.white
                            ),
                            ),
                          )
                        ],
                      ),
                      ExtendedImage.network(
                                                      
                        pic
                        ),
                      // Padding(
                      //     child: Image.network(pic.picha1),
                      //     padding: EdgeInsets.only(bottom: 0.0)),
                      SizedBox(
                        height: 0,
                      ),
                      Row(mainAxisSize: MainAxisSize.min, children: <
                          Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 26.0, vertical: 16.0),
                            child: IconButton(
                                color: Colors.blue,
                                splashColor: Colors.black,
                                icon: Icon(Icons.favorite),
                                onPressed: () {})),
                       
                     
                      ]),
                      Row(
                        children: <Widget>[
                          //         ListTile(
                          //   leading: Icon(Icons.arrow_drop_down_circle),
                          //   title:  Text(
                          //     tim
                          //     ),
                          //   subtitle: Text(
                          //     '',
                          //      semanticsLabel: venue,
                          //     style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          //   ),
                          // ),
                          

                          Flexible(
                             child: new Text(
                                '@ $venue (Venue)',
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                             )

                             ),

                          Text(" | "),
                          Padding(
                              child: Text(
                                "muda",
                                style: new TextStyle(
                                    fontStyle: FontStyle.italic),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                              padding: EdgeInsets.all(1.0)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
                } else {
        return Loading2();
                }
              })

        // Column(
        //   children: [
        //     SizedBox(
        //       height: 80,
        //     ),
        //     FutureBuilder(

        //       future: getConcertData(),
        //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //         if(snapshot.connectionState == ConnectionState.done){

        //           return ListView.builder(
        //           itemCount: snapshot.data.docs.length,
        //           itemBuilder: (context, i) {

        //           String name = snapshot.data.docs[i].data()['name'];
        //           DateTime time = snapshot.data.docs[i].data()['time'].toDate();
        //           String tim = time.toString();

        //           String status = snapshot.data.docs[i].data()["status"];
        //           String venue = snapshot.data.docs[i].data()["venue"];
        //           String pic = snapshot.data.docs[i].data()['pic'];
        //           String desc = snapshot.data.docs[i].data()['desc'];
        //           return GestureDetector(
        //             onTap: () => Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (_) => ShowConcertDetails(),
        //                 )),
        //             child: new Card(
        //               margin: EdgeInsets.all(0),
        //               clipBehavior: Clip.antiAlias,
        //               elevation: 0.0,
        //               child: new Container(
        //                 decoration: BoxDecoration(
        //                     border: Border.all(color: Colors.brown),
        //                     borderRadius:
        //                         BorderRadius.all(Radius.circular(10))),
        //                 padding: EdgeInsets.all(2.0),
        //                 margin: EdgeInsets.all(0.0),
        //                 child: Column(
        //                   children: <Widget>[
        //                     ExpansionTile(
        //                       leading: Icon(Icons.person),
        //                       title: Text(
        //                         name,
        //                         style: TextStyle(
        //                             fontSize: 20, fontWeight: FontWeight.bold),
        //                       ),
        //                       subtitle: Text(tim),
        //                       children: [
        //                         ListTile(
        //                           title: Text(desc),
        //                         )
        //                       ],
        //                     ),
        //                     Image.network(pic),
        //                     // Padding(
        //                     //     child: Image.network(pic.picha1),
        //                     //     padding: EdgeInsets.only(bottom: 0.0)),
        //                     SizedBox(
        //                       height: 0,
        //                     ),

        //                     Row(
        //                       children: <Widget>[
        //                         Text(" | "),
        //                         Padding(
        //                             child: Text(
        //                               tim,
        //                               style: new TextStyle(
        //                                   fontStyle: FontStyle.italic),
        //                               overflow: TextOverflow.ellipsis,
        //                               textAlign: TextAlign.left,
        //                             ),
        //                             padding: EdgeInsets.all(1.0)),
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           );
        //         });

        //         }

        //       },
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
