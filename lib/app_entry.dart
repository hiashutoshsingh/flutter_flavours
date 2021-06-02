import 'package:firebase_core/firebase_core.dart';
import 'package:flavour/config.dart';
import 'package:flavour/push_notifications.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    print('initState ' + Config.message);
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    await PushNotificationsManager().init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter'),
    );
  }
}
