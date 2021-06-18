
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socomtronics/home.dart';

class ProfileApp extends StatefulWidget {
  final AppBar appBar;

  ProfileApp({this.appBar});
  @override
  _ProfileAppState createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
        "My Profile",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
      ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(17),
                child: ElevatedButton(
                    child: Text('Sign Out'),
                    onPressed: () {
                      _signOut();

                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text(
                                  'You are Logged Out'),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (contex) => Home()));
                                  },
                                )
                              ],
                            );
                          });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
