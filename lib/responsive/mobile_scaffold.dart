import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:r_e_s/screens/mobile/all_screens/all_screens.dart';
import 'package:r_e_s/screens/mobile/auth/login/login.dart';

class MobileScaffold extends StatelessWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser != null) ? AllScreens() : Login();
  }
}
