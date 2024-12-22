import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class customSignInScreen extends ConsumerWidget {
  const customSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign In'),
        ),
        body: SignInScreen(
          providers: [EmailAuthProvider()],
        ));
  }
}
