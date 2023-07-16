import 'package:family_app/UI/Auth/OTPVerification.dart';
import 'package:family_app/UI/widgets/button1.dart';
import 'package:family_app/services/ToastMsg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPLoginScreen extends StatefulWidget {
  const OTPLoginScreen({super.key});

  @override
  State<OTPLoginScreen> createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  final phoneController = TextEditingController();
  String num = '';
  final auth = FirebaseAuth.instance;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String verificationId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IntlPhoneField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Phone Number'),
                onChanged: (value) {
                  num = value.completeNumber;
                  // print(num);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Button1(
                  buttonTitle: 'Send OTP',
                  loading: isLoading,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if(_formKey.currentState!.validate()){
                       var appSignature = await SmsAutoFill().getAppSignature;
                  
                   await auth.verifyPhoneNumber(
                        phoneNumber: num,
                        verificationCompleted: (PhoneAuthCredential credential) {
                          print("Phone credentials $credential");
                          setState(() {
                            isLoading = false;
                        

                          });
                        },
                        verificationFailed: (e) {
                          ToastMsg().getToastMsg(e.code.toString());
                          setState(() {
                            isLoading = false;
                          });
                        },
                        codeSent: (String verification, int? token) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return OTPVerifcation(
                                vertificationId: verification);
                          }));
                        },
                        codeAutoRetrievalTimeout: (String verification) {
                         Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return OTPVerifcation(
                                vertificationId: verification);
                          })); 
                        });
                        print('App Signature $appSignature');
                    }
                    
                   
                  })
            ],
          ),
        ),
      ),
    );
  }
}
