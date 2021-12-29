import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/account/loginScreen.dart';
import 'package:vendor_app/account/registerScreen.dart';

import 'package:vendor_app/screen/homeScreen.dart';

import '../helper.dart';



class  SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer(Duration(milliseconds: 4000), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if(user==null){
          Navigator.pushReplacementNamed(context, LoginScrren.id);
        }else{
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Image.asset("images/Logod.png"),
            Text(
              'Gowi App',
              style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),
            ),
          ],
              ),
            ),
    );
  }
}