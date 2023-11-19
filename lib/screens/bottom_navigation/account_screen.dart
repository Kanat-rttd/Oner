// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'account_screen_components/body.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: const Body(),
    );
  }
}
