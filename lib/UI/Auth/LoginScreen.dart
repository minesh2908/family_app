import 'package:family_app/UI/Auth/OTPLogin.dart';
import 'package:family_app/UI/Auth/RegisterScreen.dart';
import 'package:family_app/UI/Auth/forgotPassword.dart';
import 'package:family_app/UI/home_screen.dart';
import 'package:family_app/UI/widgets/button1.dart';
import 'package:family_app/services/ToastMsg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool showPasswod = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('LogIn Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email can not be Empty';
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Enter Email',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: showPasswod ? false : true,
                controller: passcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password Can not be Empty';
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPasswod = !showPasswod;
                        });
                      },
                      icon: showPasswod
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Enter Password',
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()));
                  },
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Text('Forgot Password?'))),
              Button1(
                buttonTitle: 'Login',
                loading: isLoading,
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  if (_formKey.currentState!.validate()) {
                    auth
                        .signInWithEmailAndPassword(
                            email: emailcontroller.text.toString(),
                            password: passcontroller.text.toString())
                        .then((value) {
                      ToastMsg().getToastMsg('Login Succesful');
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }).onError((error, stackTrace) {
                      setState(() {
                        isLoading = false;
                      });
                      ToastMsg().getToastMsg(error.toString());
                    });
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Button1(
                buttonTitle: 'Register',
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Button1(
                buttonTitle: 'Login with OTP',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OTPLoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
