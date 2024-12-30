import 'package:day_counter/appRouter.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';

class customSignInScreen extends ConsumerWidget {
  const customSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: SignInScreen(
      providers: [
        EmailAuthProvider(),
        GoogleProvider(
            clientId:
                "24075259655-9birbgil23hi460avp1j8320id4ib7ku.apps.googleusercontent.com")
      ],
      actions: [
        AuthStateChangeAction<SignedIn>(
          (context, state) {
            context.goNamed(appRoutes.profile.name);
          },
        )
      ],
      headerBuilder: (context, constraints, _) {
        return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              color: Colors.black,
              child: Column(children: [
                Image.asset(
                  'assets/animations/The Day.png', // Replace with your app logo path
                  height: 100,
                ),
                const SizedBox(height: 10),
              ]),
            ));
      },
      footerBuilder: (context, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: const Text(
            'By signing in, you agree to our Terms and Conditions.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        );
      },
    ));
  }
}
