import 'package:blocsync/blocsync.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// {@template firebase_blocsync_authentication_provider}
/// An authentication provider for Blocsync that uses Firebase Authentication
/// {@endtemplate}
class FirebaseBlocsyncAuthenticationProvider implements AuthenticationProvider {
  /// {@macro firebase_blocsync_authentication_provider}
  FirebaseBlocsyncAuthenticationProvider({
    @visibleForTesting FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<String?> getToken() async {
    return _firebaseAuth.currentUser?.getIdToken();
  }
}
