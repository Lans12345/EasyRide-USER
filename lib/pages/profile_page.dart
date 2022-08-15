import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/screens/home.dart';
import 'package:easy_ride/widgets/appbar.dart';
import 'package:easy_ride/widgets/button.dart';
import 'package:easy_ride/widgets/drawer.dart';
import 'package:easy_ride/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    getData();

    super.initState();
  }

  final box = GetStorage();

  var name = '';
  var contactNumber = '';
  var booking = 0;
  var profilePicture = '';

  var newContactNumber = '';

  getData() async {
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: box.read('username'))
        .where('password', isEqualTo: box.read('password'))
        .where('type', isEqualTo: 'user');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        name = data['name'];
        contactNumber = data['contactNumber'];
        booking = data['booking'];
        profilePicture = data['profilePicture'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: appbar('Profile'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CircleAvatar(
                minRadius: 50,
                maxRadius: 50,
                backgroundImage: NetworkImage(profilePicture),
              ),
              const SizedBox(
                height: 10,
              ),
              textBold(
                name,
                22,
                Colors.black,
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 50),
                child: ListTile(
                  trailing: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: textBold(
                                    'New Contact Number', 16, Colors.black),
                                content: TextFormField(
                                  style: const TextStyle(
                                      fontFamily: 'QRegular',
                                      fontSize: 14,
                                      color: Colors.black),
                                  maxLength: 9,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefix: textReg('+639', 14, Colors.black),
                                  ),
                                  onChanged: (_input) {
                                    newContactNumber = _input;
                                  },
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(box.read('username') +
                                              '-' +
                                              box.read('password'))
                                          .update({
                                        'contactNumber':
                                            '+639' + newContactNumber
                                      });
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfilePage()));
                                    },
                                    child:
                                        textBold('Continue', 15, Colors.black),
                                  ),
                                ],
                              ));
                    },
                    icon: const Icon(Icons.edit, color: Colors.green),
                  ),
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                  ),
                  title: textReg(contactNumber, 18, Colors.black),
                  subtitle: textReg('Contact Number', 10, Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.bookmark_added_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  title: textReg(booking.toString(), 18, Colors.black),
                  subtitle: textReg('Total Bookings', 10, Colors.grey),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Button(
                  color: Colors.black,
                  text: 'Home',
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
