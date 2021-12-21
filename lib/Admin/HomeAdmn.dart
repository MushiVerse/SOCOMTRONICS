import 'package:flutter/material.dart';
import 'package:socomtronics/Admin/adminHome.dart';
import 'package:socomtronics/Admin/scanQR.dart';  


class HomeAdmin extends StatefulWidget {  
  HomeAdmin({Key key}) : super(key: key);  
  
  @override  
  _MyNavigationBarState createState() => _MyNavigationBarState();  
}  
  
class _MyNavigationBarState extends State<HomeAdmin> {  
  int _selectedIndex = 0;  
  static List<Widget> _widgetOptions = <Widget>[  
    Center(
      child: MyApp1(),
    ),
    Center(
      child: QRScanPage(),
    ),
  ];  
  
  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;  
    });  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold( 
      appBar: AppBar(
        actions: [
           IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/SignIn");
              })
        ],
      ),
      backgroundColor: Colors.white, 
     
      body: Center(  
        child: _widgetOptions.elementAt(_selectedIndex),  
      ),  
      bottomNavigationBar: BottomNavigationBar(  
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[  
          BottomNavigationBarItem(  
            icon: Icon(Icons.home,
            color: Colors.purple,
            ),  
            title: Text('Home'),  
            backgroundColor: Colors.purple  
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.scanner,
            color: Colors.purple,
            ),  
            title: Text('Scan'),  
            
            backgroundColor: Colors.purple
          ),  
         
        ],  
        type: BottomNavigationBarType.fixed,  
        currentIndex: _selectedIndex,  
        selectedItemColor: Colors.black,  
        iconSize: 40,  
        onTap: _onItemTapped,  
        elevation: 5  
      ),  
    );  
  }  
}  