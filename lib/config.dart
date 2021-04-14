enum Flavor {
  DEVELOPMENT,
  STAGE,
  PROD,
}

class Config {
  static Flavor appFlavor;

  static String get message {
    switch (appFlavor) {
      case Flavor.PROD:
        return 'PROD';
      case Flavor.STAGE:
        return 'STAGE';
      case Flavor.DEVELOPMENT:
      default:
        return 'DEVELOPMENT';
    }
  }
}
