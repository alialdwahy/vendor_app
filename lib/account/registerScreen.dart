import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/widgets/imagePicker.dart';
import 'package:vendor_app/widgets/registerform.dart';


class RegisterScreen extends StatelessWidget {
  static const String id = 'register screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
       body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                   ShopPicCard(),
                    RegisterForm(),
                 ],
         ),
              ),
            ),
          ),
        ),
    );
  }
}
