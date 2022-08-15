import 'package:flutter/material.dart';
import 'package:get/get.dart';

errorDialog(String e, String title) {
  return Get.defaultDialog(
    radius: 5.0,
    title: title,
    middleText: e,
    cancel: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: TextButton(
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
        ),
      ],
    ),
  );
}
