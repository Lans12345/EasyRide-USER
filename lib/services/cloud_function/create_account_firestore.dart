import 'package:cloud_firestore/cloud_firestore.dart';

Future createAccountFirestore(
  String username,
  String password,
  String contactNumber,
  String name,
  String profilePicture,
) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(username + '-' + password);

  final json = {
    'username': username,
    'password': password,
    'contactNumber': contactNumber,
    'name': name,
    'booking': 0,
    

    'type': 'user',
    'profilePicture': profilePicture
  };

  await docUser.set(json);
}
