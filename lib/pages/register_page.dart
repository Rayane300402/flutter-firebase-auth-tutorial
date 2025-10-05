import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/customButton.dart';
import '../components/myTextField.dart';
import '../components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // textcontroller for email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // user sign in function
  void signUp() async {
    // show log in circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // check if pswrd is confirmed first
      if(passwordController.text == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        Navigator.pop(context);
      } else {
        // error msg
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password don\'t match')));
      }

    } on FirebaseAuthException catch (e) {
      final msg = _authErrorMessage(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
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
                const SizedBox(height: 25),
                // logo
                Icon(Icons.lock, size: 50),

                const SizedBox(height: 25),

                // welcome text
                Text(
                  'Let\'s create an account for you',
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

                // textfield for confirm pswrd
                CustomTextField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  obscureText: true,
                ),


                const SizedBox(height: 25),

                // sign in button
                CustomButton(text: 'Sign Up', onTap: signUp),

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
                    SquareTile(imagePath: 'lib/images/google.png', onTap: () {},),

                    const SizedBox(width: 25),

                    // apple button
                    SquareTile(imagePath: 'lib/images/apple-logo.png', onTap: () {},),
                  ],
                ),

                const SizedBox(height: 50),

                // not a member text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Existing member?',
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
                          'Log in now',
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
