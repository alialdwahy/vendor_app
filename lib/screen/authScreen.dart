import 'package:flutter/material.dart';



class AuthScreen extends StatefulWidget {
  static const String id = 'auth scrren';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('auth scrren'),
      ),
    );
  }
}
