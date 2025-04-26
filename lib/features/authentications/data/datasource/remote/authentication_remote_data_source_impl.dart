import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/features/authentications/data/datasource/remote/authentication_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRemoteDataSourceImpl
    extends AuthenticationRemoteDataSource {
  @override
  Future<bool> register(String email, String password) async {
    try {
      final userCredentials = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredentials.user != null) {
        await userCredentials.user!.sendEmailVerification();
        auth.signOut();
        return true;
      }
      Get.snackbar("Error", "Could not register an account. Try again");
      return false;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == "email-already-in-use") {

          Get.snackbar("Error", "Email already exists");
        }
      } else {
        Get.snackbar("Error","Could not register an account. Try again");
      }
      return false;
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.user != null && user.user!.emailVerified) {
        return user.user;
      }else if(user.user != null && !user.user!.emailVerified){
        Get.snackbar("Error", "Please verity email that sent to $email before login in");
      }
      await user.user!.sendEmailVerification();
      await auth.signOut();
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final user = await auth.signInWithCredential(credential);
      if (user.user != null) {
        return user.user;
      }
      return null;
    } on FirebaseAuthException catch (error) {
      if (error.code == "") {}
      return null;
    }
  }

  @override
  Future<bool> registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount!.authentication;
      final credentials = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final UserCredential userCredential = await auth.signInWithCredential(
        credentials,
      );
      if (userCredential.user != null) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
