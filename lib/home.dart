import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:socomtronics/Admin/adminHome.dart';
import 'package:socomtronics/BottomNavigationPages/concerts.dart';
import 'package:socomtronics/BottomNavigationPages/soccer.dart';
import 'package:socomtronics/Drawer Pages/tickets.dart';
import 'package:socomtronics/Shared/checkConnections.dart';
import 'package:socomtronics/Shared/showSoccerDetails.dart';
import 'package:socomtronics/SignIn/signIn.dart';
import 'package:socomtronics/SignIn/signUp.dart';
import 'package:socomtronics/Drawer%20Pages/qrCode.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  String title;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore ff = FirebaseFirestore.instance;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
   @override
  void initState() {
    checkConnection();
    super.initState();
  }

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(
                  'your not connected, Please turn on our mobile data or Wifi'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

 

  final _widgetOptions = <Widget>[
    Center(
      child: Soccer(),
    ),
    Center(
      child: Concerts(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Navigator.pop(context);
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
                try {
                  String uids = auth.currentUser.uid;

                  Navigator.pushReplacementNamed(context, "/Tickets");
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
              title: Text(
                "My Tickets",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/SignIn");
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) => SignUp()));
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

      //  backgroundColor: Colors.transparent,
      //  bottomNavigationBar: bottomNBar,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer_rounded),
            label: 'Soccer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note_outlined),
            label: 'Concerts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),

      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.green[100],
            onPressed: () {
              showSearch(context: context, delegate: FoodsSearch());
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            color: Colors.green[100],
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/Profile");
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "SOCOM Tronics",
            style: TextStyle(
                color: Colors.green[100], fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[600],
        onPressed: () {
          try {
            String uids = auth.currentUser.uid;

            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Tickets()));
          } catch (e) {
            setState(() {
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
            });
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.list),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FoodsSearch extends SearchDelegate {
  String name = "";
  final FirebaseFirestore foods = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Map<String, dynamic> _state = {
    'hasError': false,
    'message': "No error",
  };

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  Future<Map<String, dynamic>> savefoodorder(String foodId) async {
    try {
      foods.collection('orders').add({
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

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query.toString(),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    navigateSoccaerContent(DocumentSnapshot post, BuildContext context) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShowSoccerDetails(
                post: post,
              )));
    }

    return Container(
      color: Colors.white,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("teams").snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (!snapshot.hasData)
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: new Text(
                  'Loading Please Wait...',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );

          final results = snapshot.data.docs
              .where((DocumentSnapshot a) =>
                  a['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();
          return results.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'No matches found...',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                )
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    String foodId = results[index].id;
                    DocumentSnapshot a = results[index];
                    String nameH = a['name'];
                    String nameA = a['nameA'];

                    return ExpansionTile(
                      leading: Image.network(a["logo"] == null
                          ? AssetImage("lib/Assets/pic5.jpg")
                          : a["logo"]),

                      // Image.network(a["imgURL"], fit: BoxFit.fill),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$nameH",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            " vs ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "$nameA",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        a['pitch'],
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Image.network(a["logo"] == null
                          ? AssetImage("lib/Assets/pic5.jpg")
                          : a["logoA"]),

                      children: [
                        ElevatedButton(
                            onPressed: () {
                              navigateSoccaerContent(a, context);
                            },
                            child: Text("Buy Ticket"))
                      ],
                    );
                  });
        },
      ),
    );
  }
}
