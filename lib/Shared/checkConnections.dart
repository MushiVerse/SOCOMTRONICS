import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class CheckConn extends StatefulWidget {
  const CheckConn({Key key}) : super(key: key);

  @override
  _CheckConnState createState() => _CheckConnState();
}

class _CheckConnState extends State<CheckConn> {
  @override
  void initState() {
    checkConnection();
    super.initState();
  }

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(
                  'your not connected, Please turn on our mobile data or Wifi'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
