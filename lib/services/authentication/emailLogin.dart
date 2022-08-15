import 'package:easy_ride/screens/home.dart';
import 'package:easy_ride/widgets/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

Future signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    Get.off(() => const HomePage());
  } catch (e) {
    error(e.toString());
  }
}
