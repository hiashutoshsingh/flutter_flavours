enum Flavor {
  DEVELOPMENT,
  STAGE,
  PROD,
  CASTLE,
}

class Config {
  static Flavor appFlavor;

  static String get message {
    switch (appFlavor) {
      case Flavor.PROD:
        return 'PROD';
      case Flavor.STAGE:
        return 'STAGE';
      case Flavor.CASTLE:
        return 'CASTLE';
      case Flavor.DEVELOPMENT:
      default:
        return 'DEVELOPMENT';
    }
  }
}
