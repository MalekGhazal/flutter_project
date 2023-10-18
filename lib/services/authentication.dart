import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// `AuthService` is a class responsible for handling user authentication through Firebase.
///
/// This service provides methods for anonymous login, Google login, and sign-out. It also offers
/// access to the current user's authentication state and details.
///
/// Key Functionalities:
/// 1. Monitor user authentication state changes with `userStream`.
/// 2. Retrieve the current logged-in user's details with `user`.
/// 3. Sign in anonymously with `anonymousLogin`.
/// 4. Sign in using Google with `googleLogin`.
/// 5. Sign out the user with `signOut`.
///
/// Dependencies:
/// - `firebase_auth.dart`: Firebase authentication package.
/// - `google_sign_in.dart`: Google Sign-In package.
///
/// Example:
/// ```dart
/// AuthService authService = AuthService();
/// await authService.googleLogin(); // This will trigger Google Sign-In
/// ```
///
/// Errors during the authentication processes are caught and logged to the console, ensuring that
/// the app doesn't crash due to authentication issues.

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
