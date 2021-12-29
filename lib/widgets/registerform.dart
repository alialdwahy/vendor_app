import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/provider/auth_provider.dart';
import 'package:vendor_app/screen/homeScreen.dart';


class RegisterForm extends StatefulWidget {


  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _cpasswordTextController = TextEditingController();
  var _addressTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  var _dialogTextController = TextEditingController();
  String? email;
  String? password;
  String? mobile;
  String? shopName;
  String? dialog;
  bool _isLoading = false;


  Future<String> uploadFile( filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage =FirebaseStorage.instance;

    try {
      await _storage.ref('uploads/shopProfilePic${_nameTextController.text}').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('uploads/shopProfilePic${_nameTextController.text}')
        .getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffildmessage(message){
      return    ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
    return _isLoading ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ):
    Form(
     key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Shop Name';
                }
                setState(() {
                  _nameTextController.text=value;
                });
                setState(() {
                  shopName=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.add_business),
                labelText: 'Business Name',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,color: Theme.of(context).primaryColor,
                  ),
                ),
                fillColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLength: 9,
              keyboardType: TextInputType.number,
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Mobile Number';
                }
                setState(() {
                  mobile=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixText: '+249',
                prefixIcon: Icon(Icons.phone_android),
                labelText: 'Mobile Number',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,color: Theme.of(context).primaryColor,
                  ),
                ),
                fillColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Email';
                }
                final bool _isValid = EmailValidator.validate(_emailTextController.text);
                if(!_isValid){
                  return 'Invalid Email Fromat';
                }
                setState(() {
                  email=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'Email',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,color: Theme.of(context).primaryColor,
                  ),
                ),
                fillColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter PassWord';
                }
                if(value.length<6){
                  return 'minimum 6 charectors';
                }
                setState(() {
                  password=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),
                labelText: 'PassWord',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,color: Theme.of(context).primaryColor,
                  ),
                ),
                fillColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value){
                if(value!.isEmpty){
                  return 'Enter Confirm PassWord';
                }
                if(_passwordTextController.text != _cpasswordTextController.text){
                  return 'Password Does\'t Match';
                }
                if(value.length<6){
                  return 'minimum 6 charectors';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),
                labelText: 'Confirm PassWord',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,color: Theme.of(context).primaryColor,
                  ),
                ),
                fillColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines: 6,
              controller: _addressTextController,
              validator: (value){
                if(value!.isEmpty){
                  return 'Please Press navigation Button';
                }
                if(_authData.shopLatitude==null){
                  return 'Please Press navigation Button';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.contact_mail_outlined),
                labelText: 'Business Location',
                suffixIcon: IconButton(
                  icon:Icon( Icons.location_searching),
                  onPressed: (){
                    _addressTextController.text='Location...\n Please Wait...';
                    _authData.getCurrentAddress().then((address){
                      if(address!=null){
                        setState(() {
                          _addressTextController.text='${_authData.placeName}\n${_authData.shopAddress}';
                        });
                      }else{
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('could not find location .. try agin')));
                      }
                    });

                }, ),

                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,color: Theme.of(context).primaryColor,
                  ),
                ),
                fillColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              onChanged: (value){
                _dialogTextController.text=value;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.comment),
                labelText: 'Shop Dialog',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,color: Theme.of(context).primaryColor,
                  ),
                ),
                fillColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: (){
                    if(_authData.isPicAvail==true){
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          _isLoading=true;
                        });
                        _authData.registerVendor(email, password).then((credential){
                          if(credential!.user!.uid!=null){
                            uploadFile(_authData.image.path).then((url){
                              if(url!=null){
                                _authData.saveVendorDataToDb(
                                  url: url,
                                  shopName: shopName,
                                  mobile:mobile,
                                  dialog: _dialogTextController.text,
                                );
                                  setState(() {
                                    _formKey.currentState;
                                    _isLoading=false;
                                  });
                                Navigator.pushReplacementNamed(context, HomeScreen.id);
                              }else{
                                scaffildmessage('Failed to Upload Shop Profile Pic');
                              }
                            });


                          }else{
                            scaffildmessage(_authData.error);

                          }

                        });

                      }
                    }else{
                     scaffildmessage('shop profile pic need to be added');
                    }
                  },
                    child: Text('Register',style: TextStyle(color: Colors.white,),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
