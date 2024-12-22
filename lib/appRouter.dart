import 'package:day_counter/Screens/home_Screen.dart';
import 'package:day_counter/Screens/profile_screen.dart';
import 'package:day_counter/Screens/signIn_Screen.dart';
import 'package:day_counter/goRouter_Stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum appRoutes {
  home,
  signIn,
  profile,
}

final FirebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(FirebaseAuthProvider);
  return GoRouter(
      initialLocation: '/signIn',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        if (auth.currentUser != null) {
          if (state.uri.path == '/signIn') return '/home';
        } else {
          return '/signIn';
        }
        return null;
      },
      refreshListenable: GoRouterRefreshStream(auth.authStateChanges()),
      routes: [
        GoRoute(
            path: '/signIn',
            builder: (context, state) => const customSignInScreen(),
            name: appRoutes.signIn.name),
        GoRoute(
            path: '/home',
            name: appRoutes.home.name,
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                  path: 'profile',
                  name: appRoutes.profile.name,
                  builder: (context, state) => const CustomProfileScreen())
            ]),
      ]);
});
