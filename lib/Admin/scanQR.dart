import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:socomtronics/Admin/widget/button.dart';
import 'package:socomtronics/Loadings/loading.dart';

import '../main.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = 'Unknown';

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore ff = FirebaseFirestore.instance;
  final CollectionReference cr =
      FirebaseFirestore.instance.collection('tickets');

  Stream<QuerySnapshot> getTickets() async* {
    final uids = auth.currentUser.uid;
    print(uids);
    yield* FirebaseFirestore.instance.collection('tickets').snapshots();
  }

  // Future<void> _deleteData(DocumentReference reference) async {
  //   await FirebaseFirestore.instance
  //       .collection('Tickets')
  //       .doc(document.documentElement)
  //       .delete();
  // }

  _delete(idu) async {
    ff.collection('tickets').doc(idu).delete();
  }

  @override
  void initState() {
    scanQRCode();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Scan QR"),
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: getTickets(),
            builder: (c, s) {
              if (s.hasData) {
                return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (c, i) {
                      String ticket = s.data.docs[i]['ticket'];
                      print(ticket);

                      if (ticket != qrCode) {
                        return CupertinoAlertDialog(
                          title: new Text("Dialog Title"),
                          content: new Text(
                            "Scan Next Ticket",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              child: Text("Ok"),
                              onPressed: () {
                                scanQRCode();
                              },
                            ),
                          ],
                        );
                      } else {
                        return CupertinoAlertDialog(
                          title: new Text("Dialog Title"),
                          content: new Text(
                            "Valid Ticket",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                          ),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              child: Text("Ok"),
                              onPressed: () {

                                _delete(s.data.docs[i].id);
                                scanQRCode();
                                // Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Scan Result',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'From qr',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '$qrCode',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'from db',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                ticket,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 72),
                          ButtonWidget(
                              text: 'Start QR scan',
                              onClicked: () {
                                scanQRCode();
                                setState(() {
                                  // value = qrCode;
                                  if (ticket == qrCode ) {
                                    _delete(s.data.docs[i].id);

                                  }
                                });
                              }),
                        ],
                      );
                    });
              } else {
                return Loading();
              }
            },
          ),
        ),
      );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
}
