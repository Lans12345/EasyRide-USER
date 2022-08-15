import 'package:easy_ride/auth/login_page.dart';
import 'package:easy_ride/services/cloud_function/create_account_firestore.dart';
import 'package:easy_ride/widgets/error.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/dialog.dart';

Future createAccount(String email, String password, String name,
    String contactNumber, String profilePicture) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());

    createAccountFirestore(
        email, password, '+639' + contactNumber, name, profilePicture);
    dialog('Signup', 'Account Created Succesfully!', LoginPage());
  } catch (e) {
    error(e.toString());
  }
}
