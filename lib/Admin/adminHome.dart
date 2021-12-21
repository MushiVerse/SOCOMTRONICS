import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:socomtronics/SignIn/signIn.dart';

//void main() => runApp(MyApp());

class MyApp1 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Storage Demo',
      routes: <String, WidgetBuilder>{
          // '/Home': (BuildContext context) => Home(),
          '/SignIn': (BuildContext context) => SignIn(),
          // '/SignUp': (BuildContext context) => SignUp(),
          // '/CheckOut':(context) => CheckOut(),
          // // '/': (BuildContext context) => QrCode(),
          // '/Tickets': (BuildContext context) => Tickets(),
          // '/Qrcode': (BuildContext context) => QrCode(),
        },
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: UploadingImageToFirebaseStorage(),
    );
  }
}

final Color purple = Color(0xFF52044E);
final Color white = Color(0xFFF8F8F8);
final Color greenl = Color(0xFF97E2A4);
final Color greend = Color(0xFF2C362E);

class UploadingImageToFirebaseStorage extends StatefulWidget {
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
  File _imageFile, _imageFile2;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final pickedFile2 = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
      _imageFile2 = File(pickedFile2.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    String fileName2 = basename(_imageFile2.path);
    fs.Reference firebaseStorageRef =
        fs.FirebaseStorage.instance.ref().child('uploads/$fileName');
    fs.Reference firebaseStorageRef2 =
        fs.FirebaseStorage.instance.ref().child('uploads/$fileName2');
    fs.UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    fs.UploadTask uploadTask2 = firebaseStorageRef2.putFile(_imageFile);
    // fs.TaskSnapshot taskSnapshot = await uploadTask.isComplete;
    // taskSnapshot.ref.getDownloadURL().then(
    //       (value) => print("Done: $value"),
    //     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [greenl, white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Uploadings...",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,

                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: _imageFile != null
                                  ? Image.file(_imageFile)
                                  : FlatButton(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 50,
                                      ),
                                      onPressed: pickImage,
                                    ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            //  ClipRRect(
                            //   borderRadius: BorderRadius.circular(30.0),
                            //   child: _imageFile2 != null
                            //       ? Image.file(_imageFile2)
                            //       : FlatButton(
                            //           child: Icon(
                            //             Icons.add_a_photo,
                            //             size: 50,
                            //           ),
                            //           onPressed: pickImage,
                            //         ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                uploadImageButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [greenl, greend],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: FlatButton(
              onPressed: () => uploadImageToFirebase(context),
              child: Text(
                "Upload Image",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
