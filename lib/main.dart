import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/account/loginScreen.dart';
import 'package:vendor_app/account/registerScreen.dart';
import 'package:vendor_app/provider/auth_provider.dart';
import 'package:vendor_app/screen/homeScreen.dart';
import 'package:vendor_app/screen/splashScreen.dart';
import 'package:vendor_app/widgets/resetPassword.dart';



void main()async {
  Provider.debugCheckInvalidValueType=null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(MultiProvider(
      providers:[
        Provider (create: (_) => AuthProvider()),

      ],
      child: MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.deepOrange,
          fontFamily: 'Lato'
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        RegisterScreen.id:(context)=>RegisterScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        LoginScrren.id:(context)=>LoginScrren(),
        ResetPassword.id:(context)=>ResetPassword(),

      },
    );
  }
}



