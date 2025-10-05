import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static Future<void> initGoogleSignIn({
    String? iosClientId,        // iOS: reversed client ID from GoogleService-Info.plist
    String? serverClientId,     // Optional: for server auth code
  }) async {
    final signIn = GoogleSignIn.instance;
    await signIn.initialize(
      clientId: iosClientId, // add it in a .env for privacy
      serverClientId: serverClientId,
    );
    // Optional: try silent sign-in before showing a button
    unawaited(signIn.attemptLightweightAuthentication());
  }

  static Future<UserCredential> signInWithGoogle() async {
    // On native platforms, use authenticate(); on web, use Firebase's popup/redirect
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      return FirebaseAuth.instance.signInWithPopup(provider);
    }

    // Trigger user-initiated sign-in
    final account = await GoogleSignIn.instance.authenticate(); // << v7 method
    final auth = await account.authentication;

    // For Firebase Auth you only need the ID token on mobile
    final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
    return FirebaseAuth.instance.signInWithCredential(credential);
  }
}