import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier{
 late File image;
 bool isPicAvail=false;
 String error="";
 String pickererror='';
 late double shopLatitude;
 late double shopLongitude;
 String? shopAddress;
 String? placeName;
 late String email;



  Future getImage()async {
    final picker = ImagePicker();
    final PickedFile? pickedFile = await picker.getImage(
        source: ImageSource.gallery,imageQuality: 20);
    if (pickedFile!=null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickererror='No Image Selected';
      print('no image selected');
      notifyListeners();
    }
    return this.image;
  }
  Future  getCurrentAddress()async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    this.shopLatitude=_locationData.latitude!;
    this.shopLongitude=_locationData.longitude!;
    notifyListeners();

    final coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
    var _addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var shopAddres = _addresses.first;
    this.shopAddress= shopAddres.addressLine;
    this.placeName= shopAddres.featureName;
    notifyListeners();
    return shopAddres;
  }
  Future<UserCredential?>registerVendor(email,password)async{
    this.email=email;
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error='The password provided is too weak.';
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        this.error='The account already exists for that email.';
        print('The account already exists for that email.');
      }
    } catch (e) {
      this.error=e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;

  }
 Future<UserCredential?>loginVendor(String  email,password)async{
   this.email=email;
   notifyListeners();
   UserCredential? userCredentia;
   try {
     userCredentia = await FirebaseAuth.instance.signInWithEmailAndPassword(
         email: email,
         password: password,
     );
   } on FirebaseAuthException catch (e) {
       this.error=e.code;
       notifyListeners();
   } catch (e) {
     this.error="e.code";
     notifyListeners();
     print(e);
   }
   return userCredentia;
 }
 Future<UserCredential?>resetPassword( email,)async{
   this.email=email;
   notifyListeners();
   UserCredential? userCredentia;
   try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
       email: email,
     );
   } on FirebaseAuthException catch (e) {
     this.error=e.code;
     notifyListeners();
   } catch (e) {
     this.error="e.code";
     notifyListeners();
     print(e);
   }
   return userCredentia;
 }
  Future<void>saveVendorDataToDb({String? url,String? shopName,String? mobile,String? dialog})async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors = FirebaseFirestore.instance.collection('vendors').doc(user!.uid);
    _vendors.set({
      'uid':user.uid,
      'shopName':shopName,
      'mobile':mobile,
      'email':this.email,
      'dialog':dialog,
      'address':"${this.placeName}:${this.shopAddress}",
      'location':GeoPoint(this.shopLatitude,this.shopLongitude),
      'shopOpen': true,
      'rating':0.00,
      'totalRating':0,
      'isTopPicked':true,
      'imageUrl':url,
      'accVerified':true,
    });
    return null;

  }
}