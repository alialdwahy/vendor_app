import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/provider/auth_provider.dart';
import 'package:vendor_app/screen/homeScreen.dart';
import 'package:vendor_app/widgets/resetPassword.dart';

class LoginScrren extends StatefulWidget {
  static const String id = 'login screen';

  @override
  _LoginScrrenState createState() => _LoginScrrenState();
}

class _LoginScrrenState extends State<LoginScrren> {
  var _emailTextController = TextEditingController();
  String? email;
  late String password;
  bool _loading=false;
  final _formkey = GlobalKey<FormState>();
  late Icon icon;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Center(
             child: SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text('LOGIN',style: TextStyle(fontFamily: 'Anton',fontSize: 30),),
                       SizedBox(width: 20,),
                       Image.asset('images/Logod.png',height: 80,),
                     ],
                   ),
                   SizedBox(height: 20,),
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
                   SizedBox(height: 10,),
                   TextFormField(
                     validator: (value){
                       if(value!.isEmpty){
                         return 'Enter Password';
                       }
                       if(value.length<6){
                         return 'minimum 6 characters';
                       }
                       setState(() {
                         password=value;
                       });
                       return null;
                     },
                     obscureText: _visible==false?true:false,
                     decoration: InputDecoration(
                       suffixIcon: IconButton(
                         icon:_visible? Icon(Icons.visibility):Icon(Icons.visibility_off),
                       onPressed: (){
                           setState(() {
                             _visible=!_visible;
                           });
                       },),
                       enabledBorder: OutlineInputBorder(),
                       contentPadding: EdgeInsets.zero,
                       hintText: 'Password',
                       prefixIcon: Icon(Icons.vpn_key_outlined),
                       focusedBorder: OutlineInputBorder(
                         borderSide: BorderSide(color: Theme.of(context).primaryColor,width: 2),
                       ),
                       fillColor: Theme.of(context).primaryColor
                     ),
                   ),
                   SizedBox(height: 10,),
                   Row(
                     children: [
                       Expanded(
                         child: InkWell(
                           onTap: (){
                             Navigator.pushNamed(context, ResetPassword.id);

                           },
                           child: Text(
                             'Forgot Password ?',textAlign:TextAlign.end,style: TextStyle(
                               color: Colors.blue,fontWeight: FontWeight.bold),
                           ),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(height: 10,),
                   Row(
                     children: [
                       Expanded(
                         child: FlatButton(color: Theme.of(context).primaryColor,

                             child: _loading?LinearProgressIndicator(
                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                               backgroundColor: Colors.transparent,
                             ):Text('login',style: TextStyle(
                               color: Colors.white,fontWeight: FontWeight.bold
                             ),
                             ),
                           onPressed: (){
                             if(_formkey.currentState!.validate()){
                               setState(() {
                                 _loading=true;
                               });
                               _authData.loginVendor(email!, password).then((credential){
                                 if(credential!=null){
                                   setState(() {
                                     _loading=false;
                                   });
                                   Navigator.pushReplacementNamed(context, HomeScreen.id);
                                 }else {
                                   setState(() {
                                     _loading=false;
                                   });
                                   ScaffoldMessenger.of(context)
                                       .showSnackBar(
                                       SnackBar(content: Text(_authData.error)));
                                 }
                               });
                             }
                           },
                         ),
                       ),
                     ],
                   ),
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
