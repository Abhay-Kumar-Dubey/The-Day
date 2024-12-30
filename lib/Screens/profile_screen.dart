import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late String name;

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile Screen'),
        ),
        body: ProfileScreen(
          avatar: Container(
            height: 150,
            color: Colors.black,
            child: Image.asset(
              'assets/animations/The Day.png',
              width: 100,
            ),
          ),
          providers: [EmailAuthProvider()],
          actions: [
            DisplayNameChangedAction(
              (context, oldName, newName) {
                name = newName;
              },
            )
          ],
        ));
  }
}
