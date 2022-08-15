import 'dart:io';

import 'package:easy_ride/services/error.dart';
import 'package:easy_ride/widgets/text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../services/authentication/create_account_signin.dart';
import '../widgets/error.dart';
import 'package:path/path.dart' as path;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late String username = '';
  late String password = '';
  late String name = '';
  late String contactNumber = '';

  var hasLoaded = false;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  late String fileName = '';
  late File imageFile;

  late String imageURL = '';

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Text(
              '         Loading . . .',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand'),
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Users/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Users/$fileName')
            .getDownloadURL();

        setState(() {
          hasLoaded = true;
        });

        Navigator.of(context).pop();
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 75,
            ),
            hasLoaded
                ? CircleAvatar(
                    backgroundColor: Colors.blue[200],
                    minRadius: 50,
                    maxRadius: 50,
                    backgroundImage: NetworkImage(imageURL),
                  )
                : GestureDetector(
                    onTap: () {
                      uploadPicture('gallery');
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[500],
                      minRadius: 50,
                      maxRadius: 50,
                      child: const Center(
                        child: Icon(
                          Icons.camera_enhance,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            textBold('Login Credentials', 12.0, Colors.grey),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: TextFormField(
                style: const TextStyle(
                    color: Colors.grey, fontFamily: 'Quicksand'),
                onChanged: (_input) {
                  username = _input;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  labelText: 'Username',
                  labelStyle: const TextStyle(
                    fontFamily: 'Quicksand',
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: TextFormField(
                style: const TextStyle(
                    color: Colors.grey, fontFamily: 'Quicksand'),
                onChanged: (_input) {
                  password = _input;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    fontFamily: 'Quicksand',
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            textBold("User's Information", 12.0, Colors.grey),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(
                    color: Colors.grey, fontFamily: 'Quicksand'),
                onChanged: (_input) {
                  name = _input;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  labelText: 'Full Name',
                  labelStyle: const TextStyle(
                    fontFamily: 'Quicksand',
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 9,
                style: const TextStyle(
                    color: Colors.grey, fontFamily: 'Quicksand'),
                onChanged: (_input) {
                  contactNumber = _input;
                },
                decoration: InputDecoration(
                  prefix: const Text('+639'),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  labelText: 'Contact Number',
                  labelStyle: const TextStyle(
                    fontFamily: 'Quicksand',
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                color: Colors.black,
                onPressed: () async {
                  bool hasInternet =
                      await InternetConnectionChecker().hasConnection;

                  if (hasInternet == true) {
                    if (password.length >= 6) {
                      if (username.length >= 6) {
                        if (contactNumber.length >= 9) {
                          if (name != '') {
                            createAccount(username + '@easyride.cdo', password,
                                name, contactNumber, imageURL);
                          } else {
                            error('Invalid Name');
                          }
                        } else {
                          error('Invalid Contact Number');
                        }
                      } else {
                        errorDialog('Username too short', 'Cannot Procceed');
                      }
                    } else {
                      errorDialog('Password too short', 'Cannot Procceed');
                    }
                  } else {
                    error('No Internet Connection');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 60, right: 60),
                  child: textReg('Create Account', 14.0, Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      )),
    );
  }
}
