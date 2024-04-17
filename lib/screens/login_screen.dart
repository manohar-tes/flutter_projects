// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/screens/auth_state_screen.dart';
import 'package:flutter_application/user_auth/firebase_auth.dart';
import '../widgets/form_container_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade100,
        automaticallyImplyLeading: false,
        leading: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://blog.gympass.com/wp-content/uploads/2020/09/6943.jpg"),
                          radius: 60,
                        ),
                        const Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: 27,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            FormContainerWidget(
                              controller: _emailController,
                              hintText: "Email",
                              isPasswordField: false,
                              icon: Icons.mail_outline_rounded,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Password',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FormContainerWidget(
                                  controller: _passwordController,
                                  hintText: "Password",
                                  isPasswordField: true,
                                  icon: Icons.lock_outline_rounded,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Forget Password?',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            _signIn();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: _isSigning
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Log in",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            RichText(
              // ignore: prefer_const_constructors
              text: TextSpan(
                children: const <TextSpan>[
                  TextSpan(
                      text: 'Do not have an account? ',
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                      text: 'Signup!',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user =
        await _auth.signUpWithEmailAndPassword(email, password, context);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are logged in successfully')));
      log('User is successfully signed in');
      // showToast(message: "User is successfully signed in");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AuthStateScreen()));
    } else {
      // showToast(message: "some error occured");
    }
  }
}
