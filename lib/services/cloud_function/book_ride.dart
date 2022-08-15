import 'package:cloud_firestore/cloud_firestore.dart';

Future book(
  String username,
  String password,
  String profilePicture,
  String contactNumber,
  String name,
  double locationLatitude,
  double locationLongitude,
  String destination,
  String driverUserName,
  String driverPassword,
  String pickupLocation,
) async {
  final docUser = FirebaseFirestore.instance
      .collection('Bookings')
      .doc(driverUserName + '-' + driverPassword);

  final json = {
    'username': username,
    'password': password,
    'profilePicture': profilePicture,
    'contactNumber': contactNumber,
    'name': name,
    'locationLatitude': locationLatitude,
    'locationLongitude': locationLongitude,
    'destination': destination,
    'driverUserName': driverUserName,
    'driverPassword': driverPassword,
    'pickupLocation': pickupLocation,
  };

  await docUser.set(json);
}
