import 'package:flutter/material.dart';
import 'package:get/get.dart';

routeOff(Widget route) {
  return Get.off(() => route);
}

routeTo(Widget route) {
  return Get.to(() => route);
}
