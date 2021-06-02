import 'package:firebase_core/firebase_core.dart';
import 'package:flavour/config.dart';
import 'package:flavour/push_notifications.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _bundledId = '';

  @override
  void initState() {
    super.initState();
    _getPhoneInfo();
  }

  Future<void> _getPhoneInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    setState(() {
      _bundledId = packageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _bundledId + '\n' + Config.appFlavor.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
