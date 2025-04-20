import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Email/Password Registration
  Future<UserCredential?> register(String name, String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optionally update display name
      await userCredential.user?.updateDisplayName(name);

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // ✅ Email/Password Login
  Future<UserCredential?> login(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Custom error messages for Firebase-specific issues
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email.';
        case 'wrong-password':
          throw 'Incorrect password.';
        case 'invalid-email':
          throw 'Invalid email address.';
        case 'user-disabled':
          throw 'This user has been disabled.';
        default:
          throw e.message ?? 'An unknown Firebase error occurred.';
      }
    } catch (e) {
      throw 'Something went wrong: $e';
    }
  }

  // ✅ Social Login (Google & Facebook)
  Future<UserCredential?> socialLogin(String provider) async {
    try {
      UserCredential userCredential;

      if (provider == 'Google') {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);

      } else if (provider == 'Facebook') {
        final LoginResult result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.success) {
          final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
          userCredential = await _auth.signInWithCredential(credential);
        } else {
          throw Exception('Facebook login failed: ${result.message}');
        }

      } else {
        throw Exception("Unsupported provider: $provider");
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }
}
