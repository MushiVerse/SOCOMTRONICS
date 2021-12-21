import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:socomtronics/Admin/HomeAdmn.dart';
import 'package:socomtronics/Admin/adminHome.dart';
import 'package:socomtronics/Drawer%20Pages/qrCode.dart';
import 'package:socomtronics/Shared/roundedButton.dart';
import 'package:socomtronics/SignIn/loginSucces.dart';
import 'package:socomtronics/SignIn/signUp.dart';
import 'package:socomtronics/home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  void _signIn({String em, String pw}) {
    _auth.signInWithEmailAndPassword(email: em, password: pw).then((signinval) {
      if(em == "kazenmronga4@gmail.com" && pw == "Norman12#"){
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HomeAdmin()));
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SuccessScreen()));

      }
      
    }).catchError((err) {
      print(err.code);
      if (err.code == 'user-not-found') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Sorry user not found'),
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

      if (err.code == 'invalid-email') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Sorry! Type or Copy your email carefully'),
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

      if (err.code == 'wrong-password') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Incorrect Email or Password '),
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
    });
  }

  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  void clearText() {
    user.clear();
    pass.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/Assets/pic3.jpg"), fit: BoxFit.cover)),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF200231)
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
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) => Home()));
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
                       Navigator.pushReplacementNamed(context, "/Tickets");
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) => QrCode()));
                    },
                    title: Text(
                      "My Tickets",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,

            // backgroundColor: Color(0xff251F34),
            body: Form(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                          width: 175,
                          height: 175,
                          child: SvgPicture.asset('lib/Assets/svg1.svg')),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Please sign in to continue.',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'E-mail',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              style: (TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.white,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3B324E),
                                filled: true,
                                prefixIcon: Icon(Icons.person,
                                color: Colors.white,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF12A76E), width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Password',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            
                            style: (TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                            obscureText: true,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3B324E),
                              prefixIcon: Icon(Icons.security,
                              color: Colors.white,
                              ),
                              filled: true,
                              // prefixIcon: Image.asset('lib/Assets/password.svg'),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF12A76E), width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                            onChanged: (value) {
                              password = value;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: RoundedButton(
                          btnText: 'LOGIN',
                          color: Color(0xFFFFFFFF),
                          onPressed: () async {
                            // Add login code
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              _signIn(em: email, pw: password);
                              // final user = await _auth.signInWithEmailAndPassword(
                              //     email: email, password: password);
                              // if (user != null) {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => SuccessScreen()));
                              // );
                              // }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dont have an account?',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),

                        SizedBox(width: 20),
                        ElevatedButton(
                          
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text('Sign up',
                              style: TextStyle(
                                  color: Color(0xFFF8F8F8), fontSize: 18)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
