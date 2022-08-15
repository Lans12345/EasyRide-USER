import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/services/cloud_function/book_ride.dart';
import 'package:easy_ride/services/error.dart';
import 'package:easy_ride/utils/routes.dart';
import 'package:easy_ride/widgets/button.dart';
import 'package:easy_ride/widgets/dialog.dart';
import 'package:easy_ride/widgets/drawer.dart';
import 'package:easy_ride/widgets/image.dart';
import 'package:easy_ride/widgets/search.dart';
import 'package:easy_ride/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../controllers/destination_controller.dart';
import '../widgets/error.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

late double lat = 0;
late double long = 0;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    locationNotif();

    // myLocationMarker();
    fetchDrivers();
    getData();
  }

  final box = GetStorage();

  late String myName = '';
  late String myContactNumber = '';

  late String myUserName = '';
  late String myPassword = '';
  late String myProfilePicture = '';

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
        myName = data['name'];
        myContactNumber = data['contactNumber'];
        myUserName = data['username'];
        myPassword = data['password'];
        myProfilePicture = data['profilePicture'];
      }
    });
  }

  fetchDrivers() async {
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('Drivers')
        .where('type', isEqualTo: 'driver')
        .where('status', isEqualTo: 'on');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        driverMarker(
          data['name'],
          data['contactNumber'],
          data['vehicleType'],
          data['plateNumber'],
          data['locationLatitude'],
          data['locationLongitude'],
          data['profilePicture'],
          data['carPicture'],
          data['username'],
          data['password'],
        );
      }
    });
  }

  var hasLoaded = true;

  Future<Position> locationNotif() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return await Geolocator.getCurrentPosition();
  }

  Set<Marker> markers = {};

  int numberOfPassengers = 1;

  final myController = Get.find<DestinationController>();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  myLocationMarker() {
    Marker mark1 = Marker(
        markerId: const MarkerId('mark1'),
        infoWindow: const InfoWindow(
          title: 'Your Location',
        ),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(lat, long));

    setState(() {
      markers.add(mark1);
    });
  }

  driverMarker(
      String name,
      String contactNumber,
      String vehicleType,
      String plateNumber,
      double locationLatitude,
      double locationLongitude,
      String profilePicture,
      String carPicture,
      String driverUserName,
      String driverPassword) async {
    Marker mark2 = Marker(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.grey[100],
            context: context,
            builder: (context) => SizedBox(
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  textBold('Booking', 24, Colors.black),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            minRadius: 50,
                            maxRadius: 50,
                            backgroundImage: NetworkImage(profilePicture),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          textBold(name, 14, Colors.black),
                          const SizedBox(
                            height: 5,
                          ),
                          textReg(contactNumber, 12, Colors.black),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            minRadius: 50,
                            maxRadius: 50,
                            backgroundImage: NetworkImage(carPicture),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          textBold(vehicleType, 14, Colors.black),
                          const SizedBox(
                            height: 5,
                          ),
                          textReg(plateNumber, 12, Colors.black),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_history,
                        size: 28,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: Center(
                            child: textReg(
                              'Your Location',
                              16,
                              Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.my_location_rounded,
                        size: 28,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: MySearchDelegate(),
                          );
                        },
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(46, 10, 46, 10),
                            child: Center(
                              child: textReg(
                                myController.destination.value,
                                16,
                                Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Button(
                    color: Colors.black,
                    text: 'Confirm',
                    onPressed: () async {
                      List<Placemark> p =
                          await placemarkFromCoordinates(lat, long);

                      Placemark place = p[0];

                      print(
                          "${place.locality}, ${place.thoroughfare}, ${place.street},");

                      print(myUserName);
                      print(myPassword);
                      print(myProfilePicture);
                      print(myContactNumber);
                      print(myName);
                      print(lat);
                      print(long);
                      print(myController.destination.value);
                      print(driverUserName);
                      print(driverPassword);

                      bool hasInternet =
                          await InternetConnectionChecker().hasConnection;

                      if (hasInternet == true) {
                        if (myController.destination.value ==
                            'Pick Destination') {
                          errorDialog(
                              'Choose your Destination', 'Cannot Procceed');
                        } else {
                          bookDialog(() async {
                            try {
                              bool serviceEnabled;
                              LocationPermission permission;

                              // Test if location services are enabled.
                              serviceEnabled =
                                  await Geolocator.isLocationServiceEnabled();
                              if (!serviceEnabled) {
                                // Location services are not enabled don't continue
                                // accessing the position and request users of the
                                // App to enable the location services.
                                error2("Phone's location is off",
                                    'Cannot Procceed', () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
                                });
                              } else {
                                book(
                                    myUserName,
                                    myPassword,
                                    myProfilePicture,
                                    myContactNumber,
                                    myName,
                                    lat,
                                    long,
                                    myController.destination.value,
                                    driverUserName,
                                    driverPassword,
                                    "${place.locality}, ${place.thoroughfare}, ${place.street},");

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Booked Succesfully!'),
                                  ),
                                );
                                routeOff(const HomePage());
                              }
                            } catch (e) {
                              error(e.toString());
                            }
                          });
                        }
                      } else {
                        errorDialog(
                            'Connection Status', 'No Internet Connection');
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
        markerId: MarkerId(name),
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size(24, 24),
          ),
          vehicleTypeMarker(vehicleType),
        ),
        position: LatLng(locationLatitude, locationLongitude));

    setState(() {
      markers.add(mark2);
    });
  }

  vehicleTypeMarker(String vehicleType) {
    if (vehicleType == 'Taxi') {
      return 'assets/images/taxi.png';
    } else if (vehicleType == 'Habal habal') {
      return 'assets/images/habalhabal.png';
    } else if (vehicleType == 'Rela') {
      return 'assets/images/rela.png';
    } else if (vehicleType == 'Jeep') {
      return 'assets/images/jeep.png';
    }
  }

  final Completer<GoogleMapController> _controller = Completer();
  // Change to CDO
  static CameraPosition myLocation = const CameraPosition(
    target: LatLng(8.311283, 125.004636),
    zoom: 16,
  );

  String _currentAddress = '';

  late String _startAddress = '';

  final startAddressController = TextEditingController();

  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(lat, long);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.subLocality}, ${place.street}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: textBold('Home', 24, Colors.black),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: textBold(
                                'Vehicle Guide',
                                16,
                                Colors.black,
                              ),
                              content: SizedBox(
                                height: 250,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.blue[200],
                                            border: Border.all(
                                                color: Colors.white, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(1000),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        textReg(
                                          '(Blue Dot) - Your Location',
                                          12,
                                          Colors.black,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        image('assets/images/taxi.png', 35, 35,
                                            EdgeInsets.zero),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        textReg(
                                          '- Taxi',
                                          18,
                                          Colors.black,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        image('assets/images/habalhabal.png',
                                            35, 35, EdgeInsets.zero),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        textReg(
                                          '- Habal habal',
                                          18,
                                          Colors.black,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        image('assets/images/rela.png', 35, 35,
                                            EdgeInsets.zero),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        textReg(
                                          '- Rela',
                                          18,
                                          Colors.black,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        image('assets/images/jeep.png', 35, 35,
                                            EdgeInsets.zero),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        textReg(
                                          '- Jeep',
                                          18,
                                          Colors.black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: textBold(
                                    'Close',
                                    12,
                                    Colors.black,
                                  ),
                                ),
                              ],
                            ));
                  },
                  icon: const Icon(
                    Icons.info,
                    size: 28,
                  ),
                )),
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              markers: Set<Marker>.from(markers),
              mapType: MapType.normal,
              initialCameraPosition: myLocation,
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);

                setState(() {
                  lat = position.latitude;
                  long = position.longitude;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 120, right: 120, top: 5, bottom: 5),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                color: Colors.black38,
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.refresh,
                      size: 15,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    textReg('Refresh', 12, Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
