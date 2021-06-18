import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socomtronics/Drawer%20Pages/qrCode.dart';
import 'package:socomtronics/MpesaPayment/checkout.dart';
import 'package:socomtronics/Shared/profile.dart';
import 'package:socomtronics/SignIn/signIn.dart';
import 'package:socomtronics/SignIn/signUp.dart';
import 'package:socomtronics/home.dart';
import 'package:socomtronics/splashScreen.dart';
import 'package:socomtronics/Drawer Pages/tickets.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
          '/Home': (BuildContext context) => Home(),
          '/SignIn': (BuildContext context) => SignIn(),
          '/SignUp': (BuildContext context) => SignUp(),
          '/Profile': (BuildContext context) => ProfileApp(),
          '/CheckOut':(context) => CheckOut(),
          // '/': (BuildContext context) => QrCode(),
          '/Tickets': (BuildContext context) => Tickets(),
          '/Qrcode': (BuildContext context) => QrCode(),
        },
      debugShowCheckedModeBanner: false,
      title: 'MultiPurpose SMS',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green[800],
        canvasColor: Colors.transparent
        ),
      home: MyHomePage(title: 'MultiPurpose Stadium Management System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
     return AnimatedSplashScreen(
      backgroundColor: Colors.white,
      splash: "lib/Assets/logo2.jpg",
      duration: 3000,
      splashIconSize: 500,
      splashTransition: SplashTransition.rotationTransition,
      nextScreen: SplashScreen(),
    );
  }
}
