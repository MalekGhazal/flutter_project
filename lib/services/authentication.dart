import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final userStream = FirebaseAuth.instance
      .authStateChanges(); // Stream for monitoring user authentication state changes
  final user = FirebaseAuth.instance.currentUser; // Current user information

  Future<void> anonymousLogin() async {
    try {
      await FirebaseAuth.instance
          .signInAnonymously(); // Perform anonymous login
    } on FirebaseAuthException catch (error) {
      print(
          "firebase auth error: $error"); // Handle and log Firebase authentication errors
    }
  }

  Future<void> googleLogin() async {
    try {
      final googleUser =
          await GoogleSignIn().signIn(); // Trigger Google Sign-In
      if (googleUser == null)
        return; // If the user cancels Google Sign-In, return

      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(
          authCredential); // Sign in with Google credentials
    } on FirebaseAuthException catch (error) {
      print(
          "Google sign-in error: $error"); // Handle and log Google Sign-In errors
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut(); // Sign the user out
  }
}
