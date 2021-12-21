import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:socomtronics/MpesaPayment/checkout.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:socomtronics/SignIn/signIn.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowConcertDetails extends StatefulWidget {
  final DocumentSnapshot poost;

  ShowConcertDetails({key, this.poost}) : super(key: key);
  @override
  _ShowConcertDetailsState createState() => _ShowConcertDetailsState();
}

class _ShowConcertDetailsState extends State<ShowConcertDetails> {
  String _linkMessage;
  bool _isCreatingLink = false;
  String _testString =
      'To test: long press link and then copy and click from a non-browser '
      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
      'is properly setup. Look at firebase_dynamic_links/README.md for more '
      'details.';

  String fbProtocolUrl = 'bugi://';

  String fallbackUrl = 'bugi://';
  final FirebaseAuth auth = FirebaseAuth.instance;

  final DBref = FirebaseDatabase.instance.reference();

  void write() {
    DBref.child("2").set({'id': 'ID1', 'data': 'This is demo'});
  }

  void read() {
    DBref.once().then((snap) {
      print(snap.value);
    });
  }

  void update() {
    DBref.child("2").update({'id': 'ID1', 'data': 'This is updated data'});
  }

  void delete() {
    DBref.child("1").remove();
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  final FirebaseFirestore ff = FirebaseFirestore.instance;
 

  Future<Map<String, dynamic>> saveTickets2(String ticket) async {
    try {
      final uids = auth.currentUser.uid.toString();
      await ff.collection('tickets').add({
        'ticket': ticket,
      });


    } catch (e) {
    
    }
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

     
    } catch (e) {
     
    }
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        // ignore: unawaited_futures
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      // ignore: unawaited_futures
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://multipurposestadiumms.page.link',
        link: Uri.parse('https://www.example/Home'),
        androidParameters: AndroidParameters(
          packageName: 'com.mushi.firebase.fastfood',
          minimumVersion: 0,
        ),
        iosParameters: IosParameters(
          bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
          minimumVersion: '0',
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: "bugi pay", description: "make payments here"));

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      print(shortLink.toString());
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green[800]),
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Colors.black38,
        ),
        child: Center(
            child: ListTile(
          title: Padding(
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                ExpansionTile(
                  leading: ExtendedImage.network(
                    widget.poost.data()["pic"],
                  ),
                  title: Text(
                    widget.poost.data()["name"],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    widget.poost.data()["desc"],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        widget.poost.data()["desc"],
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                Image.network(
                  widget.poost.data()["pic"],
                ),
                // Padding(
                //     child: Image.network(pic.picha1),
                //     padding: EdgeInsets.only(bottom: 0.0)),
                SizedBox(
                  height: 0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 26.0, vertical: 16.0),
                          child: IconButton(
                              color: Colors.blue,
                              splashColor: Colors.black,
                              icon: Icon(Icons.favorite),
                              onPressed: () {})),
                    ]),
                Row(
                  children: <Widget>[
                    Flexible(
                        child: new Text(
                      widget.poost.data()["venue"],
                      style: new TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    )),
                    Text(" | "),
                    Padding(
                        child: Text(
                          "hey",
                          style: new TextStyle(fontStyle: FontStyle.italic),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                        padding: EdgeInsets.all(1.0)),
                  ],
                ),

                ElevatedButton(
                    onPressed: () {

                      try {
                  String uids = auth.currentUser.uid;
                  String eventId = widget.poost.id;
                                                                              // String ticket =
                                                                              //     snapshot.data.docs[index].data()['name'];
                                                                              String price = "Tsh 15,000";
                                                                              // String img =
                                                                              //     snapshot.data.docs[index].data()['imgURL'];

                                                                              const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                                                              Random _rnd = Random();

                                                                              String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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
                                        color: Colors.black,
                                        child: ExpansionTile(
                                          title: Text(
                                            "Ticket",
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
                                                              amount: '15000.00',
                                                              displayName:
                                                                  'Kazen'),
                                                      cardEnabled: true);

                                                  BraintreeDropInResult res =
                                                      await BraintreeDropIn
                                                          .start(req);

                                                  if (res != null) {
                                                    return showCupertinoDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CupertinoAlertDialog(
                                                            title: Text(
                                                                'Successfully Paid'),
                                                            actions: <Widget>[
                                                              CupertinoDialogAction(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Divider(),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Center(
                                                                        child:
                                                                            Text(
                                                                      "Get Your Ticket",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30),
                                                                    )),
                                                                  ],
                                                                ),
                                                                onPressed: () async{

                                                                  await saveTickets(eventId, getRandomString(10), price);

                                                                                          await saveTickets2(getRandomString(10));
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              )
                                                            ],
                                                          );
                                                        });

                                                    print(res.paymentMethodNonce
                                                        .description);
                                                    print(res.paymentMethodNonce
                                                        .nonce);

                                                 
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
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Divider(),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
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
                                          leading: Icon(Icons.money),
                                          trailing: Text(
                                            "Tzs 15000",
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.white),
                                          ),
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
                    child: Text("Buy Tickets"))
              ],
            ),
          ),
        )),
      ),
    );
  }

  void deeplink() async {
    final Uri params = Uri(
        scheme: 'malipo',
        path: 'norman@gmail.com',
        queryParameters: {
          'subject': 'payment',
          'body': 'Buy tickets'
        });
        String url = params.toString();
         if (await canLaunch(url)) {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

      if (!launched) {
      await launch(fallbackUrl, forceSafariVC: false);
     }
    } else {
      print('Could not launch $url');
    }

    // bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

    // if (!launched) {
    //   await launch(fallbackUrl, forceSafariVC: false);
    // }
  }
}
