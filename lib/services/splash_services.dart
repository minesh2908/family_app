import 'dart:async';

import 'package:family_app/UI/Auth/LoginScreen.dart';
import 'package:family_app/UI/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SplashService {
  final auth = FirebaseAuth.instance;
  void splashServiceTime(context) {
    Timer(Duration(seconds: 5), () {
      if(auth.currentUser!=null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }
      else{Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
      });
  }
}
