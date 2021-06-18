import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socomtronics/Drawer%20Pages/qrCode.dart';
import 'package:socomtronics/Shared/register.dart';
import 'package:socomtronics/Shared/roundedButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:socomtronics/SignIn/signIn.dart';
import 'package:socomtronics/home.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formkey = GlobalKey<FormState>();
  bool showSpinner = false;
  bool saveAttempt = false;
  String email, password, cpassword, location, phone, name;
  final _auth = FirebaseAuth.instance;

  void _createUser({String eml, String pwd}) {
    _auth
        .createUserWithEmailAndPassword(email: eml, password: pwd)
        .then((authresult) {
      User userUpdate = FirebaseAuth.instance.currentUser;
      userUpdate.updateProfile(displayName: name);
      String uid = _auth.currentUser.uid.toString();
      // String email = _auth.currentUser.email.toString();
      userRegista(name, phone, uid, email);

      // setState(() {
      //   showSpinner = false;
      // });

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => SignIn()));
    }).catchError((err) {
      print(err.code);
      if (err.code == 'email-already-in-use') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Email already exist '),
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
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0,
              leading: _goBackButton(context),
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
                      Navigator.pushReplacementNamed(context, "/Tickets");
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrCode()) );
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
            backgroundColor: Colors.transparent,
            body: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Please fill the input below.',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Name',
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
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3B324E),
                              filled: true,
                              prefixIcon: Image.asset('lib/Assets/logo.png'),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF12A76E), width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                            validator: (name) {
                              if (name.isEmpty) {
                                return 'Fill in your name';
                              }
                              return null;
                            },
                            autovalidate: saveAttempt,
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Phone',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            maxLength: 10,
                            validator: (phonval) {
                              if (phonval.isEmpty) {
                                return 'Fill in your phone number';
                              } else if (phonval.length < 10) {
                                return 'Invalid Length';
                              }
                              return null;
                            },
                            style: (TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            cursorColor: Colors.white,
                            autovalidate: saveAttempt,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3B324E),
                              filled: true,
                              prefixIcon: Image.asset('lib/Assets/logo.png'),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF12A76E), width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                phone = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                            autovalidate: saveAttempt,
                            validator: (emailValue) {
                              if (emailValue.isEmpty) {
                                return "Fill in your email";
                              }

                              String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                  "\\@" +
                                  "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                  "(" +
                                  "\\." +
                                  "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                  ")+";

                              RegExp regExp = new RegExp(p);

                              if (regExp.hasMatch(emailValue)) {
                                return null;
                              }

                              return 'Invalid Email Format';
                            },
                            style: (TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3B324E),
                              filled: true,
                              prefixIcon: Image.asset('lib/Assets/logo.png'),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF12A76E), width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                        ],
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
                            autovalidate: saveAttempt,
                            validator: Validators.compose([
                              Validators.required('Password required'),
                              Validators.patternString(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~+]).{8,}$',
                                  'Invalid Password Format')
                            ]),
                            style: (TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                            obscureText: true,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3B324E),
                              filled: true,
                              prefixIcon: Image.asset('lib/Assets/logo.png'),
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
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Confirm Password',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            autovalidate: saveAttempt,
                            validator: (cPwdValue) {
                              if (cPwdValue != password) {
                                return "Passwords must match";
                              }
                              return null;
                            },
                            style: (TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                            obscureText: true,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(color: Colors.white),
                              labelText: 'Re-Enter Password',
                              labelStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              fillColor: Color(0xfff3B324E),
                              filled: true,
                              prefixIcon: Image.asset('lib/Assets/logo.png'),
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
                          btnText: 'SIGN UP',
                          textColor: Colors.white,
                          color: Color(0xFF000000),
                          onPressed: () async {
                            

                            setState(() {
                              saveAttempt = true;

                              
                              //  showSpinner = true;
                            });

                           
                            try {
                              // setState(() {
                              //   showSpinner = true;
                              // });

                              if (formkey.currentState.validate()) {
                                formkey.currentState.save();
                                _createUser(eml: email, pwd: password);
                                 Fluttertoast.showToast(
        msg: "Your Registered",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  
                                
                              } else {}
                            } catch (e) {
                              print(e);
                            }
                            // Add login code
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                              color: Colors.blue[200],
                              fontWeight: FontWeight.w400),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          },
                          child: Text('Sign in',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFFFFFFFF),
                              )),
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

Widget _goBackButton(BuildContext context) {
  return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.grey[350]),
      onPressed: () {
        Navigator.of(context).pop(true);
      });
}
