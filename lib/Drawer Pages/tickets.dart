import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socomtronics/Drawer%20Pages/qrCode.dart';
import 'package:socomtronics/Loadings/loading.dart';
import 'package:socomtronics/Loadings/loading1.dart';
import 'package:socomtronics/SignIn/signIn.dart';

class Tickets extends StatefulWidget {
  const Tickets({Key key}) : super(key: key);

  @override
  _TicketsState createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore ff = FirebaseFirestore.instance;

  Map<String, dynamic> _state = {
    'hasError': false,
    'message': "No error",
  };

  Stream<QuerySnapshot> getTickets() async* {
    final uids = auth.currentUser.uid;
    print(uids);
    yield* FirebaseFirestore.instance
        .collection("userTicketsId")
        .doc(uids)
        .collection('tickets')
        .snapshots();
  }

  Future<Map<String, dynamic>> saveTicketorder(String foodId) async {
    try {
      ff.collection('Ticketcarts').add({
        'foodId': foodId,
        'userId': auth.currentUser.uid.toString(),
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

  navigateSoccaerContent(DocumentSnapshot post, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QrCode(
              post: post,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final uids = auth.currentUser.uid;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
          // gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //   Colors.white,
          //   // Colors.green[800],
          //   // Colors.purple
          // ])
          ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        
        drawer: Drawer(
          
          child: Column(
            children: [
              Container(
                height: 100,
                color: Colors.transparent,
              ),
              ListTile(
                onTap: () {
                   Navigator.pushReplacementNamed(context, "/Home");
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()) );
                },
                
                title: Text(
                  "Home",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
             
              ListTile(
                onTap: () {
                   Navigator.pushReplacementNamed(context, "/SignIn");
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()) );
                },
                title: Text(
                  
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
       
        body: Center(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  getTickets(),
                 
              builder: (context, snapshot) {
                try{

                  if (snapshot.connectionState != ConnectionState.done) {
                  print(uids);
                  return ListView.builder(
                      // shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        String ticketId = snapshot.data.docs[index].id;
                        final item = snapshot.data.docs[index]['eventId'];

                        print(ticketId);
                        print(item);

                        return ExpansionTile(
                          
                          title: Text(
                            snapshot.data.docs[index]["eventId"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    ticketId,
                                    style: TextStyle(
                                      color: Colors.grey[850],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // leading: Image.network(
                          //     snapshot.data.docs[index]['imgURL']),
                          trailing: IconButton(
                              focusColor: Colors.orange,
                              hoverColor: Colors.orange,
                              splashColor: Colors.orangeAccent,
                              color: Colors.black,
                              icon: Icon(Icons.payment),
                              onPressed: () async {
                                navigateSoccaerContent(
                                          snapshot.data.docs[index], context);
                              }),
                          children: [
                            // Image.network(snapshot.data.docs[index]['imgURL']),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      primary: Colors.orange,
                                    ),
                                    child: Text(
                                      "Rate It",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                )
                              ],
                            )

                            //  GeoPoint(snapshot.data.docs[index].data()['geoLoc']),
                          ],
                        );
                      });
                }

                }catch(e){
                   return Loading();
                }
                //  else {
                 
                // }
              },
            ),
          ),
        ),
      ),
    );
  }
}
