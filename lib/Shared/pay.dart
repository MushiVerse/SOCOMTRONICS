
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class Pay extends StatefulWidget {
  const Pay({ Key key }) : super(key: key);

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {

  Future pay() async {
    var req = BraintreeDropInRequest(
        tokenizationKey: 'sandbox_6m4qt2h4_xgp6d5mzjh5qsvxr',
        collectDeviceData: true,
        paypalRequest:
            BraintreePayPalRequest(amount: '10.00', displayName: 'Kazen'),
        cardEnabled: true);

    BraintreeDropInResult res = await BraintreeDropIn.start(req);

    if (res != null) {
      return showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Successfully Paid'),
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
                          child: Text(
                        "Ok",
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

      print(res.paymentMethodNonce.description);
      print(res.paymentMethodNonce.nonce);

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
                          child: Text(
                        "Ok",
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
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}