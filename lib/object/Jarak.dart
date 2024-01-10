class RouteInfo {
  double _jarakDalamKM;

  // Singleton instance
  static final RouteInfo _instance = RouteInfo._internal();

  factory RouteInfo() {
    return _instance;
  }

  RouteInfo._internal() : _jarakDalamKM = 0.0;

  double get jarakDalamKM => _jarakDalamKM;

  set jarakDalamKM(double value) {
    _jarakDalamKM = value;
  }
}