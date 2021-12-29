import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/account/loginScreen.dart';
import 'package:vendor_app/provider/auth_provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset password';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var _emailTextController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String? email;
  bool _loading=false;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/forgot.jpg',height: 150,),
                  SizedBox(height: 20,),
                 RichText(text: TextSpan(
                   text: '',
                   children: [
                     TextSpan(text: 'Forgot Password:    ',style:TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                     TextSpan(text: 'Dont Worry ,Provide us yor Registered Email,we will send you an email to reset your password',
                   style: TextStyle(color: Colors.blue)  ),
                   ],
                 )),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _emailTextController,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter Email';
                      }
                      final bool _isValid = EmailValidator.validate(_emailTextController.text);
                      if(!_isValid){
                      }
                      setState(() {
                        email=value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(),
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor,width: 2),
                        ),
                        fillColor: Theme.of(context).primaryColor
                    ),
                  ),
                  SizedBox(height: 20,),
                  FlatButton(onPressed: (){
                    if(_formkey.currentState!.validate()){
                      setState(() {
                        _loading=true;
                      });
                      _authData.resetPassword(email);
                    }
                    Navigator.pushReplacementNamed(context, LoginScrren.id);
                  },
                    color: Theme.of(context).primaryColor,

                    child: _loading?LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.transparent,
                    ):Text('Reset Password',style: TextStyle(
                        color: Colors.white,fontWeight: FontWeight.bold
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }
}
