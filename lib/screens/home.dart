import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mp_finalproject/screens/login.dart';
import 'package:mp_finalproject/widgets/nav_bar_widget.dart';

class HomeScreen extends StatefulWidget{
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{
  int selectedIndex = 0;

  void onTabSelectedIndex(int index){
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        print('Navigating to Home');
        break;
      case 1:
        print('Navigating to Payment History');
        break;
      case 2:
        print('Navigating to Search');
        break;
      case 3:
        print('Navigating to Profile');
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          automaticallyImplyLeading: false, //back icon remove
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Text(
            'Selected Tab: $selectedIndex',
            style: TextStyle(fontSize: 20),
          ),
        ),
        bottomNavigationBar: NavBarWidget(
          currentIndex: selectedIndex,
          onTabSelected: onTabSelectedIndex,
        ),
      ),
    );
  }
}
