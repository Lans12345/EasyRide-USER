import 'package:get/get.dart';

import 'package:flutter/material.dart';

dialog(String title, String message, Widget gt) {
  return Get.defaultDialog(
    radius: 5.0,
    title: title,
    middleText: message,
    confirm: Padding(
      padding: const EdgeInsets.only(left: 0),
      child: TextButton(
        onPressed: () {
          Get.back();
          Get.off(() => gt, transition: Transition.zoom);
        },
        child: const Text(
          'Continue',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

dialogWithClose(String title, String message, void Function() onPressed) {
  return Get.defaultDialog(
    radius: 5.0,
    title: title,
    middleText: message,
    cancel: TextButton(
      onPressed: () {
        Get.back();
      },
      child: const Text(
        'Close',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    confirm: Padding(
      padding: const EdgeInsets.only(left: 50),
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          'Continue',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

dialogCloseOnly(String title, String message) {
  return Get.defaultDialog(
    radius: 5.0,
    title: title,
    middleText: message,
    cancel: TextButton(
      onPressed: () {
        Get.back();
      },
      child: const Text(
        'Close',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  );
}

bookDialog(void Function() onPressed) {
  return Get.defaultDialog(
    barrierDismissible: false,
    radius: 5.0,
    title: 'Booking Confirmation',
    middleText: 'Are you sure you want to book a ride?',
    cancel: TextButton(
      onPressed: () {
        Get.back();
      },
      child: const Text(
        'Cancel',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    confirm: Padding(
      padding: const EdgeInsets.only(left: 50),
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          'Continue',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
