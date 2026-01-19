
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifelink/screens/login.dart';

import '../screens/home_screen.dart';
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1) Still connecting → show splash
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2) Error state (optional handling)
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }

        // 3) No user → show Sign In / Sign Up screen
        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreenMain();
        }

        // 4) User exists → show Home
        final user = snapshot.data!;
        // Optional: if you require email verification
        // if (!user.emailVerified) return const VerifyEmailScreen();

        return const HomeScreen();
      },
    );
  }
}
