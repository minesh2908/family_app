import 'package:family_app/UI/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../services/ToastMsg.dart';
import '../widgets/button1.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPVerifcation extends StatefulWidget {
  final vertificationId;

  const OTPVerifcation({super.key, required this.vertificationId});

  @override
  State<OTPVerifcation> createState() => _OTPVerifcationState();
}

class _OTPVerifcationState extends State<OTPVerifcation> {
  final phoneController = TextEditingController();
  String num = '';
  final auth = FirebaseAuth.instance;
  bool isLoading = false;
  String otpCode = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }
  void initPlatformState() async {
   _listenOtp();
  SmsAutoFill().code.listen((String code) {
    // Populate the OTP input field with the received code.
    phoneController.text = code;
  });
}

@override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("Unregistered Listener");
    super.dispose();
  }
  void _listenOtp() async {
    await SmsAutoFill().listenForCode();
    print("OTP Listen is called");
  }

  

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PinFieldAutoFill(
              currentCode: otpCode,
              decoration: BoxLooseDecoration(
                  radius: Radius.circular(12),
                  strokeColorBuilder: FixedColorBuilder(Color(0xFF8C4A52))),
              codeLength: 6,
              onCodeChanged: (code) {
                print("OnCodeChanged : $code");
                otpCode = code.toString();
              },
              onCodeSubmitted: (val) {
                print("OnCodeSubmitted : $val");
              },
            ),

            SizedBox(
              height: 20,
            ),
            Button1(
                loading: isLoading,
                buttonTitle: 'Verify OTP',
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  
                        PhoneAuthCredential cred = PhoneAuthProvider.credential(
                      verificationId: widget.vertificationId, smsCode: otpCode);
                      await auth.signInWithCredential(cred);
                        try {
                    
                    ToastMsg().getToastMsg('Login Succes');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));

                    setState(() {
                      isLoading = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    ToastMsg().getToastMsg(e.code.toString());
                    setState(() {
                      isLoading = false;
                    });
                  }
                  
                
                }),
            SizedBox(
              height: 20,
            ),
      
          ],
        ),
      ),
    );
  }
}
