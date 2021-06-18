import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart'; //Import the plugin

// void main() {
//   /*Set Consumer credentials before initializing the payment.
//     You can get  them from https://developer.safaricom.co.ke/ by creating
//     an account and an app.
//      */
//   MpesaFlutterPlugin.setConsumerKey("Fmvfv5A9sHbtyxAkryOYyJ6leGjIXIST");
//   MpesaFlutterPlugin.setConsumerSecret("Fp8Y2FJC0TRN75Ym");

//   runApp(Mpesa());
// }

class Mpesa extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Mpesa> {
  Future<void> startCheckout({String userPhone, double amount}) async {
    //Preferably expect 'dynamic', response type varies a lot!
    dynamic transactionInitialisation;
    //Better wrap in a try-catch for lots of reasons.
    try {
      //Run it
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: userPhone,
          partyB: "174379",
          callBackURL: Uri(
              scheme: "https", host: "my-app.herokuapp.com", path: "/callback"),
          accountReference: "shoe",
          phoneNumber: userPhone,
          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
          transactionDesc: "purchase",
          passKey:
              "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");

      print("TRANSACTION RESULT: " + transactionInitialisation.toString());

      /*Update your db with the init data received from initialization response,
      * Remaining bit will be sent via callback url*/
      return transactionInitialisation;
    } catch (e) {
      //For now, console might be useful
      print("CAUGHT EXCEPTION: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.brown[450], primarySwatch: Colors.brown),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Mpesa Payment plugin'),
          ),
          body: Center(
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  startCheckout(userPhone: "255764587748", amount: 3);
                },
                child: Text("Checkout")),
          )),
    );
  }
}
