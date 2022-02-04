import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add getter to retrieve user
  User? get user {
    return _auth.currentUser;
  }

  // Sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      return e;
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      return e;
    }
  }

  // Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      return e;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return e;
    }
  }

  String getError(error, BuildContext context) {
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        return AppLocalizations.of(context)!.malformedEmail;
      case "ERROR_WRONG_PASSWORD":
        return AppLocalizations.of(context)!.wrongPassword;
      case "ERROR_USER_NOT_FOUND":
        return AppLocalizations.of(context)!.userNotFound;
      case "ERROR_USER_DISABLED":
        return AppLocalizations.of(context)!.userDisabled;
      case "ERROR_TOO_MANY_REQUESTS":
        return AppLocalizations.of(context)!.toManyRequests;
      case "ERROR_OPERATION_NOT_ALLOWED":
        return AppLocalizations.of(context)!.operationNotAllowed;
      default:
        return AppLocalizations.of(context)!.undefinedError;
    }
  }
}