import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socomtronics/SignIn/signUp.dart';
import 'package:socomtronics/home.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCode extends StatefulWidget {

  final DocumentSnapshot post;

  const QrCode({Key key, this.post}) : super(key: key);
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.green
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Colors.green,
            Colors.green[900],
          ])
          ),
      child: Scaffold(
        
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
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
          backgroundColor: Colors.transparent,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
                color: Colors.white,
                // image: DecorationImage(
                //   image:AssetImage("lib/Assets/pic2.jpg")       
                // ) 
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: QrImage(
                  data: widget.post.data()["ticket"],
 ),
          )
        ),
              ),
            ),
      ),
    );
  }
}