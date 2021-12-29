import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/account/loginScreen.dart';
import 'package:vendor_app/account/registerScreen.dart';


class HomeScreen extends StatefulWidget {
  static const String id = 'home screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, LoginScrren.id);
          },
          child: Text('Log Out'),
        ),
      ),
    );
  }
}
