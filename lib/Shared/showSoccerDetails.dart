import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socomtronics/Loadings/loading1.dart';
import 'package:socomtronics/MpesaPayment/checkout.dart';
import "package:http/http.dart" as http;
import 'package:socomtronics/Shared/pay.dart';
import 'dart:math';
import 'package:socomtronics/SignIn/signIn.dart';

class ShowSoccerDetails extends StatefulWidget {
  final DocumentSnapshot post;

  ShowSoccerDetails({key, this.post}) : super(key: key);
  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowSoccerDetails> {
  var _site;
  var url = "";
  final FirebaseFirestore ff = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Map<String, dynamic> _state = {
    'hasError': false,
    'message': "No error",
  };

  Future<QuerySnapshot> getEventData() {
    return ff.collection("Events").get();
  }

  Future<Map<String, dynamic>> saveTickets(
      String eventId, String ticket, String price1) async {
    try {
      final uids = auth.currentUser.uid.toString();
      await ff.collection('userTicketsId').doc(uids).collection('tickets').add({
        'eventId': eventId,
        'ticket': ticket,
        'price': price1,
        // 'userId':
      });

      _state['hasError'] = false;
      _state['message'] = "Order was added successfully.";

      return _state;
    } catch (e) {
      _state['hasError'] = true;
      _state['message'] = e.toString().split(']')[1];

      return _state;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white
          // gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //   Colors.purple[800],
          //   Colors.green[800],
          // ])
          ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black45,
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: GestureDetector(
                onTap: () {
                  // navigateSoccaerContent(
                  //     snapshot.data.docs[index], context);
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Container(
                    height: 200,
                    // width: Get.width * .1,
                    // margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                ExtendedImage.network(
                                  widget.post.data()["logo"],
                                  height: 100,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    widget.post.data()["name"],
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('vs',
                                  style: TextStyle(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
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
                                  widget.post.data()["logoA"],
                                  height: 100,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    widget.post.data()["nameA"],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.post.data()["Status"],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              widget.post.data()["name"],
                            )
                          ],
                        ),
                        Text(
                          widget.post.data()["pitch"],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () {


                  try {
                  String uids = auth.currentUser.uid;

                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text('Choose Category'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Column(
                                children: [
                                  Card(
                                    color: Colors.green,
                                    child: ExpansionTile(
                                        title: Text(
                                          "VIP A",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                var req = BraintreeDropInRequest(
                                                    tokenizationKey:
                                                        'sandbox_6m4qt2h4_xgp6d5mzjh5qsvxr',
                                                    collectDeviceData: true,
                                                    paypalRequest:
                                                        BraintreePayPalRequest(
                                                            amount: '20.00',
                                                            displayName:
                                                                'Kazen'),
                                                    cardEnabled: true);

                                                BraintreeDropInResult res =
                                                    await BraintreeDropIn.start(
                                                        req);

                                                if (res != null) {

                                                  return showCupertinoDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return FutureBuilder(
                                                            future:
                                                                getEventData(),
                                                            builder: (context,
                                                                AsyncSnapshot<
                                                                        QuerySnapshot>
                                                                    snapshot) {


                                                                      try{
                                                                         if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .done) {
                                                                return ListView.builder(
                                                                  itemCount: snapshot.data.docs.length,
                                                                  itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        index) {
                                                                  String
                                                                      eventId =
                                                                      snapshot
                                                                          .data
                                                                          .docs[
                                                                              index]
                                                                          .id;
                                                                  // String ticket =
                                                                  //     snapshot.data.docs[index].data()['name'];
                                                                  String price =
                                                                      snapshot.data.docs[index].data()['price'];
                                                                  // String img =
                                                                  //     snapshot.data.docs[index].data()['imgURL'];
                                                                  

                                                                  const _chars =
                                                                      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                                                  Random _rnd =
                                                                      Random();

                                                                  String getRandomString(
                                                                          int
                                                                              length) =>
                                                                      String.fromCharCodes(Iterable.generate(
                                                                          length,
                                                                          (_) =>
                                                                              _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

                                                                  

                                                                  return CupertinoAlertDialog(
                                                                    title: Text(
                                                                        'Successfully Paid'),
                                                                    actions: <
                                                                        Widget>[
                                                                      CupertinoDialogAction(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Divider(),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Center(
                                                                                child: Text(
                                                                              "Ok",
                                                                              style: TextStyle(fontSize: 30),
                                                                            )),
                                                                          ],
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          {
                                                                            // foods.doc(foodId);
                                                                            try {
                                                                              String ud = auth.currentUser.uid.toString();
                                                                              print(ud);

                                                                              // Map<String, dynamic> o =
                                                                              await saveTickets(eventId, getRandomString(10), price);

                                                                              Fluttertoast.showToast(msg: "Ticket Bought", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.black, fontSize: 16.0);
                                                                            } catch (e) {
                                                                              showCupertinoDialog(
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    return CupertinoAlertDialog(
                                                                                      title: Text('Please login to purchase this ,Thanks!'),
                                                                                      actions: <Widget>[
                                                                                        CupertinoDialogAction(
                                                                                          child: Text('Ok, Loging In'),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (contex) => SignIn()));
                                                                                          },
                                                                                        ),
                                                                                        CupertinoDialogAction(
                                                                                          child: Text('Cancel'),
                                                                                          onPressed: () {
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                        )
                                                                                      ],
                                                                                    );
                                                                                  });
                                                                            }
                                                                          }
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                              } else {
                                                                return Loading1();
                                                              }

                                                                      }catch(e){
                                                                      return Loading1();
                                                                      }
                                                             
                                                            });
                                                      });

                                                  print(res.paymentMethodNonce
                                                      .description);
                                                  print(res.paymentMethodNonce
                                                      .nonce);

                                                  // final http.Response responce =
                                                  //     await http.post(Uri.tryParse(
                                                  //         '$url?payment_method_nonce=${res.paymentMethodNonce.nonce}&device_data=${res.deviceData}'));

                                                  // final payres =
                                                  //     jsonDecode(responce.body);
                                                  // if (payres['result'] ==
                                                  //     'success') {
                                                  //   return showCupertinoDialog(
                                                  //       context: context,
                                                  //       builder: (context) {
                                                  //         return CupertinoAlertDialog(
                                                  //           title: Text(
                                                  //               'Successfully Paid'),
                                                  //           actions: <Widget>[
                                                  //             CupertinoDialogAction(
                                                  //               child: Column(
                                                  //                 children: [
                                                  //                   SizedBox(
                                                  //                     height:
                                                  //                         20,
                                                  //                   ),
                                                  //                   Divider(),
                                                  //                   SizedBox(
                                                  //                     height:
                                                  //                         20,
                                                  //                   ),
                                                  //                   Center(
                                                  //                       child:
                                                  //                           Text(
                                                  //                     "Ok",
                                                  //                     style: TextStyle(
                                                  //                         fontSize:
                                                  //                             30),
                                                  //                   )),
                                                  //                 ],
                                                  //               ),
                                                  //               onPressed: () {
                                                  //                 Navigator.pop(
                                                  //                     context);
                                                  //               },
                                                  //             )
                                                  //           ],
                                                  //         );
                                                  //       });
                                                  // }else{
                                                  //   return showCupertinoDialog(
                                                  //       context: context,
                                                  //       builder: (context) {
                                                  //         return CupertinoAlertDialog(
                                                  //           title: Text(
                                                  //               'Transaction Declied, please check your balance and try again!'),
                                                  //           actions: <Widget>[
                                                  //             CupertinoDialogAction(
                                                  //               child: Column(
                                                  //                 children: [
                                                  //                   SizedBox(
                                                  //                     height:
                                                  //                         20,
                                                  //                   ),
                                                  //                   Divider(),
                                                  //                   SizedBox(
                                                  //                     height:
                                                  //                         20,
                                                  //                   ),
                                                  //                   Center(
                                                  //                       child:
                                                  //                           Text(
                                                  //                     "Ok",
                                                  //                     style: TextStyle(
                                                  //                         fontSize:
                                                  //                             30),
                                                  //                   )),
                                                  //                 ],
                                                  //               ),
                                                  //               onPressed: () {
                                                  //                 Navigator.pop(
                                                  //                     context);
                                                  //               },
                                                  //             )
                                                  //           ],
                                                  //         );
                                                  //       });

                                                  // }
                                                } else {
                                                  return showCupertinoDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CupertinoAlertDialog(
                                                          title: Text(
                                                              'Transaction Declied, please check your balance and try again!'),
                                                          actions: <Widget>[
                                                            CupertinoDialogAction(
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Divider(),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Center(
                                                                      child:
                                                                          Text(
                                                                    "Ok",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            30),
                                                                  )),
                                                                ],
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      });
                                                }
                                              },
                                              child: Text("Buy"))
                                        ],
                                        trailing: Text(
                                          "Tzs 30000",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white),
                                        ),
                                        leading: Icon(Icons.money)),
                                  ),
                                  Card(
                                    color: Colors.blue,
                                    child: ExpansionTile(
                                      title: Text(
                                        "VIP B",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CheckOut()));
                                            },
                                            child: Text("Buy"))
                                      ],
                                      leading: Icon(Icons.money),
                                      trailing: Text(
                                        "Tzs 15000",
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color: Colors.red,
                                    child: ExpansionTile(
                                      // onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CheckOut())),
                                      title: Text(
                                        "Normal Class",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      leading: Icon(Icons.money),
                                      trailing: Text(
                                        "Tzs 7000",
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),

                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CheckOut()));
                                            },
                                            child: Text("pay"))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                      child: Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 30),
                                  )),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                } catch (e) {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text('Please login to purchase this ,Thanks!'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text('Ok, Loging In'),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (contex) => SignIn()));
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                }

                  
                },
                child: Text(
                  "Buy Ticket",
                )),
          ),
        ]),
      ),
    );
  }
}
