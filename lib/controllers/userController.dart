import 'package:get/get.dart';

class UserController extends GetxController {
  var data = 0.obs;

  getFirstName(var fn) {
    data.value = fn;
  }
}
