import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ToastMsg{
  
  void getToastMsg(String message){
      Fluttertoast.showToast(msg: message, timeInSecForIosWeb: 5);
  }
}