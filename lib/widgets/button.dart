import 'package:easy_ride/widgets/text.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  late String text = '';
  late Color color;

  void Function() onPressed;

  Button({required this.color, required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: color,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
        child: textBold(text, 12, Colors.white),
      ),
    );
  }
}
