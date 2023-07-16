import 'package:family_app/UI/Auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/ToastMsg.dart';
import '../widgets/button1.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool showPasswod = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Can not be Empty';
                  }
                },
                controller: emailController,
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
                
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Can not be empty';
                  } else if (value!.toString().length < 6) {
                    return 'Password Can not be less than 6 characters';
                  }
                },
                 obscureText: showPasswod ? false : true,
                controller: passController,
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
              SizedBox(
                height: 20,
              ),
              
              Button1(
                buttonTitle: 'Register',
                loading: isLoading,
                onPressed: () async{
                  setState(() {
                        isLoading=true;
                      });
                  if (await _formKey.currentState!.validate()) {
                    try{
                      await
                      auth
                        .createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passController.text.toString());
                            ToastMsg().getToastMsg('Registration Succesfull');
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                        setState(() {
                        isLoading=false;
                      });
                  
                    } on FirebaseAuthException catch(e){
                      setState(() {
                        isLoading=false;
                      });
                      if(e.code=='email-already-in-use'){
                        ToastMsg().getToastMsg('Email Already in Use! Please Sign In');
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                      }
                      else if(e.code=='invalid-email'){
                        ToastMsg().getToastMsg('Incorrect Email Format');
                        
                      }
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Button1(
                buttonTitle: 'Login with OTP',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
