import 'package:family_app/UI/widgets/button1.dart';
import 'package:family_app/services/ToastMsg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final auth = FirebaseAuth.instance;

  final emailController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Enter Registered Email'),
            ),
            SizedBox(
              height: 20,
            ),
            Button1(
                buttonTitle: 'Send Recovery Email',
                loading: loading,
                onPressed: () {
                  setState(() {
                    loading = true;
                  });
                  auth
                      .sendPasswordResetEmail(email: emailController.text.toString())
                      .then((value) {
                    ToastMsg().getToastMsg('Email Sent');
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    ToastMsg().getToastMsg(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                })
          ],
        ),
      ),
    );
  }
}
