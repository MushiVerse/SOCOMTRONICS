// import 'package:flutter/material.dart';
// import 'package:multipurposestadiumms/SoccerViewPages/api_maneger.dart';
// import 'package:multipurposestadiumms/SoccerViewPages/listBody.dart';

// class Soccer extends StatefulWidget {
//   @override
//   _SoccerState createState() => _SoccerState();
// }

// class _SoccerState extends State<Soccer> {
//   @override
//   Widget build(BuildContext context) {
//     // return Scaffold(
//     //   backgroundColor: Color(0xFFFAFAFA),
//     //   appBar: AppBar(
//     //     backgroundColor: Color(0xFFFAFAFA),
//     //     elevation: 0.0,
//     //     title: Text(
//     //       "SOCCERBOARD",
//     //       style: TextStyle(color: Colors.black),
//     //     ),
//     //     centerTitle: true,
//     //   ),
//     //   //now we have finished the api service let's call it
//     //   //Now befo re we create Our layout let's create our API service
//     //   body: FutureBuilder(
//     //     future: SoccerApi()
//     //         .getAllMatches(), //Here we will call our getData() method,
//     //     builder: (context, snapshot) {
//     //       //the future builder is very intersting to use when you work with api

//     //       try {
//     //         print((snapshot.data).length);
//     //         return pagebody(snapshot.data);
//     //       } catch (e) {
//     //         print('error isss : $e');
//     //       }
//     //       if (snapshot.hasData) {
//     //         print((snapshot.data).length);
//     //         print(snapshot.data.toString());
//     //         print(snapshot.data);
//     //         return pagebody(snapshot.data);
//     //       } else {
//     //         return Center(
//     //           child: CircularProgressIndicator(
//     //             backgroundColor: Colors.black,
//     //             semanticsValue: "hello",
//     //             semanticsLabel: 'helll',
//     //             strokeWidth: 10,
//     //           ),
//     //         );
//     //       }
//     //     }, // here we will buil the app layout
//     //   ),
//     // );
//     return Stack(
//           children:<Widget>[
//              Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           image: DecorationImage(
//             image: AssetImage("lib/Assets/pic4.jpg"),
//             fit: BoxFit.cover
//             )
//           //

//         ),
//         child: FutureBuilder(
//          future: SoccerApi()
//             .getAllMatches(), //Here we will call our getData() method,
//         builder: (context, snapshot) {
//           //the future builder is very intersting to use when you work with api
//           if (snapshot.hasData) {
//             print((snapshot.data).length);
//             return pagebody(snapshot.data);
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         }, // here we will buil the app layout
//       ),
//     )

//           ]

//     );
//   }
// }

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:socomtronics/Loadings/loading.dart';
import 'package:socomtronics/Loadings/loading1.dart';
import 'package:socomtronics/Shared/showSoccerDetails.dart';

class Soccer extends StatelessWidget {
  Soccer({Key key}) : super(key: key);

  final FirebaseFirestore foods = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<QuerySnapshot> getMatchData() {
    return foods.collection("teams").get();
  }



  navigateSoccaerContent(DocumentSnapshot post, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ShowSoccerDetails(
              post: post,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            //  gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [Colors.purple[800],Colors.green[800], ]),
         
      image: DecorationImage(
        image: AssetImage("lib/Assets/pic3.jpg"),
        fit: BoxFit.cover
        ),

            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tanzania Premier League',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: Get.width,
                  child: FutureBuilder(
                      future: getMatchData(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done) {
                              
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, int index) {
                              String name = snapshot.data.docs[index]
                                  .data()['name'];
                              String logo = snapshot.data.docs[index]
                                  .data()['logo'];
                              String nameA = snapshot.data.docs[index]
                                  .data()['nameA'];
                              String logoA = snapshot.data.docs[index]
                                  .data()['logoA'];
                              // Timestamp time = snapshot.data.docs[index]
                              //     .data()['time'];
                              String status = snapshot.data.docs[index]
                                  .data()['Status'];

                              DateTime time = (snapshot.data.docs[index]
                                      .data()['time'])
                                  .toDate();

                              String tim = time.toString();
                              DateTime.parse(time.toString());

                              // final ResponseData match =
                              //     controller.responseData[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                child: GestureDetector(
                                  onTap: () {
                                    navigateSoccaerContent(
                                        snapshot.data.docs[index], context);
                                  },
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Container(
                                      height: 140,
                                      // width: Get.width * .1,
                                      // margin: EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  ExtendedImage.network(
                                                    logo,
                                                    height: 70,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 8),
                                                    child: Text(name,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                child: Text('vs',
                                                    style: TextStyle(
                                                        fontSize: 45,
                                                        fontWeight:
                                                            FontWeight
                                                                .bold,
                                                        color: Colors
                                                            .black)),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.all(8.0),
                                              //   child: Text(
                                              //       '${2} : ${match.goals.away ?? 0}',
                                              //       style: TextStyle(
                                              //           fontSize: 45,
                                              //           fontWeight: FontWeight.bold)),
                                              // ),
                                              Column(
                                                children: [
                                                  ExtendedImage.network(
                                                    logoA,
                                                    height: 70,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 8),
                                                    child: Text(nameA,
                                                     style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                status,
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text(
                                                tim,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Loading1();
                        }
                      }),
                ),
              )
            ],
          ),
        );
  }
}
