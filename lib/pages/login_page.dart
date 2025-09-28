import 'package:auth/components/customButton.dart';
import 'package:auth/components/myTextField.dart';
import 'package:auth/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // textcontroller for email and password
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // user sign in function
  void signIn() async {
    // show log in circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      final msg = _authErrorMessage(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
    // catch (e, st) {
    //   debugPrint('Unexpected: $e\n$st');
    // }

    Navigator.pop(context);
  }

  String _authErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email looks invalid.';
      case 'user-disabled':
        return 'This account is disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in isn’t enabled for this project.';
      // With enumeration protection ON, wrong email or wrong password → invalid-credential
      case 'invalid-credential':
      case 'wrong-password': // legacy
      case 'user-not-found': // legacy (if protection is OFF)
        return 'Email or password is incorrect.';
      default:
        return 'Sign-in failed (${e.code}). Try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // logo
                Icon(Icons.lock, size: 100),

                const SizedBox(height: 50),

                // welcome text
                Text(
                  'Welcome back you\'ve been missed',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 25),

                // text field for email
                CustomTextField(
                  hintText: 'Email',
                  controller: emailController,
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // textfield for pswrd
                CustomTextField(
                  hintText: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                CustomButton(text: 'Sign In', onTap: signIn),

                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),

                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // alternative with google or apple
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(imagePath: 'lib/images/google.png'),

                    const SizedBox(width: 25),

                    // apple button
                    SquareTile(imagePath: 'lib/images/apple-logo.png'),
                  ],
                ),

                const SizedBox(height: 50),

                // not a member text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Navigate to sign up page
                      },
                      child: GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
