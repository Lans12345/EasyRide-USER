import 'package:easy_ride/widgets/text.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget appbar(String title) {
  return AppBar(
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
    title: textBold(title, 18, Colors.black),
    centerTitle: true,
  );
}
