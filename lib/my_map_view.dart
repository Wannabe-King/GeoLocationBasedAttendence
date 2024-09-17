import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const myMapView='myMapView';

class MyMapView extends StatefulWidget {
  const MyMapView({super.key});

  @override
  State<MyMapView> createState() => _MyMapViewState();
}

class _MyMapViewState extends State<MyMapView> {
  final channel = const MethodChannel('myMapView');
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? AndroidView(
            viewType: myMapView,
            layoutDirection: TextDirection.ltr,
            creationParams: null,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          )
        : UiKitView(
            viewType: myMapView,
            layoutDirection: TextDirection.ltr,
            creationParams: null,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          );
  }

  void _onPlatformViewCreated(int id) {
    channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch(call.method){
      case 'sendFromNative':
        String text = call.arguments as String;
        debugPrint("text is $text");
    }
  }
}
