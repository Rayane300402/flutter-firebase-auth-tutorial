import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  //sign user out method
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout_outlined, color: Colors.grey[700],)),
        ],
      ),
      body: Center(child: Text(
          'Logged In As: ' + user.email!,
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[700],
          ),
      )
      ),
    );
  }
}
