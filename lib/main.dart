import 'dart:async';
import 'dart:io';
import 'package:beach_suitablility_app/my_map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const locationChannel = MethodChannel("locationPermissionPlatform");
  final eventChannel = const EventChannel('com.example.locationconnectivity');
  StreamSubscription? subscription;
  bool isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    subscription =
        eventChannel.receiveBroadcastStream().listen((dynamic event) {
      print('Received: Sevent');
      // Handle the received location here
    }, onError: (dynamic error) {
      print('Received error: ${error.message}');
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
            child: Platform.isAndroid
                ? Column(
                    children: [
                      TextButton(
                          onPressed: () async {
                            try {
                              bool data = await locationChannel
                                  .invokeMethod('getLocationPermission');
                              setState(() {
                                isPermissionGranted = data;
                              });
                            } on PlatformException catch (e) {
                              debugPrint("Fail: '${e.message}'");
                            }
                          },
                          child: const Text("Get location permission")),
                      isPermissionGranted
                          ? SizedBox(
                              width: width,
                              height: height / 1.2,
                              child: const MyMapView(),
                            )
                          : const SizedBox()
                    ],
                  )
                : SizedBox(
                    width: width,
                    height: height / 1.5,
                    child: const MyMapView(),
                  )));
  }
}
