enum Flavor {
  dev,
  hml,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Tractian [Dev]';
      case Flavor.hml:
        return 'Tractian [Hml]';
      case Flavor.prod:
        return 'Tractian [Prod]';
      default:
        return 'title';
    }
  }
}
