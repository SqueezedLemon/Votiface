import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future signIn({required String email, required String password}) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return null;
  } on FirebaseAuthException catch (e) {
    return e.message;
  }
}
