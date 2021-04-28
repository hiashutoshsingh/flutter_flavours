enum Flavor {
  DEVELOPMENT,
  STAGE,
  PROD,
  CASTLE,
}

class Config {
  static Flavor appFlavor;

  static String get message {
    print('appFlavor $appFlavor');
    switch (appFlavor) {
      case Flavor.PROD:
        return 'PROD';
      case Flavor.STAGE:
        return 'STAGE';
      case Flavor.CASTLE:
        return 'CASTLE';
      default:
        return 'DEVELOPMENT';
    }
  }
}
