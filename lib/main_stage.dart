import 'package:flavour/config.dart';
import 'package:flutter/material.dart';

import 'app_entry.dart';

void main() {
  Config.appFlavor = Flavor.STAGE;
  print('STAGE');
  runApp(new MyApp());
}
