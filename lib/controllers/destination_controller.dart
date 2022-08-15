import 'package:get/get.dart';

class DestinationController extends GetxController {
  var destination = 'Pick Destination'.obs;

  getDestination(var myDestination) {
    destination.value = myDestination;
  }
}
