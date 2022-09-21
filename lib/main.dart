import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:torch_light/torch_light.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isOn = false;
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [exibeImagem(), Text('A mãe está  $_isNear\n')],
        ),
      ),
    );
  }

  Future<void> _torchLight() async {
    if (!isOn) {
      isOn = true;
      try {
        await TorchLight.disableTorch();
      } on Exception catch (_) {
        print('error disabling torch light');
      }
    } else {
      isOn = false;
      try {
        await TorchLight.enableTorch();
      } on Exception catch (_) {
        print('error enabling torch light');
      }
    }
  }

  Future<void> _vibrate() async {
    Vibration.vibrate(duration: 1500, amplitude: 128);
  }

  Widget exibeImagem() {
    if (_isNear == true) {
      isOn = true;
      _torchLight();
      return const Image(
        image: AssetImage("assets/imagens/Eleven.jpg"),
        width: 200,
        height: 200,
      );
    } else {
      isOn = false;
      _torchLight();
      return const Image(
        image: AssetImage("assets/imagens/demon.jpg"),
        width: 200,
        height: 200,
      );
    }
  }
}
